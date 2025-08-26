import 'dart:io';

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/profiled_model.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSchoolProfileState extends GetxController {
  AppVerification appVerification = Get.put(AppVerification());
  Repository repository = Repository();
  ProfiledModels? profiledModels;
  bool check = false;

  checkToken() {
    if (appVerification.token == '') {
    } else {
      getProfile();
    }
  }

// get data profile parent
  getProfile() async {
    try {
      // Send the GET request
      var res = await repository.get(
          url: repository.urlApi + repository.getProfiled, auth: true);
      // print(res.body);
      // print('1111111111111111111111111111111111111111111');
      if (res.statusCode == 200) {
        // Parse JSON response and assign it to the model
        check = true;
        profiledModels = ProfiledModels.fromJson(jsonDecode(res.body)['data']);
      } else {
        appVerification.removeToken();
        Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
        throw res;
      }
    } catch (e) {
      // Handle any unexpected errors
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  // update profile
  updateProfiled({
    required BuildContext context,
    required String fullname,
    required String lastname,
    required String email,
    required String phone,
    File? imageFile,
    String? password,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var res = await repository.post(
        url: repository.urlApi + repository.updateProfiled,
        body: {
          'fullname': fullname.toString(),
          'lastname': lastname.toString(),
          'email': email.toString(),
          'phone': phone.toString(),
          'password': password ?? '',
        },
        auth: true,
      );
      // print(res.body);
      // print('00022222222222222222222222222222');
      if (res.statusCode == 200) {
        Get.back();
        Get.back(result: true);
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'corrected_successfully'.tr,
        );
      } else {
        // Print the response to diagnose the issue
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().red.withOpacity(0.8),
          text: res.body, // Show error message from API if available
        );
      }
    } catch (e) {
      Get.back();
      return CustomDialogs().showToast(
          text: 'something_went_wrong',
          // ignore: deprecated_member_use
          backgroundColor: AppColor().black.withOpacity(0.8));
    }
    update();
  }
}
