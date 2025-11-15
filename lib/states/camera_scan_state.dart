import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/check_student_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/checkin-out-student/check_in_out_student_state.dart';

class CameraScanPageState extends GetxController {
  AppColor appColors = AppColor();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final Repository rep = Repository();
  final CheckInOutStudentState checkInOutStudentState = Get.put(CheckInOutStudentState());

  final TextEditingController searchT = TextEditingController();
  CheckStudentModel? checkStudentModel;

  QRViewController? controller;
  StreamSubscription<Barcode>? _scanSub; // 🔑 manage the stream
  Barcode? barcode;

  String? lat;
  String? lng;

  // audio
  final player = AudioPlayer();
  Future<void> playSound() async => player.play(AssetSource('sounds/error.mp3'));
  Future<void> playSuccessSound() async => player.play(AssetSource('sounds/success.mp3'));

  // ------- heartbeat HUD & page guard -------
  bool hasPermission = true;
  int previewTick = 0;   // increments while preview is active
  int decodeCount = 0;   // increments when a code is decoded
  Timer? _heartbeat;
  bool pageAlive = true; // set false onClose to guard async ops

  // ---------------- PUBLIC APIS (same as before) ----------------

  updateLatLng(String la, String lg) {
    lat = la;
    lng = lg;
    update();
  }

  Future<http.Response> scanOut({required BuildContext context, String? code, required String type, String ? student_records_id, String ? id}) async {
    if (barcode == null && code == null) {
      await playSound();
      _showErrorSnackbar('Qrcode student is empty'.tr);
      return Future.error("empty_barcode");
    }

    try {
      final res = await rep.postNUxt(
        url: '${rep.nuXtJsUrlApi}api/Application/checkin-out-student/check_student',
        auth: true,
        body: {
          'code': code ?? barcode!.code.toString(),
          'id': id ?? ''
        },
      );

      final response = jsonDecode(utf8.decode(res.bodyBytes));

      if (res.statusCode == 200 && response['success'] == true) {
        checkInOutStudentState.confirmCheckInOut(context: context, type: type, student_records_id: student_records_id, id: id ?? '');
        return res;
      } else {
        _showErrorSnackbar((response['message'] ?? 'something_went_wrong').toString());
        return res;
      }
    } catch (e) {
      _showErrorSnackbar('something_went_wrong'.tr);
      return Future.error(e);
    }
  }

  postCheckStudent(BuildContext context, String studentRecordsId) async {
    try {
      final res = await rep.postNUxt(
        url: '${rep.nuXtJsUrlApi}api/Application/checkin-out-student/create_update',
        auth: true,
        body: {'student_records_id': studentRecordsId},
      );

      final response = jsonDecode(utf8.decode(res.bodyBytes));

      if (res.statusCode == 200 && response['success'] == true) {
        final id = response['data']['id'].toString();
        final type = (response['data']['type'] ?? 'check_in').toString();

        await playSuccessSound();
        _showSuccessSnackbar(
          type == 'check_in'
              ? 'Check In ສໍາເລັດແລ້ວ'
              : 'Check Out ສໍາເລັດແລ້ວ',
        );

        await sendNotificationToParent(id: id, type: type);
        checkInOutStudentState.clearFilters();

        if (pageAlive) Get.back(result: true); // <- guard navigation
      } else if (res.statusCode == 422) {
        await playSound();
        _showErrorSnackbar('Already Check In/Out'.tr);
      } else {
        _showErrorSnackbar((response['message'] ?? 'something_went_wrong').toString());
      }
    } catch (e) {
      await playSound();
      _showErrorSnackbar('something_went_wrong'.tr);
    }
  }

  sendNotificationToParent({required String id, required type}) async {
    await rep.post(
      url: '${rep.nuXtJsUrlApi}api/Application/SuperAdminApiController/check_in_check_out_push_notification_to_users',
      body: {'id': id, 'type': type},
      auth: true,
    );
  }

  checkStudent(Map<String, dynamic> json) {
    checkStudentModel = CheckStudentModel.fromJson(json);
    update();
  }

  Future<void> updateBarCode(Barcode newBarCode) async {
    barcode = newBarCode;
  }

  clearsearcT() {
    searchT.text = '';
    update();
  }

  // ---------------- CONTROLLER ATTACH / PERMISSION / HEARTBEAT ----------------

  /// Attach a fresh controller every time the view creates one.
  /// Disposes any previous controller and cancels prior listeners.
  void attachController({QRViewController? ctrl, required BuildContext context, required String type, String ? student_records_id, String? id}) {
    // dispose old stuff if any
    _scanSub?.cancel();
    controller?.dispose();

    controller = ctrl;

    // start heartbeat (in case permission callback came earlier)
    _startHeartbeat();

    // single listener
    _scanSub = controller!.scannedDataStream.listen((scanData) async {
      if (!pageAlive) return;

      // heartbeat counter for visual debug (optional)
      decodeCount++;
      update(['hud']);

      // guard pause/resume with try/catch to avoid 404 if view is gone
      try { await controller?.pauseCamera(); } catch (_) {}

      await updateBarCode(scanData);

      try {
        await scanOut(context: context, type: type, student_records_id: student_records_id, id: id?? '');
      } catch (_) {}

      // a short delay before resuming helps avoid duplicate reads
      await Future.delayed(const Duration(milliseconds: 800));

      if (!pageAlive) return;
      try { await controller?.resumeCamera(); } catch (_) {}
    });
  }

  void handlePermission(bool granted) {
    hasPermission = granted;
    if (granted) {
      _startHeartbeat();
    } else {
      _stopHeartbeat();
      _showErrorSnackbar('Camera permission denied'.tr);
    }
    update(['hud']);
  }

  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(milliseconds: 500), (_) {
      previewTick++;
      update(['hud']);
    });
  }

  void _stopHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = null;
    update(['hud']);
  }

  // ---------------- SNACKBARS (private) ----------------

  void _showErrorSnackbar(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appColors.red,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        messageText: Row(
          children: [
            const Icon(Icons.close, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () => Get.closeAllSnackbars(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appColors.green,
        borderRadius: 12,
        margin: const Duration(microseconds: 0) is! Duration // no-op to avoid lint
            ? const EdgeInsets.all(16)
            : const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        messageText: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () => Get.closeAllSnackbars(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LIFECYCLE ----------------

  @override
  void onClose() {
    pageAlive = false;         // 🔑 stop using controller after page pop
    _stopHeartbeat();
    _scanSub?.cancel();
    controller?.dispose();
    controller = null;
    super.onClose();
  }
}
