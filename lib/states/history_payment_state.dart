import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/history_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:get/get.dart';

class HistoryPaymentState extends GetxController {
  Repository repository = Repository();
  bool check = false;
  List<HistoryModel> data = [];
  String selectedYear1 = ''; // For first dropdown
  String selectedMonth2 = ''; // For second dropdown
  List<String> yearList = List.generate(100, (index) {
    return (DateTime.now().year - index).toString();
  });
  updateYear(String y) {
    selectedYear1 = y;
    update();
  }

  updateMonth(String m) {
    selectedMonth2 = m;
    update();
  }

  setCurrentMonth() {
    DateTime now = DateTime.now();
    selectedMonth2 = now.month.toString().padLeft(2, '0');
    selectedYear1 = '${now.year}';
    update();
  }

  List<String> monthList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  clearData() {
    selectedYear1 = '';
    selectedMonth2 = '';
    update();
  }

  getListStudents(
      {String? year, String? month, String? id, required String type}) async {
    try {
      check = false;
      data.clear();
      update();
      String formattedMonth = month != null && month != 'month'
          ? month.replaceAll('month-', '')
          : '';
      // print('555555555555555555555');
      // print(type);
      var res = await repository.post(
        url: repository.urlApi + repository.getDataListStudent,
        body: {
          'year': year ?? '',
          'month': formattedMonth, // Use the formatted month
          'id': id ?? '',
          'type': type
        },
        auth: true,
      );
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body)['data'];
        for (var item in jsonData) {
          data.add(HistoryModel.fromJson(item));
        }
      }
      check = true;
      update();
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: "something_went_wrong".tr,
      );
    }
  }
}
