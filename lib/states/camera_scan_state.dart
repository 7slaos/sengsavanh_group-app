import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/check_student_model.dart';
import 'package:pathana_school_app/pages/check_student_success.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:pathana_school_app/states/checkin-out-student/check_in_out_student_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';

// ignore: library_prefixes
class CameraScanPageState extends GetxController {
  AppColor appColors = AppColor();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Repository rep = Repository();
  CheckInOutStudentState checkInOutStudentState =  Get.put(CheckInOutStudentState());
  TextEditingController searchT = TextEditingController();
  CheckStudentModel? checkStudentModel;
  Barcode? barcode;
  String? lat;
  String? lng;
  QRViewController? controller;
  updateLatLng(String la, String lg){
    lat = la;
    lng= lg;
    update();
  }
  final player = AudioPlayer();
  void playSound() async {
    await player.play(AssetSource('sounds/error.mp3'));
  }
  void playSuccessSound() async {
    await player.play(AssetSource('sounds/success.mp3'));
  }

  Future<http.Response> scanOut({required BuildContext context, String ? code}) async {
    if (barcode == null && code == null) {
      return Future.error("empty_barcode");
    }
    try {
      var res = await rep.postNUxt(
          url: '${rep.nuXtJsUrlApi}api/Application/checkin-out-student/check_student',
          auth: true,
          body: {
            "admission_number":  code ?? barcode!.code.toString(),
            "lat": lat,
            "lng": lng
          });
      if (res.statusCode == 200) {
        final response = jsonDecode(utf8.decode(res.bodyBytes));
        postCheckStudent(context, response['data']['id'].toString());
        return res;
      } else {
        return res;
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  postCheckStudent(BuildContext context, String studentRecordsId) async {
    try{
      var res = await rep.postNUxt(
          url: '${rep.nuXtJsUrlApi}api/Application/checkin-out-student/create_update',
          auth: true,
          body: {
            "student_records_id": studentRecordsId,
          });
      final response = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode == 200 && response['success'] == true) {
        final id = response['data']['id'].toString();
        final type = response['data']['type'].toString();
        playSuccessSound();
        CustomDialogs().showToastWithIcon(context: context, message: type=='check_in' ? 'Check In ສໍາເລັດແລ້ວ' : 'Check Out ສໍາເລັດແລ້ວ', backgroundColor: appColors.green);
        await sendNotificationToParent(id: id, type: type);
        checkInOutStudentState.clearFilters();
        Get.back(result: true);
      }else if(res.statusCode == 422){
        playSound();
        CustomDialogs().showToastWithIcon(context: context, message: 'Already Check In/Out',icon: Icons.close, backgroundColor: appColors.red);
        Get.back(result: true);
      }
    }catch(e){
      playSound();
      CustomDialogs().showToastWithIcon(context: context, message: 'something_went_wrong', icon: Icons.close, backgroundColor: appColors.red);
      Get.back(result: true);
    }
  }
  sendNotificationToParent({required String id, required type}) async{
     await rep.post(url: '${rep.urlApi}api/check_in_check_out_push_notification_to_users', body: {
       'id': id,
       'type': type
     }, auth: true);
  }

  checkStudent(Map<String, dynamic> json) {
    checkStudentModel = CheckStudentModel.fromJson(json);
    update();
    if (checkStudentModel != null) {
      Get.to(() => CheckStudentSuccess(data: checkStudentModel!),
          transition: Transition.zoom);
    }
  }

  Future<void> updateBarCode(Barcode newBarCode) async {
    barcode = newBarCode;
    return;
  }

  clearsearcT() {
    searchT.text = '';
    update();
  }

  @override
  void onClose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.onClose();
  }
}
