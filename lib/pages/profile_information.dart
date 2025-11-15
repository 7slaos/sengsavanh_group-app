import 'dart:io';

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/profile_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileInformationPage extends StatefulWidget {
  const ProfileInformationPage({super.key});

  @override
  State<ProfileInformationPage> createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  ProfileState profileState = Get.put(ProfileState());
  PickImageState  pickImageState  =  Get.put(PickImageState());
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  AppVerification appVerification = Get.put(AppVerification());

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    profileState.getProfiled();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      body: GetBuilder<ProfileState>(
        builder: (get) {
          return Column(
            children: [
              SizedBox(height: size.height * 0.05),
              // Center(
              //   child: Stack(
              //     alignment: Alignment.bottomRight,
              //     children: [
              // Container(
              //   width: size.width * 0.5,
              //   height: size.width *
              //       0.5, // Set the height equal to the width for a perfect circle
              //   decoration: BoxDecoration(
              //     border: Border(
              //       right: BorderSide(
              //           width: 2, color: appColor.mainColor),
              //       left: BorderSide(
              //           width: 2, color: appColor.mainColor),
              //       top: BorderSide(
              //           width: 2, color: appColor.mainColor),
              //       bottom: BorderSide(
              //           width: 2, color: appColor.mainColor),
              //     ),
              //     shape: BoxShape
              //         .circle, // Makes the container circular
              //     image: DecorationImage(
              //       image: NetworkImage(
              //         get.profiledModels?.profileImage != null
              //             ? "${get.repository.nuXtJsUrlApi}${get.profiledModels!.profileImage}"
              //             : 'https://thumbs.dreamstime.com/b/parents-hugging-child-mom-dad-their-son-happy-loving-family-cute-cartoon-characters-vector-illustration-130101727.jpg',
              //       ),
              //       fit: BoxFit
              //           .cover, // Ensures the image fits within the circle
              //     ),
              //   ),
              // ),
              //       InkWell(
              //         onTap: () {
              //           Get.to(() => const ProfilePage(),
              //               transition: Transition.fadeIn);
              //         },
              //         child: CircleAvatar(
              //           backgroundColor: appColor.mainColor,
              //           child: Icon(
              //             Icons.edit_outlined,
              //             color: appColor.white,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GetBuilder<PickImageState>(
                      builder: (_) {
                        return Container(
                          width: size.width * 0.5,
                          height: size.width *
                              0.5, // Set the height equal to the width for a perfect circle
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 4, color: appColor.mainColor),
                            shape:
                                BoxShape.circle, // Makes the container circular
                            image: DecorationImage(
                              image: _.file != null
                                  ? FileImage(File(_.file!.path))
                                  : (get.profiledModels!.profileImage != null &&
                                          get.profiledModels!.profileImage !=
                                              '')
                                      ? NetworkImage(
                                          "${Repository().nuXtJsUrlApi}${get.profiledModels!.profileImage}",
                                        )
                                      : AssetImage('assets/images/logo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Error handling
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        pickImageState.showPickImage(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: pickImageState.appColor.mainColor,
                        child: Icon(
                          Icons.camera_alt,
                          color: pickImageState.appColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: fSize * 0.01),
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
              ListTile(
                onTap: () async {
                  var res = await CustomDialogs().LogoutyesAndNoDialogWithText(
                      context, 'do_you_want_to_logout',
                      color: appColor.black);

                  if (res == true) {
                    loginRegister.logouts();
                  }
                },
                title: Row(
                  children: [
                    const Icon(Icons.logout),
                    SizedBox(
                      width: fSize * 0.02,
                    ),
                    CustomText(
                      text: 'logout',
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
