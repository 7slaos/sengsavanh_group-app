import 'dart:io';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  RegisterState registerState = Get.put(RegisterState());
  ProfileState profileState = Get.put(ProfileState());
  PickImageState pickImageState = Get.put(PickImageState());
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final confirmPassword = TextEditingController();
  final villId = TextEditingController();
  final disId = TextEditingController();
  final proId = TextEditingController();
  final password = TextEditingController();
  final birtdayDate = TextEditingController();
  bool obscureText = true;
  bool obscureTextPasseord = true;
  bool obscureTextConfirmPasseord = true;
  String gender = "2";

  @override
  void initState() {
    getData();
    super.initState();
  }

  updateGender(String v) {
    setState(() {
      gender = v;
    });
  }

  getData() async {
    setState(() {
      gender = profileState.profiledModels?.gender ?? '';
      firstname.text = profileState.profiledModels?.firstname ?? '';
      lastname.text = profileState.profiledModels?.lastname ?? '';
      email.text = profileState.profiledModels?.email ?? '';
      phone.text = profileState.profiledModels?.phone ?? '';
      birtdayDate.text = profileState.profiledModels?.birtdayDate ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const CustomText(text: 'edit_profile'),
        backgroundColor: appColor.mainColor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(fSize * 0.016),
        child: GetBuilder<ProfileState>(builder: (profile) {
          if (profile.profiledModels == null) {
            return CircleLoad();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              SizedBox(height: size.height * 0.03),
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
                                  : (profile.profiledModels!.profileImage !=
                                              null &&
                                          profile.profiledModels!
                                                  .profileImage !=
                                              '')
                                      ? NetworkImage(
                                          "${Repository().urlApi}${profile.profiledModels!.profileImage}",
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
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  right: size.width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: '2',
                          groupValue: gender,
                          activeColor: appColor.mainColor,
                          onChanged: (v) => {updateGender(v.toString())},
                        ),
                        CustomText(text: 'male')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: '1',
                          groupValue: gender,
                          activeColor: appColor.mainColor,
                          onChanged: (v) => {updateGender(v.toString())},
                        ),
                        CustomText(text: 'female')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: '3',
                          groupValue: gender,
                          activeColor: appColor.mainColor,
                          onChanged: (v) => {updateGender(v.toString())},
                        ),
                        CustomText(text: 'other')
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Form Fields
              CustomText(
                text: 'firstname',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                // obscureText: obscureText,
                controller: firstname,
                decoration: InputDecoration(
                  hintText: 'firstname'.tr,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Form Fields
              CustomText(
                text: 'lastname',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                // obscureText: obscureText,
                controller: lastname,
                decoration: InputDecoration(
                  hintText: 'lastname'.tr,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              CustomText(
                text: 'phone',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                // obscureText: obscureText,
                controller: phone,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: '20**********',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.007),
              CustomText(
                text: 'email',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                // obscureText: obscureText,
                controller: email,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.007),
              CustomText(
                text: 'birtdaydate',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                // obscureText: obscureText,
                controller: birtdayDate,
                decoration: InputDecoration(
                  hintText: 'birtdaydate'.tr,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  await registerState.selectDate(context);
                  setState(() {
                    birtdayDate.text = registerState.birthdayDate.text;
                  });
                },
              ),
              SizedBox(height: size.height * 0.007),
              CustomText(
                text: 'password',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                obscureText: obscureTextPasseord,
                controller: password,
                decoration: InputDecoration(
                  hintText: '*************',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: obscureTextPasseord
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscureTextPasseord =
                            !obscureTextPasseord; // Toggle the state
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.007),
              CustomText(
                text: 'confirm_password',
                fontSize: fixSize(0.0146, context),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: size.height * 0.007),
              TextFormField(
                obscureText: obscureTextConfirmPasseord,
                controller: confirmPassword,
                decoration: InputDecoration(
                  hintText: '*************',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: appColor.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: obscureTextConfirmPasseord
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscureTextConfirmPasseord =
                            !obscureTextConfirmPasseord;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      // Handle cancel action
                      Get.back();
                    },
                    child: CustomText(
                      text: 'back',
                      fontSize: fixSize(0.0145, context),
                    ),
                  ),

                  // Save Update Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      // Handle save action
                      updateProfile();
                    },
                    child: CustomText(
                      text: 'edit',
                      fontSize: fixSize(0.0145, context),
                      color: appColor.white,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  updateProfile() async {
    if (password.text != confirmPassword.text) {
      CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'password_do_not_match'.tr);
      return;
    }
    profileState.updateadminProfile(
        context: context,
        firstname: firstname.text,
        lastname: lastname.text,
        password: password.text,
        gender: gender,
        email: email.text,
        birthdayDate: birtdayDate.text,
        imageFile: pickImageState.file,
        type: 'adminschool');
  }
}
