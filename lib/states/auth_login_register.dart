import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/home_model.dart';
import 'package:pathana_school_app/pages/adminschool/admin_school_dashboard.dart';
import 'package:pathana_school_app/pages/parent_recordes/home_page.dart';
import 'package:pathana_school_app/pages/student_records/dashboard_page.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/pages/superadmin/super_admin_dashboard.dart';
import 'package:pathana_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/save_device_token.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthLoginRegister extends GetxController {
  Repository repository = Repository();
  SaveDeviceTokenState saveDeviceTokenState = Get.put(SaveDeviceTokenState());
  AppVerification appVerification = Get.put(AppVerification());
  bool checkLogin = false;
  HomeModel? data;
  String index = 'p';

// Start login user
  login({
    required BuildContext context,
    required String phone,
    required String password,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var res = await repository.post(
        url: repository.urlApi + repository.loginUser,
        body: {
          'phone': phone,
          'password': password,
        },
      );

      if (res.statusCode == 200) {
        update();
        Get.back();
        String roleId = jsonDecode(res.body)['role_id'].toString();
        await appVerification.setNewToken(
          text: jsonDecode(res.body)['token'],
          role: roleId,
        );
        var resNUxt = await repository.postNUxt(
          url: '${repository.nuXtJsUrlApi}api/login',
          body: {
            'phone': phone,
            'password': password,
          },
        );

        if(resNUxt.statusCode == 200){
          await appVerification.setNewNUxtToken(
            token: jsonDecode(resNUxt.body)['token'],
          );
        }
        saveDeviceTokenState.postSaveDeviceToken();
        // await profileState.getUserInformation(); // Fetch user information
        if (roleId == "p") {
          Get.off(
            const HomePage(),
            transition: Transition.rightToLeft,
          );
        } else if (roleId == 's') {
          // data = HomeModels.fromJson(jsonDecode(res.body)['data']);
          // Get.to(() => DashboardPage(data: data!));
          Get.off(() => const DashboardPage());
        } else if (roleId == 't') {
          Get.off(const TeacherDashboardPage(), transition: Transition.fadeIn);
        } else if (roleId == '1') {
          Get.off(const SuperAdminDashboard(), transition: Transition.fadeIn);
        } else if (roleId == '3' || roleId == '2') {
          Get.off(const AdminSchoolDashboard(), transition: Transition.fadeIn);
        }
      } else if (res.statusCode == 404 ||
          res.statusCode == 405 ||
          res.statusCode == 201) {
        Get.back();
        checkLogin = false;
        return CustomDialogs().showToast(
          text: jsonDecode(res.body)['message'].toString(),
        );
      } else {
        Get.back();
        checkLogin = false;
        return CustomDialogs().showToast(
          backgroundColor: AppColor().black,
          text: 'invalid_phone_number_or_password_please_try_again'.tr,
        );
      }

    } catch (e, StackTrace) {
      print('000000000000');
      print(e);
      print(StackTrace);
      Get.back();
      return CustomDialogs().showToast(
        backgroundColor: AppColor().black,
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }
  // End login user

  // Start logout user
  logouts() async {
    try {
      var reslogout = await repository.post(
          url: repository.urlApi + repository.logoutUser, auth: true);

      if (reslogout.statusCode == 200) {
        appVerification.removeToken();
        Get.off(
          const LoginPage(),
        );
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'logouts_successfully'.tr,
        );
      } else {
        reslogout.body;
      }
    } catch (e) {
      CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text: "something_went_wrong".tr);
    }
    update();
  }

  deleteAccount() async {
    try {
      var res = await repository.post(
          url: '${repository.urlApi}api/delete_account', auth: true);
      if (res.statusCode == 200) {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        logouts();
      }
    } catch (e) {
      CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text: "something_went_wrong".tr);
    }
    update();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  deleteTokenDevices() async {
    await _firebaseMessaging.getToken().then((token) async {
      try {
        CustomDialogs().dialogLoading();
        var res = await repository.post(
            url: '${repository.urlApi}api/deleteTokenDevices',
            auth: true,
            body: {'device_token': token ?? ''});
        Get.back();
        if (res.statusCode == 200) {
          CustomDialogs().showToast(
            // ignore: deprecated_member_use
            backgroundColor: AppColor().green.withOpacity(0.6),
            text: 'success'.tr,
          );
        } else {
          CustomDialogs().showToast(
              // ignore: deprecated_member_use
              backgroundColor: AppColor().red.withOpacity(0.8),
              text: jsonDecode(res.body)['message']);
        }
      } catch (e) {
        CustomDialogs().showToast(
            // ignore: deprecated_member_use
            backgroundColor: AppColor().red.withOpacity(0.8),
            text: "something_went_wrong".tr);
      }
    });
  }
}
