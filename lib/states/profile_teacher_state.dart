import 'package:image_picker/image_picker.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/models/profile_teacher_recorde_model.dart';
import 'package:multiple_school_app/pages/login_page.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/appverification.dart';
import 'package:multiple_school_app/states/register_state.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileTeacherState extends GetxController {
  AppVerification appVerification = Get.put(AppVerification());
  RegisterState registerState = Get.put(RegisterState());
  Repository repository = Repository();
  TeacherRcordeModels? teacherModels;
  

  Future<void> checkToken() async {
    // Use Nuxt token for protected APIs
    final t = appVerification.nUxtToken.isNotEmpty
        ? appVerification.nUxtToken
        : appVerification.token;
    if (t.isEmpty) {
      await appVerification.removeToken();
      Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
      return;
    }
    await getProfiledTeacher();
  }

  getProfiledTeacher() async {
    try {
      teacherModels = null;
      var res = await repository.get(
        url: repository.nuXtJsUrlApi + repository.teacherRecordePofiled,
        auth: true,
      );
      print("Teacher profilesssssssssss");
      print(res.body);
      if (res.statusCode == 200) {
        final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
        teacherModels =
            TeacherRcordeModels.fromJson(jsonDecode(text)['data']);
      } else {
        final text = (() {
          try {
            return utf8.decode(res.bodyBytes);
          } catch (_) {
            return res.body;
          }
        })();
        final lower = text.toLowerCase();
        final looksLikeAuthError = res.statusCode == 401 ||
            res.statusCode == 403 ||
            lower.contains('unauthenticated') ||
            lower.contains('invalid token') ||
            lower.contains('jwt') ||
            lower.contains('token expired');
        if (looksLikeAuthError) {
          await appVerification.removeToken();
          Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
          return;
        }
      }
    } catch (e) {
      // print(e);
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
    update();
  }

  Future<void> updateTeacherRcorde(
      {required BuildContext context,
      required String firstname,
      required String lastname,
      String? nickname,
      String? email,
      String? religion,
      String? nationality,
      String? gender,
      String? villId,
      String? disId,
      String? proId,
      String? bloodGroup,
      String? password,
      String? birtdayDate,
      String? educationSystem,
      String? educationLevel,
      String? specialSubject,
      String? finishSchool,
      String? yearSystemLearn,
      String? yearFinished,
      String? note,
      XFile? fileImage}) async {
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse(repository.nuXtJsUrlApi + repository.updateTeacherRecorde);
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname ?? '',
        'email': email ?? '',
        'religion_id': religion ?? '',
        'gender': gender ?? '',
        'vill_id': villId ?? '',
        'dis_id': disId ?? '',
        'pro_id': proId ?? '',
        'nationality_id': nationality ?? '',
        'blood_group_id': bloodGroup ?? '',
        'birtday_date': birtdayDate ?? '',
        'education_system': educationSystem ?? '',
        'education_level_id': educationLevel ?? '',
        'special_subject': specialSubject ?? '',
        'finish_school': finishSchool ?? '',
        'year_system_learn': yearSystemLearn ?? '',
        'year_finished': yearFinished ?? '',
        'note': note ?? '',
        'password': password ?? ''
      });
      if (fileImage != null) {
        var picture =
            await http.MultipartFile.fromPath('profile_image', fileImage.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      var responseBody = await response.stream.bytesToString();
      // print('2222222222222222222222222222222222222222222');
      // print(responseBody);
      if (response.statusCode == 200) {
        registerState.clearData();
        getProfiledTeacher();
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        Get.back(result: true);
      } else {
        CustomDialogs().showToast(
          backgroundColor: AppColor().red,
          text: jsonDecode(responseBody)['message'],
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black,
        text: 'something_went_wrong'.tr,
      );
    }
  }
}
