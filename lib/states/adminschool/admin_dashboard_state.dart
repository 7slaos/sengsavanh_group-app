import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/models/admin_school_dashboard.dart';
import 'package:pathana_school_app/models/admin_schools_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';

class AdminDashboardState extends GetxController {
  Repository rep = Repository();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  List<AdminSchoolsModel> schoolList = [];
  AdminSchoolsModel? selectSchool;
  AdminDashboardModel? adminDashboardModel;
  bool checkDashboard = false;
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
      } else {
        endDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      }
      update();
    }
  }

  clearData() {
    startDate.text = '';
    endDate.text = '';
    selectSchool = null;
    update();
  }

  setcurrentDate() {
    DateTime now = DateTime.now();
    startDate.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    endDate.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    update();
  }

  selectSchoolDropdown(AdminSchoolsModel data) {
    selectSchool = data;
    update();
  }

  getSchools() async {
    schoolList = [];
    var res = await rep.get(
        url:
            '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/get_admin_schools',
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      schoolList.add(AdminSchoolsModel.fromMap({
        'id': 0,
        'name_la': 'select',
        'name_en': 'select',
        'name_cn': 'select',
      }));
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        schoolList.add(AdminSchoolsModel.fromMap(item));
      }
      update();
    }
  }

  getDashboard(String id, String stDate, String eDate) async {
    adminDashboardModel = null;
    checkDashboard = false;
    var res = await rep.post(
        url:
            '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/get_admin_schools_dashboard',
        body: {'id': id, 'start_date': stDate, 'end_date': eDate},
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      adminDashboardModel = AdminDashboardModel.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes))['data']);
    }
    checkDashboard = true;
    update();
  }
}
