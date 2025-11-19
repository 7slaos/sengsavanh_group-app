import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/call_student_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;

class CallStudentState extends GetxController {
  List<dynamic> callstudentList = [];
  List<bool> isChecked = [];
  bool checkID = false;
  AppVerification appVerification = Get.put(AppVerification());
  Repository rep = Repository();
  List<CallStudentModel> data = [];
  int page = 1;
  int limit = 50;
  bool isLoading = true;
  bool check = false;
  cleargetData() {
    page = 1;
    limit = 50;
    isLoading = true;
    data = [];
    update();
  }

  getData(String status, String type) async {
    try {
      check = false;
      if (type == 'noti') {
        cleargetData();
      }
      final res = await rep.post(
          url: '${rep.nuXtJsUrlApi}api/Application/PaymentApiController/all_call_students',
          auth: true,
          body: {
            'limit': limit.toString(),
            'page': page.toString(),
            'status': status
          });
      if (res.statusCode == 200) {
        if (status == '3') {
          final List<dynamic> responseData =
              jsonDecode(utf8.decode(res.bodyBytes))['data'];
          final List<CallStudentModel> newData =
              responseData.map<CallStudentModel>((item) {
            return CallStudentModel.fromJson(item);
          }).toList();
          if (newData.length < limit) {
            isLoading = false;
          }
          data.addAll(newData);
        } else {
          data = [];
          update();
          for (var item
              in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
            data.add(CallStudentModel.fromJson(item));
          }
        }
        check = true;
        update();
      }
    } catch (e) {
      //ignore: avoid_print
      // print(stactTrack);
      // print('Error fetching data: 111111111111111111111111 = $e');
    }
  }

  updatePage() {
    ++page;
    update();
  }

  addcallStudent({required int id}) async {
    checkID = false;
    for (int i = 0; i < callstudentList.length; i++) {
      if (callstudentList[i]['id'].toString() == id.toString()) {
        checkID = true;
      }
    }
    if (checkID == true) {
      return;
    } else {
      Map<String, dynamic> map = {
        'id': id,
      };
      callstudentList.add(map);
    }
    update();
  }

  removeIndex(int i, int id, bool v) {
    isChecked[i] = v;
    int index = callstudentList
        .indexWhere((element) => element['id'].toString() == id.toString());
    if (isChecked[i] == false && index != -1) {
      callstudentList.removeAt(index);
    } else {
      addcallStudent(id: id);
    }
    update();
    // print('5555555555555555555555555555555555');
    // print(callstudentList);
  }

  clearcallStudent() {
    callstudentList = [];
    update();
  }

  confirmcallStudent(
      {required BuildContext context, required String note}) async {
    CustomDialogs().dialogLoading();
    try {
      final url = rep.nuXtJsUrlApi + rep.callStudents;
      final payload = {
        'note': note,
        'students': jsonEncode(callstudentList),
      };

      if (kDebugMode) {
        print('[CallStudentState] POST $url');
        print('[CallStudentState] body: ${jsonEncode(payload)}');
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' +
              ((appVerification.nUxtToken.isNotEmpty)
                  ? appVerification.nUxtToken
                  : appVerification.token),
        },
        body: jsonEncode(payload),
      );
      Get.back();

      if (kDebugMode) {
        final text = (() {
          try {
            return utf8.decode(response.bodyBytes);
          } catch (_) {
            return response.body;
          }
        })();
        print('[CallStudentState] status: ${response.statusCode}');
        print('[CallStudentState] response: $text');
      }

      // print(jsonDecode(response.body));
      // print(
      //     "11111111111111111111111000000000000000000000000000000000000000000000000000");
      if (response.statusCode == 200) {
        clearcallStudent();
        getData('1', 'all');
        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'take_children'.tr,
          desc: 'success'.tr,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          btnOkText: 'ok'.tr,
          dismissOnBackKeyPress: false,

          btnOkOnPress: () {
            Get.back(result: true);
          },
        ).show();
      } else if (response.statusCode == 402) {
        String message;
        try {
          final err = jsonDecode(utf8.decode(response.bodyBytes));
          message = (err['message'] ?? err['statusMessage'] ?? 'something_went_wrong').toString();
        } catch (_) {
          message = 'something_went_wrong'.tr;
        }

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'sorry'.tr,
          desc: message,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          btnCancelText: 'cancel'.tr,
          dismissOnBackKeyPress: false,
          btnCancelOnPress: () {},
        ).show();
      } else {
        throw Exception('Failed to confirm sale: ${response.body}');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[CallStudentState] confirmcallStudent error: $e');
        print(stackTrace);
      }
      await CustomDialogs().showToast(
          text: 'something_went_wrong', backgroundColor: AppColor().red);
    }
  }

  tearchconfirmcallStudent(
      {required BuildContext context,
      required String id,
      required String status}) async {
    CustomDialogs().dialogLoading();
    try {
      var res = await rep.post(
          url: rep.nuXtJsUrlApi + rep.tearchconfirmcallStudent,
          body: {'id': id, 'status': status},
          auth: true);
      Get.back();
      // print('666666666666666666666666');
      // print(status);
      // print(res.body);
      if (res.statusCode == 200) {
        getData((int.parse(status) - 1).toString(), 'all');
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green,
          text: 'success', // Message for "Entered amount is too large"
        );
      } else {
        throw Exception('Failed to confirm sale: ${res.body}');
      }
    } catch (e) {
      // print(stackTrace);
      await CustomDialogs().showToast(
          text: 'something_went_wrong', backgroundColor: AppColor().red);
    }
  }
}
