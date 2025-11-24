import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';

// Enable this to force logs even in release/profile runs.
const bool _logDeviceToken = true;

class SaveDeviceTokenState extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Repository rep = Repository();
  final AppVerification appVerification = Get.put(AppVerification());

  StreamSubscription<String>? _tokenSub;
  Timer? _apnsRetryTimer;
  bool _permissionRequested = false;
  bool _tokenSaved = false;
  String? _lastSavedToken;
  bool _saveQueued = false;
  PackageInfo? _pkgInfo;

  @override
  void onInit() {
    super.onInit();
    // Ensure FCM auto-init is on (default true, but force for safety).
    _firebaseMessaging.setAutoInitEnabled(true);

    // Auto-save when FCM issues/refreshes a token (e.g., after permissions/APNs become available)
    _tokenSub = _firebaseMessaging.onTokenRefresh.listen((token) {
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] onTokenRefresh: $token');
      }
      _saveQueued = true;
      _saveToken(token);
    });
  }

  @override
  void onClose() {
    _tokenSub?.cancel();
    _apnsRetryTimer?.cancel();
    super.onClose();
  }

  /// Called after login; queues save and attempts immediately.
  Future<void> postSaveDeviceToken() async {
    _saveQueued = true;
    await _ensurePermissionAndToken();
  }

  Future<void> _ensurePermissionAndToken() async {
    try {
      if (!_permissionRequested) {
        final perm = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        _permissionRequested = true;
        if (kDebugMode || _logDeviceToken) {
          print('[SaveDeviceTokenState] notification permission: ${perm.authorizationStatus}');
          if (perm.authorizationStatus == AuthorizationStatus.denied ||
              perm.authorizationStatus == AuthorizationStatus.notDetermined) {
            print('[SaveDeviceTokenState] ⚠️ Permission not granted; token save may fail.');
          }
        }
      }

      // For iOS, wait for APNs; skip simulator gracefully.
      if (Platform.isIOS) {
        try {
          await _firebaseMessaging.setAutoInitEnabled(true);
        } catch (_) {}

        final apns = await _firebaseMessaging.getAPNSToken();
        if (kDebugMode || _logDeviceToken) {
          print('[SaveDeviceTokenState] APNs token: ${apns ?? 'null'}');
        }
        if (apns == null || apns.isEmpty) {
          if (kDebugMode || _logDeviceToken) {
            print('[SaveDeviceTokenState] ⚠️ APNs token not available yet (simulator cannot receive push). Retrying with backoff...');
          }
          _scheduleApnsRetry();
          return;
        }
      }

      final token = await _firebaseMessaging.getToken();
      await _saveToken(token);
    } catch (e) {
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] error: $e');
      }
    }
  }

  void _scheduleApnsRetry() {
    _apnsRetryTimer?.cancel();
    const delays = [1, 2, 4, 8, 16, 32]; // seconds, ~63s max
    int attempt = 0;

    Future<void> tryOnce() async {
      final apns = await _firebaseMessaging.getAPNSToken();
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] retry APNs attempt $attempt -> ${apns ?? 'null'}');
      }
      if (apns != null && apns.isNotEmpty) {
        final token = await _firebaseMessaging.getToken();
        await _saveToken(token);
        return;
      }
      if (attempt >= delays.length) {
        if (kDebugMode || _logDeviceToken) {
          print('[SaveDeviceTokenState] APNs still null after retries; skipping until next session/refresh.');
        }
        return;
      }
      final delay = delays[attempt++];
      _apnsRetryTimer = Timer(Duration(seconds: delay), tryOnce);
    }

    tryOnce();
  }

  Future<void> _saveToken(String? token) async {
    if (!_saveQueued) {
      // Only save when requested (e.g., after login) to avoid anonymous tokens.
      return;
    }

    if (kDebugMode || _logDeviceToken) {
      print('[SaveDeviceTokenState] got FCM token: ${token ?? 'null'}');
    }
    if (token == null || token.isEmpty) {
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] token is null/empty; skip save.');
      }
      return;
    }

    if (_tokenSaved && _lastSavedToken == token) {
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] token already saved this session; skipping.');
      }
      return;
    }

    final uri = Uri.parse(rep.nuXtJsUrlApi + rep.saveDeviceToken);
    final authToken = appVerification.nUxtToken.isNotEmpty
        ? appVerification.nUxtToken
        : appVerification.token;
    if ((kDebugMode || _logDeviceToken) && authToken.isEmpty) {
      print('[SaveDeviceTokenState] ⚠️ No auth token available; backend may reject save.');
    }

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
    };

    _pkgInfo ??= await PackageInfo.fromPlatform();
    final platform = GetPlatform.isAndroid
        ? 'android'
        : GetPlatform.isIOS
            ? 'ios'
            : GetPlatform.isWeb
                ? 'web'
                : 'flutter';
    final payload = <String, dynamic>{
      'device_token': token,
      'platform': platform,
      'app_version': _pkgInfo?.version,
      'build_number': _pkgInfo?.buildNumber,
    };

    final userId = _tryParseUserId(authToken.isNotEmpty ? authToken : null);
    if (userId != null) {
      payload['user_id'] = userId;
    }

    if (kDebugMode || _logDeviceToken) {
      final maskedAuth = authToken.isNotEmpty
          ? '${authToken.substring(0, authToken.length > 8 ? 8 : authToken.length)}...'
          : '(none)';
      print('[SaveDeviceTokenState] POST $uri');
      print('[SaveDeviceTokenState] headers Authorization: $maskedAuth');
      print('[SaveDeviceTokenState] body: ${jsonEncode(payload)}');
    }

    try {
      final res = await http.post(uri, headers: headers, body: jsonEncode(payload));
      print('111111111111111gdevkkkkkk');
 print(res.body);
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] status: ${res.statusCode} body: ${res.body}');
      }
      if (res.statusCode == 200) {
        _tokenSaved = true;
        _lastSavedToken = token;
        if (kDebugMode || _logDeviceToken) {
          print('[SaveDeviceTokenState] ✅ device token saved.');
        }
      } else {
        if (kDebugMode || _logDeviceToken) {
          print('[SaveDeviceTokenState] ⚠️ failed to save token. Check auth/token/permissions.');
        }
      }
    } catch (e) {
      if (kDebugMode || _logDeviceToken) {
        print('[SaveDeviceTokenState] error in _saveToken: $e');
      }
    }
  }

  int? _tryParseUserId(String? jwt) {
    if (jwt == null || jwt.isEmpty) return null;
    try {
      final parts = jwt.split('.');
      if (parts.length < 2) return null;
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded);
      final val = map['id'];
      if (val == null) return null;
      return int.tryParse(val.toString());
    } catch (_) {
      return null;
    }
  }
}
