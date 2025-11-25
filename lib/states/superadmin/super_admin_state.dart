import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/models/branch_model.dart';
import 'package:multiple_school_app/models/payment_package_log_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';

class SuperAdminState extends GetxController {
  Repository rep = Repository();
  List<BranchModel> branchList = [];
  List<PaymentPackageLogModel> paymentPackageList = [];
  bool checkDashboard = false;
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final payDate = TextEditingController();
  String id = '';
  Future<void> selectDate(BuildContext context, String type) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set your desired range
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      if (type == 'start') {
        startDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      } else if (type == 'pay') {
        payDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      } else {
        endDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      }
      update();
    }
  }

  setCurrentDate() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    startDate.text =
        '${firstDayOfMonth.day.toString().padLeft(2, '0')}/${firstDayOfMonth.month.toString().padLeft(2, '0')}/${firstDayOfMonth.year}';
    endDate.text =
        '${lastDayOfMonth.day.toString().padLeft(2, '0')}/${lastDayOfMonth.month.toString().padLeft(2, '0')}/${lastDayOfMonth.year}';
    payDate.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    update();
  }

  clearData() {
    startDate.text = '';
    endDate.text = '';
    payDate.text = '';
    update();
  }

  List<Map<String, String>> statusList = [
    {'id': '0', 'name': 'select'},
    {'id': '1', 'name': 'opened'},
    {'id': '2', 'name': 'closed'},
  ];
  String status = '0';
  selectStatus(String v) {
    status = v;
    update();
  }

  getDashboard() async {
    checkDashboard = false;
    branchList = [];
    var res = await rep.get(
        url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/get_all_schools',
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        branchList.add(BranchModel.fromJson(item));
      }
    }
    checkDashboard = true;
    update();
  }

  getPaymentPackage({required String id}) async {
    paymentPackageList = [];
    var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/SuperAdminApiController/get_school_pay_packages',
        auth: true,
        body: {'id': id});
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        paymentPackageList.add(PaymentPackageLogModel.fromJson(item));
      }
    }
    update();
  }

  updateData(BranchModel data) {
    id = data.id.toString();
    selectStatus(data.status.toString());
    startDate.text = data.packageStartDate.toString();
    endDate.text = data.packageEndDate.toString();
    update();
  }

  // update profile
  updateBranch({
    required BuildContext context,
    required String id,
    required String status,
    required String start,
    required String end,
    String? password,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/update_branch_by_admin',
        body: {
          'id': id,
          'status': status,
          'start_date': start,
          'end_date': end
        },
        auth: true,
      );
      Get.back();
      // print(res.body);
      // print('00022222222222222222222222222222');
      if (res.statusCode == 200) {
        Get.back();
        getDashboard();
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
      }
    } catch (e) {
      return CustomDialogs().showToast(
          text: 'something_went_wrong',
          // ignore: deprecated_member_use
          backgroundColor: AppColor().black.withOpacity(0.8));
    }
  }
}
