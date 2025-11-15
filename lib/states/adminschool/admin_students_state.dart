import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/admin_student_model.dart';
import 'package:pathana_school_app/models/confirm_register_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';

class AdminStudentsState extends GetxController {
  Repository rep = Repository();
  List<AdminStudentModel> data = [];
  List<ConfirmRegisterModel> registerList = [];
  bool loading = true;
  bool loadingRe = true;
  getData(String? startDate, String? endDate,
      {required String branchId}) async {
    if(startDate !=null && endDate !=null) {
      data = [];
    }
    loading = true;
    final existingIds = data.map((e) => e.id).toSet();
    var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/admin_students',
        body: {
          'start_date': startDate ?? '',
          'end_date': endDate ?? '',
          'branch_id': branchId
        },
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(res.bodyBytes))['data'] as List;

      for (var item in jsonData) {
        final model = AdminStudentModel.fromJson(item);

        // Only add if it's not already in the Set
        if (!existingIds.contains(model.id)) {
          data.add(model);
          existingIds.add(model.id); // keep the Set updated
        }
      }
    }
    loading = false;
    update();
  }

  getregisterData(
    String? startDate,
    String? endDate,
  ) async {
    registerList = [];
    loading = true;
    var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/LoginApiController/get_registers',
        body: {'start_date': startDate ?? '', 'end_date': endDate ?? ''},
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        registerList.add(ConfirmRegisterModel.fromJson(item));
      }
    }
    loadingRe = false;
    update();
  }

  confirmregisterStudent({required String id}) async {
    try {
      CustomDialogs().dialogLoading();
      var res = await rep.post(
          url: '${rep.nuXtJsUrlApi}api/Application/LoginApiController/confirm_register_student',
          body: {'id': id},
          auth: true);
      Get.back();
      if (res.statusCode == 200) {
        getregisterData('', '');
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.8),
          text: 'success',
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
  }
}
