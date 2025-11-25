import 'package:multiple_school_app/custom/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:multiple_school_app/models/dashboard_parent_model.dart';
import 'package:multiple_school_app/models/home_model.dart';
import 'package:multiple_school_app/models/name_school_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
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
      final url = rep.nuXtJsUrlApi + rep.authNameSchool;
      if (kDebugMode) print('AuthNameSchool → GET ' + url);
      var response = await rep.get(url: url, auth: true);

      if (kDebugMode) {
        final text = (() { try { return utf8.decode(response.bodyBytes); } catch (_) { return response.body; } })();
        print('AuthNameSchool ← ${response.statusCode}: ' + text);
      }

      if (response.statusCode == 200) {
        nameSchoolModel = AuthNameSchoolModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))['data']);
        update(); // Update GetX listeners
      } else {
        // Show server message if present
        try {
          final err = jsonDecode(utf8.decode(response.bodyBytes));
          final msg = (err['message'] ?? err['statusMessage'] ?? 'something_went_wrong').toString();
          throw Exception(msg);
        } catch (_) {
          throw Exception('Failed to load school name');
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: e.toString(),
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
    final url = rep.nuXtJsUrlApi + rep.parentHomeStudentList;
    if (kDebugMode) print('HomeParent_and_StudentList → GET ' + url);
    var res = await rep.get(url: url, auth: true);
    if (kDebugMode) {
      final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
      print('HomeParent_and_StudentList ← ${res.statusCode}: ' + text);
    }
    if (res.statusCode == 200) {
      for (var items
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        data.add(HomeModel.fromJson(items));
      }
    }
    check = true;
    update();
  }

  parentDashboard() async {
    try {
      var resdashboard = await rep.get(
        url: rep.nuXtJsUrlApi + rep.parentDashboard,
        auth: true,
      );

      if (resdashboard.statusCode == 200) {
        parentModels = ParentRecordeModels.fromJson(
            jsonDecode(utf8.decode(resdashboard.bodyBytes))['data']);
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
    final url = rep.nuXtJsUrlApi + rep.countId;
    if (kDebugMode) print('Counts → GET ' + url);
    var res = await rep.get(url: url, auth: true);
    if (kDebugMode) {
      final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
      print('Counts ← ${res.statusCode}: ' + text);
    }

    if (res.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(res.bodyBytes));

      notificationCount =
          responseBody['data']; // Update the count from API response
      } else {
      // ignore: only used for debug toasts
      try {
        final err = jsonDecode(utf8.decode(res.bodyBytes));
        final msg = (err['message'] ?? err['statusMessage'] ?? 'something_went_wrong').toString();
        throw Exception(msg);
      } catch (_) {
        throw res;
      }
    }
    update();
  }

  void setState(Null Function() param0) {}
}
