// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/notifications/init_listen_noti.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/history_payment_page.dart';
import 'package:pathana_school_app/pages/mark_student/subject_teacher_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/take_children_page.dart';
import 'package:pathana_school_app/pages/score_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/follow_student_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/profile_teacher_recorde.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/check_role_permission_state.dart';
import 'package:pathana_school_app/states/dashboard_teacher_state.dart';
import 'package:pathana_school_app/states/follow_student_state.dart';
import 'package:pathana_school_app/states/profile_teacher_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/subject_card_widget.dart';

import '../check-in-out/check_in_out_page.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  InitListenNoti initListenNoti = Get.put(InitListenNoti());
  CheckRolePermissionState checkRolePermissionState =
      Get.put(CheckRolePermissionState());
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  DashboardTeacherState dashboardTeacherState =
      Get.put(DashboardTeacherState());
  FollowStudentState followStudentState = Get.put(FollowStudentState());
  ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  AddressState addressState = Get.put(AddressState());
  List<Map<String, dynamic>> subjects = [
    {'title': 'score', 'icon': Icons.score, 'color': Colors.blue},
    {'title': 'profile', 'icon': Icons.person_pin, 'color': Colors.orange},
    {'title': 'Missing_school', 'icon': Icons.cancel, 'color': Colors.red},
    {
      'title': 'take_children',
      'icon': Icons.campaign_outlined,
      'color': Colors.purple
    },
    {
      'title': 'scan-in-out',
      'icon': Icons.qr_code_scanner,
      'color': Colors.pink
    },
    {
      'title': 'mark-student',
      'icon': Icons.note_alt,
      'color': Colors.red
    }
  ];
  void handleGridTap(String title) {
    final actions = {
      'score': () =>
          Get.to(() => const ScorePage(), transition: Transition.fadeIn),
      'profile': () {
        addressState.clearData();
        Get.to(() => const ProfileTeacherRecordePage(),
            transition: Transition.fadeIn);
      },
      'Missing_school': () =>
          Get.to(() => FollowStudentPage(), transition: Transition.fadeIn),
      'take_children': () =>
          Get.to(() => const TakeChildrenPage(), transition: Transition.fadeIn),
      'scan-in-out': () =>
          Get.to(() => CheckInOutPage(), transition: Transition.fadeIn),
      'mark-student': () =>
          Get.to(() => SubjectTeacherPage(), transition: Transition.fadeIn),
      'Tuition_fees': () => Get.to(
          () => HistoryPaymentPage(
                type: 't',
              ),
          transition: Transition.fadeIn),
      'language': () => Get.to(() => const ChangeLanguagePage(),
          transition: Transition.fadeIn),
      'Delete_Account': () => deleteAccount(context),
      'logout': () => logots(),
    };
    actions[title]?.call();
    // actions[title]?.call() ??
    //     CustomDialogs().showToast(
    //       backgroundColor: AppColor().black.withOpacity(0.8),
    //       text: 'develop'.tr,
    //     );
  }

  Future<void> deleteAccount(BuildContext context) async {
    // Show confirmation dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text: 'Confirm_Account_Deletion'),
        content: CustomText(text: 'des_confirm_delete_account'),
        actions: <Widget>[
          // Cancel Button
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: CustomText(text: 'cancel'),
          ),
          // Delete Button
          TextButton(
            onPressed: () async {
              Get.back();
              loginRegister.deleteAccount();
            },
            child: CustomText(
              text: 'delete',
              color: AppColor().red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    initListenNoti.getInit();
    dashboardTeacherState.getAll();
    followStudentState.fetchStudentDropdown();
    profileTeacherState.getProfiledTeacher();
    addressState.getBloodGroup();
    addressState.getReligion();
    addressState.getNationality();
    addressState.geteducationLevel();
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: appColor.mainColor, toolbarHeight: 0),
      body: GetBuilder<CheckRolePermissionState>(builder: (checkRole) {
        if (checkRole.check == false) {
          return Column(
            children: [Expanded(child: Center(child: CircleLoad()))],
          );
        }
        if (checkRole.checkRole("access_Fees") == true &&
            !subjects.any((e) => e['title'] == 'Tuition_fees')) {
          subjects.add({
            'title': 'Tuition_fees',
            'icon': Icons.money,
            'color': Colors.blue
          });
        }
        if (!subjects.any((e) => e['title'] == 'language')) {
          subjects.add({
            'title': 'language',
            'icon': Icons.language,
            'color': Colors.green
          });
        }
        if (!subjects.any((e) => e['title'] == 'Delete_Account')) {
          subjects.add({
            'title': 'Delete_Account',
            'icon': Icons.delete,
            'color': Colors.red
          });
        }
        if (!subjects.any((e) => e['title'] == 'logout')) {
          subjects.add(
            {'title': 'logout', 'icon': Icons.logout, 'color': Colors.grey},
          );
        }
        return SafeArea(
          child: Column(
            children: [
              // Profile Card
              Container(
                decoration: BoxDecoration(
                  color: appColor.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(fSize * 0.03),
                    bottomRight: Radius.circular(fSize * 0.03),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: fSize * 0.004,
                  vertical: fSize * 0.004,
                ),
                child: GetBuilder<ProfileTeacherState>(
                  builder: (getProfile) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${getProfile.repository.urlApi}${getProfile.teacherModels?.imagesProfile}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: appColor.mainColor,
                              ),
                              errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                            ),
                          ),
                          SizedBox(width: size.width * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      '${getProfile.teacherModels?.firstname ?? ''} ${getProfile.teacherModels?.lastname ?? ''}',
                                  color: Colors.white,
                                  fontSize: fixSize(0.017, context),
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: fSize * 0.005),
                                CustomText(
                                  text: getProfile.teacherModels?.phone ?? '',
                                  color: Colors.white70,
                                  fontSize: fixSize(0.014, context),
                                ),
                                SizedBox(height: fSize * 0.005),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              logots();
                            },
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Colors.white,
                              size: fSize * 0.025,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Subjects Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    itemCount: subjects.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          handleGridTap(subjects[index]['title']);
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
        );
      }),
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
