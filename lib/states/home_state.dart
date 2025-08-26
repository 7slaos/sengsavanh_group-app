import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/dashboard_parent_model.dart';
import 'package:pathana_school_app/models/home_model.dart';
import 'package:pathana_school_app/models/name_school_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeState extends GetxController {
  Repository rep = Repository();
  int currentpage = 0;
  int loanIndex = 0;
  bool check = false;
  List<HomeModel> data = [];
  int notificationCount = 0; // To store the count retrieved from the API
  AuthNameSchoolModel? nameSchoolModel;
  ParentRecordeModels? parentModels;
  String age = '0';

  clearNotificationCount() {
    notificationCount = 0;
    update(); // Notify the GetBuilder to rebuild widgets
  }

  allDataFiled() async {
    getCounts();
    getHomeParentAndStudentList();
    getNameSchool();
    clearNotificationCount();
    update();
  }

  getNameSchool() async {
    try {
      var response =
          await rep.get(url: rep.urlApi + rep.authNameSchool, auth: true);

      if (response.statusCode == 200) {
        nameSchoolModel =
            AuthNameSchoolModel.fromJson(jsonDecode(response.body)['data']);
        update(); // Update GetX listeners
      } else {
        // Handle errors (optional)
        throw Exception('Failed to load school name');
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  setCurrentPage(int index) {
    currentpage = index;
    update();
  }

  setCurrentPageLoan(int index) {
    loanIndex = index;
    update();
  }

  getHomeParentAndStudentList() async {
    check = false;
    data = [];
    var res = await rep.get(url: rep.urlApi + rep.parentHomeStudentList, auth: true);
    if (res.statusCode == 200) {
      for (var items in jsonDecode(res.body)['data']) {
        data.add(HomeModel.fromJson(items));
      }
    }
    check = true;
    update();
  }

  parentDashboard() async {
    try {
      var resdashboard = await rep.get(
        url: rep.urlApi + rep.parentDashboard,
        auth: true,
      );

      if (resdashboard.statusCode == 200) {
        parentModels =
            ParentRecordeModels.fromJson(jsonDecode(resdashboard.body)['data']);
        if (parentModels != null) {
          calAge();
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  calAge() {
    final parsedDate =
        DateFormat('dd/MM/yyyy').parse(parentModels!.birthdayDate.toString());
    final year = int.parse(DateFormat('yyyy').format(parsedDate));
    final yearnow = int.parse(DateFormat('yyyy').format(DateTime.now()));
    // setState(() {
    age = (yearnow - year).toString();
    // });
    update();
  }

  getCounts() async {
    var res = await rep.get(url: rep.urlApi + rep.countId, auth: true);

    if (res.statusCode == 200) {
      var responseBody = json.decode(res.body);

      notificationCount =
          responseBody['data']; // Update the count from API response
    } else {
      throw res;
    }
    update();
  }

  void setState(Null Function() param0) {}
}
