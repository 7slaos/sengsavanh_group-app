import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/models/profile_student_record_model.dart';
import 'package:multiple_school_app/pages/login_page.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/appverification.dart';
import 'package:multiple_school_app/states/update_images_profile_state.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileStudentState extends GetxController {
  AppVerification appVerification = Get.put(AppVerification());
  PickImageState pickImageState = Get.put(PickImageState());
  Repository repository = Repository();
  ProfileStudentRecordModel? dataModels;
  AppColor appColor = AppColor();

  bool check = false;

  Future<void> checkToken() async {
    if (appVerification.token.isEmpty && appVerification.nUxtToken.isEmpty) {
      await appVerification.removeToken();
      Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
      return;
    }
    await getProfileStudent();
  }

  getProfileStudent() async {
    try {
      var res = await repository.get(
          url: repository.nuXtJsUrlApi + repository.getProfileStudentRecord,
          auth: true);
      if (res.statusCode == 200) {
        dataModels = ProfileStudentRecordModel.fromJson(
            jsonDecode(utf8.decode(res.bodyBytes))['data']);
        check = true;
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        // Unauthorized / token invalid → force logout
        await appVerification.removeToken();
        Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
      } else {
        // Other errors (e.g. 404 Student record not found) → keep session, just show message
        try {
          final text = utf8.decode(res.bodyBytes);
          final lower = text.toLowerCase();
          final looksLikeAuthError = lower.contains('unauthenticated') ||
              lower.contains('invalid token') ||
              lower.contains('jwt') ||
              lower.contains('token expired');
          if (looksLikeAuthError) {
            await appVerification.removeToken();
            Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
            return;
          }
          final err = jsonDecode(text);
          final msg = (err['statusMessage'] ?? err['message'] ?? 'something_went_wrong').toString();
          CustomDialogs().showToast(
            backgroundColor: AppColor().black.withOpacity(0.8),
            text: msg,
          );
        } catch (_) {
          CustomDialogs().showToast(
            backgroundColor: AppColor().black.withOpacity(0.8),
            text: 'something_went_wrong'.tr,
          );
        }
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  updateProfiledSR({
    required BuildContext context,
    required String firstname,
    required String lastname,
    required String telephone,
    required String? password,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      // Update profile data
      var res = await repository.post(
        url: repository.nuXtJsUrlApi + repository.updateProfileStudentRecord,
        auth: true,
        body: {
          'firstname': firstname,
          'lastname': lastname,
          'phone': telephone,
          'password': password ?? '',
        },
      );

      if (res.statusCode == 200) {
        Get.back(); // Close loading dialog
        Get.back(result: true); // Go back with success result
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: appColor.black.withOpacity(0.8),
          text: 'corrected_successfully'.tr,
        );
      } else {
        // Profile data update failed, show error message
        Get.back(); // Close loading dialog
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: appColor.red.withOpacity(0.8),
          text: res.body,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: appColor.black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }
}
