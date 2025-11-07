import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/profile_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/profile_teacher_recorde.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/widgets/custom_app_bar.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  HomeState homeState = Get.put(HomeState());
  AuthLoginRegister authLoginRegister = Get.put(AuthLoginRegister());
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: InkWell(
            onTap: () {
              homeState.setCurrentPage(0);
            },
            child: Icon(Icons.arrow_back, color: appColor.white)),
        orientation: orientation,
        height: size.height,
        color: appColor.white,
        title: "setting",
      ),
      body: GetBuilder<AppVerification>(
        builder: (getRole) {
          return Column(
            children: [
              SizedBox(height: fSize * 0.01),
              ListTile(
                onTap: () {
                  if(getRole.role == 'p'){
                      Get.to(() => const ProfilePage(), transition: Transition.fadeIn);
                  }else{
                      Get.to(() => const ProfileTeacherRecordePage(), transition: Transition.fadeIn);
                  }
                },
                title: Row(
                  children: [
                    const Icon(Icons.person_pin),
                    SizedBox(
                      width: fSize * 0.02,
                    ),
                    CustomText(
                      text: 'profile',
                      fontSize: fSize * 0.0165,
                    )
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: appColor.grey,
                  size: fSize * 0.0165,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => const ChangeLanguagePage(),
                      transition: Transition.fadeIn);
                },
                title: Row(
                  children: [
                    const Icon(Icons.language),
                    SizedBox(
                      width: fSize * 0.02,
                    ),
                    CustomText(
                      text: 'change_language',
                      fontSize: fSize * 0.0165,
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: appColor.grey,
                  size: fSize * 0.0165,
                ),
              ),
              ListTile(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.scale,
                    title: 'confirm'.tr,
                    desc: "${'Do_you_want_to_allow_new_notifications'.tr} ?",
                    dismissOnTouchOutside: false,
                    btnCancelText: 'cancel'.tr,
                    btnOkText: 'ok'.tr,
                    dismissOnBackKeyPress: false,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      authLoginRegister.deleteTokenDevices();
                    },
                  ).show();
                },
                title: Row(
                  children: [
                    const Icon(Icons.close),
                    SizedBox(
                      width: fSize * 0.02,
                    ),
                    CustomText(
                      text: "notification",
                      fontSize: fSize * 0.0165,
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: appColor.grey,
                  size: fSize * 0.0165,
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
