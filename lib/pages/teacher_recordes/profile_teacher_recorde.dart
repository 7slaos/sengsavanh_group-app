import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/profile_teacher_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTeacherRecordePage extends StatefulWidget {
  const ProfileTeacherRecordePage({super.key});

  @override
  State<ProfileTeacherRecordePage> createState() =>
      _ProfileTeacherRecordePageState();
}

class _ProfileTeacherRecordePageState extends State<ProfileTeacherRecordePage> {
  AddressState addressState = Get.put(AddressState());
  RegisterState registerState = Get.put(RegisterState());
  ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  PickImageState pickImageState = Get.put(PickImageState());

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController religion = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController villId = TextEditingController();
  TextEditingController disId = TextEditingController();
  TextEditingController proId = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController educationSystem = TextEditingController();
  TextEditingController educationLevel = TextEditingController();
  TextEditingController specialSubject = TextEditingController();
  TextEditingController finishSchool = TextEditingController();
  TextEditingController yearSystemLearn = TextEditingController();
  TextEditingController yearFinished = TextEditingController();
  TextEditingController duty = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController note = TextEditingController();
  bool obscureText = true;
  bool obscureTextPasseord = true;
  bool obscureTextConfirmPasseord = true;
  String gender = "2";
  bool get _generalFieldsEnabled => false;

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
    // Ensure data is loaded
    if (profileTeacherState.teacherModels == null) {
      await profileTeacherState.getProfiledTeacher();
      if (profileTeacherState.teacherModels == null) return;
    }

    setState(() {
      firstname.text = profileTeacherState.teacherModels?.firstname ?? '';
      lastname.text = profileTeacherState.teacherModels?.lastname ?? '';
      email.text = profileTeacherState.teacherModels?.email ?? '';
      phone.text = profileTeacherState.teacherModels?.phone ?? '';
      nickname.text = profileTeacherState.teacherModels?.nickname ?? '';
      registerState.birthdayDate.text =
          profileTeacherState.teacherModels?.birtdayDate ?? '';
      educationSystem.text =
          profileTeacherState.teacherModels?.educationSystem ?? '';
      specialSubject.text =
          profileTeacherState.teacherModels?.specialSubject ?? '';
      finishSchool.text = profileTeacherState.teacherModels?.finishSchool ?? '';
      yearSystemLearn.text =
          profileTeacherState.teacherModels?.yearSystemLearn ?? '';
      yearFinished.text = profileTeacherState.teacherModels?.yearFinished ?? '';
      note.text = profileTeacherState.teacherModels?.note ?? '';
      salary.text = profileTeacherState.teacherModels?.salary ?? '';
      duty.text = profileTeacherState.teacherModels?.duty ?? '';
      gender = profileTeacherState.teacherModels?.gender ?? '';
    });

    final proId = profileTeacherState.teacherModels?.proId?.id;
    final disId = profileTeacherState.teacherModels?.disId?.id;

    if (proId != null) {
      await addressState.getProvinceById(proId.toString());
      await addressState.getDistrict(proId, profileTeacherState.teacherModels?.disId);
    }
    if (disId != null) {
      await addressState.getVillage(disId, profileTeacherState.teacherModels?.villId);
    }
    if (profileTeacherState.teacherModels?.bloodGroup != null) {
      addressState.updateDropDownBloodGroup(
          profileTeacherState.teacherModels!.bloodGroup!);
    }
    if (profileTeacherState.teacherModels?.religion != null) {
      addressState
          .updateDropdownReligion(profileTeacherState.teacherModels!.religion!);
    }
    if (profileTeacherState.teacherModels?.nationality != null) {
      addressState.updateDropDownNationality(
          profileTeacherState.teacherModels!.nationality!);
    }
    if (profileTeacherState.teacherModels?.educationLevel != null) {
      addressState.updateDropDownEducationLevel(
          profileTeacherState.teacherModels!.educationLevel!);
    }
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
        child: GetBuilder<ProfileTeacherState>(builder: (profile) {
          if (profile.teacherModels == null) {
            return CircleLoad();
          }
          return GetBuilder<AddressState>(builder: (getAddress) {
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
                              border: Border.all(
                                  width: 4, color: appColor.mainColor),
                              shape: BoxShape
                                  .circle, // Makes the container circular
                              image: DecorationImage(
                                image: _.file != null
                                    ? FileImage(File(_.file!.path))
                                    : (profile.teacherModels!.imagesProfile !=
                                                null &&
                                            profile.teacherModels!
                                                    .imagesProfile !=
                                                '')
                                        ? NetworkImage(
                                            "${Repository().nuXtJsUrlApi}${profile.teacherModels!.imagesProfile}",
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
                        onTap: _generalFieldsEnabled
                            ? () {
                                pickImageState.showPickImage(context);
                              }
                            : null,
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
                            onChanged: _generalFieldsEnabled
                                ? (v) => updateGender(v.toString())
                                : null,
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
                            onChanged: _generalFieldsEnabled
                                ? (v) => updateGender(v.toString())
                                : null,
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
                            onChanged: _generalFieldsEnabled
                                ? (v) => updateGender(v.toString())
                                : null,
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
                  readOnly: !_generalFieldsEnabled,
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
                  readOnly: !_generalFieldsEnabled,
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
                // Form Fields
                CustomText(
                  text: 'nick_name',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: nickname,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'nick_name'.tr,
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

                CustomText(
                  text: 'province',
                  fontWeight: FontWeight.bold,
                  fontSize: fSize * 0.0165,
                ),

                DropdownButtonHideUnderline(
                  child: DropdownButton2<ProvinceDropdownModel>(
                    isExpanded: true,
                    hint: CustomText(
                      text: 'province',
                      fontSize: fSize * 0.016,
                      color: Theme.of(context).hintColor,
                    ),
                    items: getAddress.provinceList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: CustomText(
                                text: CheckLang(
                                        nameLa: item.nameLa ?? '',
                                        nameEn: item.nameEn)
                                    .toString(),
                                fontSize: fSize * 0.016,
                              ),
                            ))
                        .toList(),
                    value: getAddress.provinceList.firstWhereOrNull((e) =>
                            e.id.toString() ==
                            addressState.selectProvince?.id.toString()) ??
                        addressState.selectProvince,
                    onChanged: _generalFieldsEnabled
                        ? (value) {
                            addressState.updateDropDownProvince(value!);
                            if (value.id != null) {
                              addressState.getDistrict(value.id!, null);
                            }
                          }
                        : null,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: fixSize(0.0025, context),
                            offset: const Offset(0, 1),
                            color: appColor.grey,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: size.height * 0.4,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: registerState.searchprovinceGroup,
                      searchInnerWidgetHeight: 60,
                      searchInnerWidget: Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: registerState.searchprovinceGroup,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '${'search'.tr}...',
                            hintStyle: TextStyle(fontSize: fSize * 0.016),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final nameLa = item.value?.nameLa?.toLowerCase() ?? '';
                        final nameEn = item.value?.nameEn?.toLowerCase() ?? '';
                        return nameLa.contains(searchValue.toLowerCase()) ||
                            nameEn.contains(searchValue.toLowerCase());
                      },
                    ),
                    onMenuStateChange: _generalFieldsEnabled
                        ? (isOpen) {
                            addressState.clearDistrict();
                            addressState.clearVillage();
                          }
                        : null,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                if (addressState.districtList.isNotEmpty) ...[
                  CustomText(
                    text: 'district',
                    fontWeight: FontWeight.bold,
                    fontSize: fSize * 0.0165,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<DistrictDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'district',
                        fontSize: fSize * 0.016,
                        color: Theme.of(context).hintColor,
                      ),
                      items: getAddress.districtList
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: CustomText(
                                  text: CheckLang(
                                          nameLa: item.nameLa ?? '',
                                          nameEn: item.nameEn)
                                      .toString(),
                                  fontSize: fSize * 0.016,
                                ),
                              ))
                          .toList(),
                      value: getAddress.districtList.firstWhereOrNull((e) =>
                              e.id.toString() ==
                              addressState.selectDistrict?.id.toString()) ??
                          addressState.selectDistrict,
                      onChanged: _generalFieldsEnabled
                          ? (value) {
                              addressState.updateDropDownDistrict(value!);
                              if (value.id != null) {
                                addressState.getVillage(value.id!, null);
                              }
                            }
                          : null,
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: appColor.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: fixSize(0.0025, context),
                              offset: const Offset(0, 1),
                              color: appColor.grey,
                            ),
                          ],
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: size.height * 0.4,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 60,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: registerState.searchdistrictGroup,
                        searchInnerWidgetHeight: 60,
                        searchInnerWidget: Container(
                          height: 60,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: registerState.searchdistrictGroup,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: '${'search'.tr}...',
                              hintStyle: TextStyle(fontSize: fSize * 0.016),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          final nameLa =
                              item.value?.nameLa?.toLowerCase() ?? '';
                          final nameEn =
                              item.value?.nameEn?.toLowerCase() ?? '';
                          return nameLa.contains(searchValue.toLowerCase()) ||
                              nameEn.contains(searchValue.toLowerCase());
                        },
                      ),
                      onMenuStateChange: _generalFieldsEnabled
                          ? (isOpen) {
                              addressState.clearVillage();
                            }
                          : null,
                    ),
                  )
                ],
                SizedBox(
                  height: size.height * 0.02,
                ),
                if (addressState.villageList.isNotEmpty) ...[
                  CustomText(
                    text: 'village',
                    fontWeight: FontWeight.bold,
                    fontSize: fSize * 0.0165,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<VillageDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'village',
                        fontSize: fSize * 0.016,
                        color: Theme.of(context).hintColor,
                      ),
                      items: getAddress.villageList
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: CustomText(
                                  text: CheckLang(
                                          nameLa: item.nameLa ?? '',
                                          nameEn: item.nameEn)
                                      .toString(),
                                  fontSize: fSize * 0.016,
                                ),
                              ))
                          .toList(),
                      value: getAddress.villageList.firstWhereOrNull((e) =>
                              e.id.toString() ==
                              addressState.selectVillage?.id.toString()) ??
                          addressState.selectVillage,
                      onChanged: _generalFieldsEnabled
                          ? (value) {
                              addressState.updateDropDownVillage(value!);
                            }
                          : null,
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: appColor.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: fixSize(0.0025, context),
                              offset: const Offset(0, 1),
                              color: appColor.grey,
                            ),
                          ],
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: size.height * 0.4,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 60,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: registerState.searchvillageGroup,
                        searchInnerWidgetHeight: 60,
                        searchInnerWidget: Container(
                          height: 60,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: registerState.searchvillageGroup,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: '${'search'.tr}...',
                              hintStyle: TextStyle(fontSize: fSize * 0.016),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          final nameLa =
                              item.value?.nameLa?.toLowerCase() ?? '';
                          final nameEn =
                              item.value?.nameEn?.toLowerCase() ?? '';
                          return nameLa.contains(searchValue.toLowerCase()) ||
                              nameEn.contains(searchValue.toLowerCase());
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
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
                  readOnly: !_generalFieldsEnabled,
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
                GetBuilder<RegisterState>(builder: (getDate) {
                  return TextFormField(
                    // obscureText: obscureText,
                    controller: registerState.birthdayDate,
                    readOnly: true,
                    onTap: _generalFieldsEnabled
                        ? () {
                            registerState.selectDate(context);
                          }
                        : null,
                    decoration: InputDecoration(
                      hintText: 'birtdaydate'.tr,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: appColor.white,
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: appColor.mainColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                }),
                SizedBox(height: size.height * 0.007),
                CustomText(
                  text: 'Blood_type',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<BloodGroupDropdownModel>(
                    isExpanded: true,
                    hint: CustomText(
                      text: 'Blood_type',
                      fontSize: fSize * 0.016,
                      color: Theme.of(context).hintColor,
                    ),
                    items: getAddress.bloodgroupList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: CustomText(
                                text: CheckLang(
                                        nameLa: item.nameLa ?? '',
                                        nameEn: item.nameEn)
                                    .toString(),
                                fontSize: fSize * 0.016,
                              ),
                            ))
                        .toList(),
                    value: getAddress.bloodgroupList.firstWhereOrNull((e) =>
                            e.id.toString() ==
                            addressState.selectBloodGroup?.id.toString()) ??
                        addressState.selectBloodGroup,
                    onChanged: _generalFieldsEnabled
                        ? (value) {
                            addressState.updateDropDownBloodGroup(value!);
                          }
                        : null,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: fixSize(0.0025, context),
                            offset: const Offset(0, 1),
                            color: appColor.grey,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: size.height * 0.4,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: registerState.searchBloodGroup,
                      searchInnerWidgetHeight: 60,
                      searchInnerWidget: Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: registerState.searchBloodGroup,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '${'search'.tr}...',
                            hintStyle: TextStyle(fontSize: fSize * 0.016),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final nameLa = item.value?.nameLa?.toLowerCase() ?? '';
                        final nameEn = item.value?.nameEn?.toLowerCase() ?? '';
                        return nameLa.contains(searchValue.toLowerCase()) ||
                            nameEn.contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.007),
                CustomText(
                  text: 'religion',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<ReligionDropdownModel>(
                    isExpanded: true,
                    hint: CustomText(
                      text: 'religion',
                      fontSize: fSize * 0.016,
                      color: Theme.of(context).hintColor,
                    ),
                    items: getAddress.religiongroupList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: CustomText(
                                text: CheckLang(
                                        nameLa: item.nameLa ?? '',
                                        nameEn: item.nameEn)
                                    .toString(),
                                fontSize: fSize * 0.016,
                              ),
                            ))
                        .toList(),
                    value: getAddress.religiongroupList.firstWhereOrNull((e) =>
                            e.id.toString() ==
                            addressState.selectReligion?.id.toString()) ??
                        addressState.selectReligion,
                    onChanged: _generalFieldsEnabled
                        ? (value) {
                            addressState.updateDropdownReligion(value!);
                          }
                        : null,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: fixSize(0.0025, context),
                            offset: const Offset(0, 1),
                            color: appColor.grey,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: size.height * 0.4,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: registerState.searchReligion,
                      searchInnerWidgetHeight: 60,
                      searchInnerWidget: Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: registerState.searchReligion,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '${'search'.tr}...',
                            hintStyle: TextStyle(fontSize: fSize * 0.016),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final nameLa = item.value?.nameLa?.toLowerCase() ?? '';
                        final nameEn = item.value?.nameEn?.toLowerCase() ?? '';
                        return nameLa.contains(searchValue.toLowerCase()) ||
                            nameEn.contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.007),
                CustomText(
                  text: 'nationality',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<NationalityDropdownModel>(
                    isExpanded: true,
                    hint: CustomText(
                      text: 'nationality',
                      fontSize: fSize * 0.016,
                      color: Theme.of(context).hintColor,
                    ),
                    items: getAddress.nationalityList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: CustomText(
                                text: CheckLang(
                                        nameLa: item.nameLa ?? '',
                                        nameEn: item.nameEn)
                                    .toString(),
                                fontSize: fSize * 0.016,
                              ),
                            ))
                        .toList(),
                    value: getAddress.nationalityList.firstWhereOrNull((e) =>
                            e.id.toString() ==
                            addressState.selectNationality?.id.toString()) ??
                        addressState.selectNationality,
                    onChanged: _generalFieldsEnabled
                        ? (value) {
                            addressState.updateDropDownNationality(value!);
                          }
                        : null,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: fixSize(0.0025, context),
                            offset: const Offset(0, 1),
                            color: appColor.grey,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: size.height * 0.4,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: registerState.searchNationality,
                      searchInnerWidgetHeight: 60,
                      searchInnerWidget: Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: registerState.searchNationality,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '${'search'.tr}...',
                            hintStyle: TextStyle(fontSize: fSize * 0.016),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final nameLa = item.value?.nameLa?.toLowerCase() ?? '';
                        final nameEn = item.value?.nameEn?.toLowerCase() ?? '';
                        return nameLa.contains(searchValue.toLowerCase()) ||
                            nameEn.contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.007),
                CustomText(
                  text: 'Education_system',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: educationSystem,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'Education_system'.tr,
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
                  text: 'Education_level',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<EducationLevelDropdownModel>(
                    isExpanded: true,
                    hint: CustomText(
                      text: 'Education_level',
                      fontSize: fSize * 0.016,
                      color: Theme.of(context).hintColor,
                    ),
                    items: getAddress.educationlevelList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: CustomText(
                                text: CheckLang(
                                        nameLa: item.nameLa ?? '',
                                        nameEn: item.nameEn)
                                    .toString(),
                                fontSize: fSize * 0.016,
                              ),
                            ))
                        .toList(),
                    value: getAddress.educationlevelList.firstWhereOrNull((e) =>
                            e.id.toString() ==
                            addressState.selectEducationLevel?.id.toString()) ??
                        addressState.selectEducationLevel,
                    onChanged: _generalFieldsEnabled
                        ? (value) {
                            addressState.updateDropDownEducationLevel(value!);
                          }
                        : null,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: fixSize(0.0025, context),
                            offset: const Offset(0, 1),
                            color: appColor.grey,
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: size.height * 0.4,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 60,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: registerState.searchNationality,
                      searchInnerWidgetHeight: 60,
                      searchInnerWidget: Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: registerState.searchNationality,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: '${'search'.tr}...',
                            hintStyle: TextStyle(fontSize: fSize * 0.016),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final nameLa = item.value?.nameLa?.toLowerCase() ?? '';
                        final nameEn = item.value?.nameEn?.toLowerCase() ?? '';
                        return nameLa.contains(searchValue.toLowerCase()) ||
                            nameEn.contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.007),
                CustomText(
                  text: 'Specialization',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: specialSubject,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'Specialization'.tr,
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
                  text: 'Graduated_from_school',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: finishSchool,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'Graduated_from_school'.tr,
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
                  text: 'School year system',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: yearSystemLearn,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'School year system'.tr,
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
                  text: 'End_of_the_year',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: yearFinished,
                  keyboardType: TextInputType.number,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'End_of_the_year'.tr,
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
                  text: 'Duties',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: duty,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Duties'.tr,
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
                  text: 'salary',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: salary,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'salary'.tr,
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
                  text: 'note',
                  fontSize: fixSize(0.0146, context),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: size.height * 0.007),
                TextFormField(
                  // obscureText: obscureText,
                  controller: note,
                  readOnly: !_generalFieldsEnabled,
                  decoration: InputDecoration(
                    hintText: 'note'.tr,
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
                        fontSize: fixSize(0.014, context),
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
                        text: 'update',
                        fontSize: fixSize(0.0140, context),
                        color: appColor.white,
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
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
    profileTeacherState.updateTeacherRcorde(
        context: context,
        firstname: firstname.text.toString(),
        lastname: lastname.text.toString(),
        password: password.text.toString(),
        gender: gender,
        nickname: nickname.text,
        religion: addressState.selectReligion?.id.toString(),
        birtdayDate: registerState.birthdayDate.text,
        bloodGroup: addressState.selectBloodGroup?.id.toString(),
        nationality: addressState.selectNationality?.id.toString(),
        yearSystemLearn: yearSystemLearn.text,
        yearFinished: yearFinished.text,
        educationLevel: addressState.selectEducationLevel?.id.toString(),
        educationSystem: educationSystem.text,
        specialSubject: specialSubject.text,
        fileImage: pickImageState.file,
        note: note.text,
        villId: addressState.selectVillage?.id.toString() ?? '',
        disId: addressState.selectDistrict?.id.toString() ?? '',
        proId: addressState.selectProvince?.id.toString() ?? '',
        email: email.text);
  }
}
