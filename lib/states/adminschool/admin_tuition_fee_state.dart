import 'package:get/get.dart';
import 'package:pathana_school_app/models/admin_tuition_fee_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';

class AdminTuitionFeeState extends GetxController {
  Repository rep = Repository();
  AdminTuitionFeeModel? data;
  bool loading = true;
  String paymentType = 'c';
  updatePaymentType(String t){
    paymentType = t;
    update();
  }
  getData(String? startDate, String? endDate,
      {required String type, required String branchId}) async {
    loading = true;
    data = null;
    update();
    var res = await rep.post(
        url: '${rep.nuXtJsUrlApi}api/Application/AdminSchoolController/admin_tuition_fee',
        body: {
          'start_date': startDate ?? '',
          'end_date': endDate ?? '',
          'type': type,
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
        data = AdminTuitionFeeModel.fromJson(decodedBody['data']);
      }
    }
    loading = false;
    update();
  }
}
