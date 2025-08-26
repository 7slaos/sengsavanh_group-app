import 'package:image_picker/image_picker.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/profiled_model.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileState extends GetxController {
  RegisterState registerState = Get.put(RegisterState());
  AppVerification appVerification = Get.put(AppVerification());
  PickImageState pickImageState = Get.put(PickImageState());
  Repository repository = Repository();
  ProfiledModels? profiledModels;
  bool check = false;

  checkToken() {
    if (appVerification.token == '') {
    } else {
      getProfiled();
    }
  }

  getProfiled() async {
    try {
      var res = await repository.get(
          url: repository.urlApi + repository.getProfiled, auth: true);
      // print(res.body);
      // print('1111111111111111111111111111111111111111111');
      if (res.statusCode == 200) {
        check = true;   
        profiledModels = ProfiledModels.fromJson(jsonDecode(res.body)['data']);
        update();
      } else {
        appVerification.removeToken();
        Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
        throw res;
      }
    } catch (e, stackTrace) {
      // print(e);
      // print(stackTrace);
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
  }

  updateProfiled({
    required BuildContext context,
    required String firstname,
    required String lastname,
    String? email,
    String? religion,
    String? nickname,
    String? villId,
    String? disId,
    String? proId,
    String? job,
    String? gender,
    String? jobAddress,
    String? jobPosition,
    String? carNumber,
    XFile? imageFile,
    String? birthdayDate,
    String? password,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse('${repository.urlApi}api/update_Profiled_Parents');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        'firstname': firstname.toString(),
        'lastname': lastname.toString(),
        'email': email ?? '',
        'nickname': nickname ?? '',
        'religion_id': religion ?? '',
        'password': password ?? '',
        'vill_id': villId ?? '',
        'dis_id': disId ?? '',
        'pro_id': proId ?? '',
        'car_number': carNumber ?? '',
        'job_id': job ?? '',
        'job_address': jobAddress ?? '',
        'job_position': jobPosition ?? '',
        'birtday_date': birthdayDate ?? '',
        'gender': gender ?? ''
      });
      if (imageFile != null) {
        var picture =
            await http.MultipartFile.fromPath('profile_image', imageFile.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      // var responseBody = await response.stream.bytesToString();
      // print('00022222222222222222222222222222');
      if (response.statusCode == 200) {
        registerState.clearData();
        pickImageState.deleteFileImage();
        getProfiled();
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        Get.back(result: true);
      }
    } catch (e) {
      return CustomDialogs().showToast(
          text: 'something_went_wrong',
          backgroundColor: AppColor().black.withOpacity(0.8));
    }
  }

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

  updateadminProfile(
      {required BuildContext context,
      required String firstname,
      required String lastname,
      String? email,
      String? villId,
      String? disId,
      String? proId,
      String? gender,
      XFile? imageFile,
      String? birthdayDate,
      String? password,
      required String type}) async {
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse('${repository.urlApi}api/update_admin_profile');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        'firstname': firstname.toString(),
        'lastname': lastname.toString(),
        'email': email ?? '',
        'password': password ?? '',
        'vill_id': villId ?? '',
        'dis_id': disId ?? '',
        'pro_id': proId ?? '',
        'birtday_date': birthdayDate ?? '',
        'gender': gender ?? '',
        'type': type
      });
      if (imageFile != null) {
        var picture =
            await http.MultipartFile.fromPath('profile_image', imageFile.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      // var responseBody = await response.stream.bytesToString();
      // print('00022222222222222222222222222222');
      if (response.statusCode == 200) {
        pickImageState.deleteFileImage();
        getProfiled();
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        Get.back(result: true);
      }
    } catch (e) {
      return CustomDialogs().showToast(
          text: 'something_went_wrong',
          backgroundColor: AppColor().black.withOpacity(0.8));
    }
  }
}
