import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/admin_expense_mode.dart';
import 'package:pathana_school_app/models/expense_category_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;

class AdminExpenseState extends GetxController {
  AppVerification appVerification = Get.put(AppVerification());
  List<ExpenseCategoryModel> expenseCategoryList = [];
  ExpenseCategoryModel? selectexpenseCategory;
  Repository rep = Repository();
  AdminExpenseModel? data;
  bool loading = true;
  String payType = '2';
  String type = '1';
  bool checkSave = true;
  updatepayType(String v) {
    payType = v;
    update();
  }

  updateType(String v) {
    type = v;
    update();
  }

  getData(String? startDate, String? endDate,
      {required String branchId}) async {
    data = null;
    loading = true;
    var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/admin_expenses',
        body: {
          'start_date': startDate ?? '',
          'end_date': endDate ?? '',
          'branch_id': branchId
        },
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
      if (decodedBody['data'] != null &&
          decodedBody['data']['items'] is List &&
          decodedBody['data']['items'].isNotEmpty) {
        data = AdminExpenseModel.fromJson(decodedBody['data']);
      }
    }
    loading = false;
    update();
  }

  getexpeseCategory() async {
    expenseCategoryList = [];
    var res = await rep.get(
        url:
            '${rep.nuXtJsUrlApi}api/Application/ExpenseApiController/epxense_category',
        auth: true);
    // print('11111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        expenseCategoryList.add(ExpenseCategoryModel.fromMap(item));
      }
      update();
    }
  }

  updateexpeseCategory(ExpenseCategoryModel v) {
    selectexpenseCategory = v;
    update();
  }

  postExpense(
      {required String id,
      required String name,
      required String dated,
      required String subtotal,
      required String type,
      required String payType,
      required String incomeexpendcategoryId,
      XFile? image,
      required String branchId,
      String? startDate,
      String? endDate}) async {
    checkSave = false;
    update();
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse('${rep.nuXtJsUrlApi}api/Application/ExpenseApiController/store_expense');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        "id": id,
        "name": name,
        "pay_date": dated,
        'subtotal': subtotal,
        'type': type,
        'pay_type': payType,
        'income_expend_category_id': incomeexpendcategoryId
      });
      if (image != null) {
        var picture = await http.MultipartFile.fromPath('image', image.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      // var responseBody = await response.stream.bytesToString();
      // print(responseBody);
      // print(payType);
      // print('00022222222222222222222222222222');
      if (response.statusCode == 200) {
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        getData(startDate, endDate, branchId: branchId);
      }
      checkSave = true;
      update();
    } catch (e) {
      // print(e);
      return CustomDialogs().showToast(
          text: 'something_went_wrong',
          backgroundColor: AppColor().black.withOpacity(0.8));
    }
  }
}
