import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/profile_page.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppVerification appVerification = Get.put(AppVerification());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: AppBar(
        title: CustomText(
          text: 'setting',
          fontSize: fixSize(0.019, context),
          color: appColor.white,
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      body: appVerification.role == 's'
          ? GetBuilder<ProfileStudentState>(
              builder: (getStudent) {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.05),
                    ListTile(
                      onTap: () {
                        Get.to(() => const ProfilePage(),
                            transition: Transition.fadeIn);
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
                  ],
                );
              },
            )
          // End profile student

          // profile Parent
          : GetBuilder<ProfileState>(
              builder: (get) {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.05),
                    ListTile(
                      onTap: () {
                        Get.to(() => const ProfilePage(),
                            transition: Transition.fadeIn);
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
                  ],
                );
              },
            ),
      bottomNavigationBar: ButtonWidget(
        height: fSize * 0.05,
        width: size.width,
        color: appColor.white,
        // ignore: deprecated_member_use
        backgroundColor: appColor.mainColor.withOpacity(0.8),
        fontSize: fSize * 0.0185,
        fontWeight: FontWeight.bold,
        borderRadius: 0,
        onPressed: () {
          Get.back();
        },
        text: 'home',
      ),
    );
  }
}
