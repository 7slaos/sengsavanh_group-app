import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/check-in-out/check_in_out_page.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/profile_teacher_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

import '../../custom/app_size.dart';
import '../../functions/determine_postion.dart';
import '../../states/checkin-out-student/check_in_out_student_state.dart';

class InOutPage extends StatefulWidget {
  const InOutPage({super.key, this.type = 'owner_teacher'});
  final String type;
  @override
  State<InOutPage> createState() => _InOutPageState();
}

class _InOutPageState extends State<InOutPage> {
  ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  CheckInOutStudentState checkInOutStudentState =
      Get.put(CheckInOutStudentState());
  String? lat;
  String? lng;
  @override
  void initState() {
    getCurrentPosition();
    if (profileTeacherState.teacherModels == null && widget.type == 'owner_teacher') {
      profileTeacherState.checkToken();
    }
    if (profileStudentState.dataModels == null && widget.type == 'owner_student') {
      profileStudentState.checkToken();
    }
    checkInOutStudentState.checkCurrentCheckIn(checkin_teacher_records_id:  profileTeacherState.teacherModels?.id.toString() ?? '');
    super.initState();
  }

  getCurrentPosition () async{
    Position pos = await DeterminePosition().determinePosition();
    setState(() {
      lat = pos.latitude.toString();
      lng = pos.longitude.toString();
    });
  }

  void confirmCheckInOut(String type, String status, String teacherId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: status == 'check_in' ? 'check_in'.tr : 'check_out'.tr,
      desc: 'do_you_want_to_confirm'.tr,
      dismissOnTouchOutside: false,
      btnOkText: 'ok'.tr,
      btnCancelText: 'cancel'.tr,
      dismissOnBackKeyPress: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if(widget.type == 'owner_teacher') {
          checkInOutStudentState.confirmRequestGoHome(
              context: context,
              type: type,
              checkin_teacher_records_id: teacherId,
              lat: lat!,
              lng: lng!);
        }else {
          checkInOutStudentState.confirmRequestGoHome(
              context: context,
              type: type,
              student_records_id: teacherId,
              lat: lat!,
              lng: lng!);
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Click_in-out',
          fontSize: fixSize(0.02, context),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            size: fixSize(0.02, context),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.history, size: fixSize(0.02, context)),
              onPressed: () {
                Get.to(() => CheckInOutPage(type: widget.type),
                    transition: Transition.fadeIn);
              }),
        ],
      ),
      body: GetBuilder<ProfileTeacherState>(builder: (controller) {
        return GetBuilder<ProfileStudentState>(
          builder: (studentController) {
            return GetBuilder<CheckInOutStudentState>(
              builder: (check) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // shrink to content
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'ກະລຸນາກົດປຸ່ມຂ້າງລູ່ມນີ້ ເພື່ອເຂົ້າ ຫຼື ອອກ',
                          fontSize: fixSize(0.014, context),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: check.checkIn == true ? appColor.red : appColor.green,
                          ),
                          icon: Icon(Icons.touch_app_outlined,
                              color: Colors.white, size: fixSize(0.02, context)),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              text: check.checkIn == true ? 'check_out' : 'check_in',
                              color: appColor.white,
                              fontSize: fixSize(0.016, context),
                            ),
                          ),
                          onPressed: () {
                            if (controller.teacherModels == null && widget.type == 'owner_teacher') {
                                profileTeacherState.checkToken();
                                CustomDialogs().showToast(
                                    text: 'Something went wrong please try again',
                                    backgroundColor: appColor.red);
                            }
                            if (studentController.dataModels == null && widget.type == 'owner_teacher') {
                              profileStudentState.checkToken();
                              CustomDialogs().showToast(
                                  text: 'Something went wrong please try again',
                                  backgroundColor: appColor.red);
                            }
                            else if (lat == null && lng == null) {
                              getCurrentPosition();
                              CustomDialogs().showToast(
                                  text: 'Something went wrong please try again',
                                  backgroundColor: appColor.red);
                            }else {
                              if(widget.type == 'owner_teacher') {
                                confirmCheckInOut('owner_teacher', 'check_in',
                                    controller.teacherModels!.teacherRecordId
                                        .toString());
                              }else{
                                confirmCheckInOut('owner_student', 'check_in',
                                    studentController.dataModels!.studentRecordsId
                                        .toString());
                              }
                            }
                          },
                        ),
                        if(check.checkIn == true) ... [
                        const SizedBox(height: 50),
                        Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: fixSize(0.013, context),
                                color: appColor.green,
                                fontFamily: 'Noto Sans Lao'),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              pause: Duration(milliseconds: 500),
                              animatedTexts: [
                                TypewriterAnimatedText('${"check_in".tr}${"success".tr}',
                                    speed: Duration(milliseconds: 500)),
                              ],
                            ),
                          ),
                        )],
                      ],
                    ),
                  ),
                );
              }
            );
          }
        );
      }),
    );
  }
}
