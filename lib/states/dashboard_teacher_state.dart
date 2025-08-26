import 'package:pathana_school_app/models/dashboard_teacher_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardTeacherState extends GetxController {
  Repository repository = Repository();
  DashboardTeacherModels? data;
  bool check = false;
  var age = '0'; // Plain string for simplicity

  getAll() async {
    getDashboardTeacher();
    update();
  }

  getDashboardTeacher() async {
    try {
      var response = await repository.get(
          url: repository.urlApi + repository.dashboardTeacherRecorde,
          auth: true);

      if (response.statusCode == 200) {
        data =
            DashboardTeacherModels.fromJson(jsonDecode(response.body)['data']);
        check = true;
        if (data != null) {
          updateAge();
        }
      } else {
        throw response;
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues, parsing errors, etc.)
      print('Exception: $e');
    }
    update();
  }

  void updateAge() {
    if (data != null && data!.birtdayDate != null) {
      final parsedDate =
          DateFormat('dd/MM/yyyy').parse(data!.birtdayDate.toString());
      final year = int.parse(DateFormat('yyyy').format(parsedDate));
      final yearNow = int.parse(DateFormat('yyyy').format(DateTime.now()));
      age = (yearNow - year).toString();
      update(); // Notify listeners using GetBuilder
    }
  }
}
