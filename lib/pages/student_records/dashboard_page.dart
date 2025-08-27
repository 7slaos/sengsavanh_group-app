// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/check-in-out/check_in_out_page.dart';
import 'package:pathana_school_app/pages/student_records/profile_page.dart';
import 'package:pathana_school_app/pages/student_records/score_student_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/in_out_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/subject_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/app_size.dart';

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  AddressState addressState = Get.put(AddressState());
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  AppVerification appVerification = Get.put(AppVerification());
  RegisterState registerState = Get.put(RegisterState());
  List<Map<String, dynamic>> subjects = [
    {'title': 'score', 'icon': Icons.score, 'color': Colors.green},
    // {'title': 'subject'.tr, 'icon': Icons.subject, 'color': Colors.blue},
    {'title': 'profile', 'icon': Icons.person_pin, 'color': Colors.orange},
    {'title': 'Click_in-out', 'icon': Icons.touch_app_outlined, 'color': Colors.blue},
    {'title': 'language', 'icon': Icons.language, 'color': Colors.teal},
    {'title': 'logout', 'icon': Icons.logout, 'color': Colors.grey},
  ];

  void handleGridTap(int index) {
    final actions = {
      0: () =>
          Get.to(() => const ScoreStudentPage(), transition: Transition.fadeIn),
      1: () => Get.to(() =>  StudentProfilePage(type: 's'),
          transition: Transition.fadeIn),
      2: () => Get.to(() => InOutPage(type: 'owner_student'),
          transition: Transition.fadeIn),
      3: () => Get.to(() => const ChangeLanguagePage(),
          transition: Transition.fadeIn),
      4: () => logots(),
    };
    actions[index]?.call() ??
        CustomDialogs().showToast(
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'develop'.tr,
        );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await profileStudentState.getProfileStudent();
    addressState.getReligion();
    addressState.getNationality();
    addressState.geteducationLevel();
    addressState.getlanguageGroup();
    addressState.getEthinicity();
    addressState.getSpecialHealth();
    addressState.getResidence();
    addressState.getBloodGroup();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor.mainColor,
        toolbarHeight:0
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: appColor.mainColor,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: fSize * 0.003,
                    vertical: fSize * 0.003,
                  ),
                  child: GetBuilder<LocaleState>(builder: (lang) {
                    return GetBuilder<ProfileStudentState>(
                      builder: (get) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.25,
                                height: size.width *
                                    0.25, // Ensure a perfect circle
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3, color: appColor.white),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Repository().urlApi}${get.dataModels?.imagesProfile}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                        color: appColor.white),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text:
                                          '${'label_code'.tr}: ${(get.dataModels?.admissionNumber.toString() != 'null' && get.dataModels?.admissionNumber.toString() != '') ? get.dataModels?.admissionNumber : 'XXXXXX'}',
                                      color: appColor.white,
                                      fontSize: fixSize(0.0125, context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text:
                                          '${get.dataModels?.firstname ?? ''} ${get.dataModels?.lastname ?? ''}',
                                      color: appColor.white,
                                      fontSize: fixSize(0.0125, context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: fSize * 0.005),
                                    CustomText(
                                      text:
                                          '${'phone'.tr}: ${get.dataModels?.phone ?? ''}',
                                      color: Colors.white,
                                      fontSize: fixSize(0.0125, context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: fSize * 0.005),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text:
                                              '${"age".tr}: ${get.dataModels?.age} ${'year'.tr}',
                                          color: Colors.white,
                                          fontSize: fixSize(0.0125, context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        CustomText(
                                          text:
                                              '${"class".tr}: ${get.dataModels?.myClass ?? ''}',
                                          color: Colors.white,
                                          fontSize: fixSize(0.0125, context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                IconButton(
                  onPressed: () {
                    getData();
                  },
                  icon: Icon(Icons.autorenew),
                  color: appColor.white,
                )
              ],
            ),
            SizedBox(height: size.height * 0.02),
            // Subjects Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  itemCount: subjects.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        handleGridTap(index);
                      },
                      child: SubjectCard(
                        title: subjects[index]['title'],
                        icon: subjects[index]['icon'],
                        color: subjects[index]['color'],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  logots() async {
    var res = await CustomDialogs().LogoutyesAndNoDialogWithText(
        context, 'do_you_want_to_logout',
        color: Colors.black);

    if (res == true) {
      loginRegister.logouts();
    }
  }
}
