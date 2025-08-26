import 'package:get/get.dart';
import 'package:pathana_school_app/models/check_role_permission_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';

class CheckRolePermissionState extends GetxController {
  Repository rep = Repository();
  List<CheckRolePermissionModel> data = [];
  bool check = false;
  checkRolePermission() async {
    check = false;
    data = [];
    var res = await rep.get(
        url: "${rep.urlApi}api/check_role_permission", auth: true);
    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
        data.add(CheckRolePermissionModel.fromJson(item));
      }
    }
    check = true;
    update();
  }

  bool checkRole(String name) {
    for (var item in data) {
      if (name.toString() == item.name.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  void onInit() {
    checkRolePermission();
    super.onInit();
  }
}
