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
import 'package:flutter/foundation.dart';
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
    bool rememberMe = false,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      // Use NuxtJS login endpoint only
      // Debug: show request payload (masked)
      if (kDebugMode) {
        String maskPhone(String v) => v.length <= 4
            ? '****'
            : ('*' * (v.length - 4)) + v.substring(v.length - 4);
        print('Login → URL: ' '${repository.nuXtJsUrlApi}${repository.loginUser}');
        print('Login → body: { phone: ' '${maskPhone(phone)}' ', remember: ' '$rememberMe' ' }');
        final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
        final last8 = digits.length >= 8 ? digits.substring(digits.length - 8) : digits;
        print('Login → normalizedPhone (server expects): 20$last8');
      }

      final res = await repository.postNUxt(
        url: '${repository.nuXtJsUrlApi}${repository.loginUser}',
        body: {
          'phone': phone,
          'password': password,
          'remember': rememberMe,
        },
      );

      // Decode response safely (handles UTF-8 bodyBytes)
      final bodyText = (() {
        try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
      })();

      if (kDebugMode) {
        print('Login ← status: ${res.statusCode}');
        print('Login ← body: ' + bodyText);
      }

      if (res.statusCode == 200) {
        update();
        Get.back();
        final decoded = jsonDecode(bodyText);
        final token = decoded['token'] ?? '';
        String roleId = (decoded['role_id'] ?? '').toString();

        await appVerification.setNewToken(
          text: token,
          role: roleId,
          phone: phone,
          password: password,
          rememberMe: rememberMe,
        );
        // Keep nUxtToken in sync for postNUxt/getNUxt headers
        await appVerification.setNewNUxtToken(token: token);
        if (kDebugMode) {
          print('Login ✓ token length: ${token.toString().length}, roleId: $roleId');
          print('Login ✓ calling saveDeviceToken…');
        }
        try {
          await saveDeviceTokenState.postSaveDeviceToken();
        } catch (e) {
          if (kDebugMode) print('saveDeviceToken error (ignored): $e');
        }

        // Fallback: if unknown role, query /api/me to infer role by name
        if (!(roleId == 'p' || roleId == 's' || roleId == 't' || roleId == '1' || roleId == '2' || roleId == '3')) {
          try {
            final meRes = await repository.getNUxt(
              url: '${repository.nuXtJsUrlApi}api/Application/LoginApiController/get_Profileds',
              auth: true,
            );
            if (meRes.statusCode == 200) {
              final me = jsonDecode(utf8.decode(meRes.bodyBytes));
              // The get_Profileds endpoint returns data; adapt keys as available
              final rn = (me['data']?['role_name'] ?? '').toString().toLowerCase();
              final rid = (me['data']?['role_id'] ?? me['data']?['roleId'] ?? '').toString();
              if (rn.contains('parent')) roleId = 'p';
              else if (rn.contains('teacher')) roleId = 't';
              else if (rn.contains('student') || rn.contains('pupil')) roleId = 's';
              else if (rid == '1' || rid == '2' || rid == '3') roleId = rid; // admins
            }
          } catch (_) {}
        }

        // Navigate by resolved roleId (with default fallback to parent home)
        if (roleId == "p") {
          Get.off(() => const HomePage(),
            transition: Transition.rightToLeft,
          );
        } else if (roleId == 's') {
          Get.off(() => const DashboardPage());
        } else if (roleId == 't') {
          Get.off(() => const TeacherDashboardPage(), transition: Transition.fadeIn);
        } else if (roleId == '1') {
          Get.off(() => const SuperAdminDashboard(), transition: Transition.fadeIn);
        } else if (roleId == '3' || roleId == '2') {
          Get.off(() => const AdminSchoolDashboard(), transition: Transition.fadeIn);
        } else {
          // default route to parent home when role cannot be determined
          Get.off(() => const HomePage(),
            transition: Transition.rightToLeft,
          );
        }
      } else if (res.statusCode == 404 || res.statusCode == 405 || res.statusCode == 201 || res.statusCode == 400 || res.statusCode == 500) {
        Get.back();
        checkLogin = false;
        // Try to show server error message when available
        try {
          final err = jsonDecode(bodyText);
          final msg = (err['message'] ?? err['statusMessage'] ?? 'something_went_wrong').toString();
          if (kDebugMode) print('Login error message: ' + msg);
          return CustomDialogs().showToast(text: msg);
        } catch (_) {
          if (kDebugMode) print('Login error raw: ' + bodyText);
          return CustomDialogs().showToast(text: 'something_went_wrong'.tr);
        }
      } else {
        Get.back();
        checkLogin = false;
        if (kDebugMode) print('Login unexpected status ${res.statusCode}: ' + bodyText);
        // Show raw server message if present; otherwise generic
        try {
          final err = jsonDecode(bodyText);
          final msg = (err['message'] ?? err['statusMessage'] ?? 'something_went_wrong').toString();
          return CustomDialogs().showToast(text: msg);
        } catch (_) {
          return CustomDialogs().showToast(
            backgroundColor: AppColor().black,
            text: 'invalid_phone_number_or_password_please_try_again'.tr,
          );
        }
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
          url: repository.nuXtJsUrlApi + repository.logoutUser, auth: true);

      if (reslogout.statusCode == 200) {
        appVerification.removeToken();
        Get.off(() => const LoginPage());
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
          url: '${repository.nuXtJsUrlApi}api/Application/LoginApiController/delete_account', auth: true);
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
            url: '${repository.nuXtJsUrlApi}api/Application/LoginApiController/deleteTokenDevices',
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
              text: jsonDecode(utf8.decode(res.bodyBytes))['message']);
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
