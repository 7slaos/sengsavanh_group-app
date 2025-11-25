// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:multiple_school_app/models/check_role_permission_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';

class CheckRolePermissionState extends GetxController {
  final Repository rep = Repository();

  /// Raw list from API (if you need full objects)
  List<CheckRolePermissionModel> data = [];

  /// Ready flag so UI knows when to render
  bool check = false;

  /// Fetch permissions
  Future<void> checkRolePermission() async {
    check = false;
    update();

    try {
      final res = await rep.get(
        url: "${rep.nuXtJsUrlApi}api/Application/PaymentApiController/check_role_permission",
        auth: true,
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(res.bodyBytes));
        final list = (decoded['data'] ?? []) as List;

        data = list
            .map((e) => CheckRolePermissionModel.fromJson(e))
            .toList(growable: false);

        // print(
        //     "Permissions loaded: ${data.map((e) => (e.name ?? '').trim()).toList()}");
      } else {
        print("check_role_permission HTTP ${res.statusCode}");
        data = [];
      }
    } catch (e) {
      print("check_role_permission error: $e");
      data = [];
    } finally {
      check = true;
      update();
    }
  }

  /// Case/space-insensitive permission check
  bool checkRole(String name) {
    final needle = name.trim().toLowerCase();
    for (final item in data) {
      final n = (item.name ?? '').trim().toLowerCase();
      //print(n);
      if (n.toString() == needle.toString()) {
        // print('$name = true');
        return true;
      }
    }
    // print('$name = false');
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    checkRolePermission();
  }
}
