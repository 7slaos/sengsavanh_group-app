import 'package:get/get.dart';
import 'package:multiple_school_app/models/follow_student_detail_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';

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
        url: rep.nuXtJsUrlApi + rep.parentFollowStudent,
        auth: true,
        body: {'month': formattedMonth, 'year': year});
    // print('1111111111111111111111111111');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        data.add(FollowStudentDetailModels.fromJson(item));
      }
    }
    check = true;
    update();
  }
}
