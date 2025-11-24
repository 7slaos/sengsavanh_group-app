import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class SaveDeviceTokenState extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Repository rep = Repository();
  AppVerification appVerification = Get.put(AppVerification());

  postSaveDeviceToken() async {
    await _firebaseMessaging.getToken().then((token) async {
      try {
        if (kDebugMode) {
          print('[SaveDeviceTokenState] got FCM token: ${token ?? 'null'}');
        }
        final uri = Uri.parse(rep.nuXtJsUrlApi + rep.saveDeviceToken);
        final headers = <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if ((appVerification.nUxtToken).isNotEmpty)
            'Authorization': 'Bearer ${appVerification.nUxtToken}',
        };
        final body = jsonEncode({
          'device_token': token ?? '',
          'platform': GetPlatform.isAndroid
              ? 'android'
              : GetPlatform.isIOS
                  ? 'ios'
                  : 'flutter'
        });

        final res = await http.post(uri, headers: headers, body: body);

        if (kDebugMode) {
          print('saveDeviceToken status: ${res.statusCode} body: ${res.body}');
        }
        // Do not force logout on failures here; just log
      } catch (e) {
        if (kDebugMode) {
          print('saveDeviceToken error: $e');
        }
      }
    });
  }
}
