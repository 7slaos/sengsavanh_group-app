import 'package:get/get.dart';
import 'package:pathana_school_app/models/follow_student_detail_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';

class ParentFollowStudentState extends GetxController {
  Repository rep = Repository();
  List<FollowStudentDetailModels> data = [];
  bool check = false;
  getData(String month, String year) async {
    data = [];
    check = false;
    String formattedMonth = month != '' && month != 'ເລືອກ-ເດືອນ'
        ? month.replaceAll('ເດືອນ-', '')
        : '';
    var res = await rep.post(
        url: rep.urlApi + rep.parentFollowStudent,
        auth: true,
        body: {'month': formattedMonth, 'year': year});
    // print('1111111111111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        data.add(FollowStudentDetailModels.fromJson(item));
      }
    }
    check = true;
    update();
  }
}
