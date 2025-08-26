import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/home_model.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import '../../widgets/text_field_widget.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key, required this.type, this.data});
  final String type;
  final HomeModel? data;
  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  PickImageState pickImageState = Get.put(PickImageState());
  RegisterState registerState = Get.put(RegisterState());
  AddressState addressState = Get.put(AddressState());
  bool obscureText = true;
  bool obscureTextPasseord = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    if (widget.type == 's') {
      if (profileStudentState.dataModels?.religion != null) {
        addressState
            .updateDropdownReligion(profileStudentState.dataModels!.religion!);
      }
      if (profileStudentState.dataModels?.nationality != null) {
        addressState.updateDropDownNationality(
            profileStudentState.dataModels!.nationality!);
      }
      if (profileStudentState.dataModels?.ethnicity != null) {
        addressState.updateDropDownEthinicity(
            profileStudentState.dataModels!.ethnicity!);
      }

      if (profileStudentState.dataModels?.groupLanguage != null) {
        addressState.updateDropDownlanguageDrop(
            profileStudentState.dataModels!.groupLanguage!);
      }
      if (profileStudentState.dataModels?.specialHealth != null) {
        addressState.updateDropDownspecialHealth(
            profileStudentState.dataModels!.specialHealth!);
      }
      if (profileStudentState.dataModels?.living != null) {
        addressState
            .updateDropDownResidences(profileStudentState.dataModels!.living!);
      }
      if (profileStudentState.dataModels?.bloodGroup != null) {
        addressState.updateDropDownBloodGroup(
            profileStudentState.dataModels!.bloodGroup!);
      }

      if (profileStudentState.dataModels != null) {
        await registerState.getCurrentProfile(
            profileStudentState.dataModels, null, 's');
        Future.delayed(Duration(seconds: 10));
        await addressState
            .getDistrictById(profileStudentState.dataModels!.disId.toString());
        await addressState
            .getVillageById(profileStudentState.dataModels!.villId.toString());
        await registerState.getmyClassById(
            profileStudentState.dataModels!.myClassId.toString());
      }
    } else {
      if (widget.data != null) {
        if (widget.data?.religion != null) {
          addressState.updateDropdownReligion(widget.data!.religion!);
        }
        if (widget.data?.nationality != null) {
          addressState.updateDropDownNationality(widget.data!.nationality!);
        }
        if (widget.data?.ethnicity != null) {
          addressState.updateDropDownEthinicity(widget.data!.ethnicity!);
        }

        if (widget.data?.groupLanguage != null) {
          addressState.updateDropDownlanguageDrop(widget.data!.groupLanguage!);
        }
        if (widget.data?.specialHealth != null) {
          addressState.updateDropDownspecialHealth(widget.data!.specialHealth!);
        }
        if (widget.data?.living != null) {
          addressState.updateDropDownResidences(widget.data!.living!);
        }
        if (widget.data?.bloodGroup != null) {
          addressState.updateDropDownBloodGroup(widget.data!.bloodGroup!);
        }
        registerState.getCurrentProfile(null, widget.data, 't');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: AppBar(
        title: CustomText(
          text: 'profile',
        ),
        foregroundColor: Colors.white,
        backgroundColor: appColor.mainColor,
        centerTitle: true,
      ),
      body: GetBuilder<RegisterState>(builder: (getRes) {
        if (getRes.checkEditStudentProfile == false) {
          return Column(
            children: [Expanded(child: Center(child: CircleLoad()))],
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(fSize * 0.008),
            child: GetBuilder<ProfileStudentState>(
              builder: (get) {
                if (get.check == false && widget.type == 's') {
                  return SizedBox(
                    height: fSize * 0.5,
                    child: Center(
                      child: CircleLoad(),
                    ),
                  );
                }
                return GetBuilder<AddressState>(builder: (getAddress) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.02),
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
                                            : (widget.type == 's')
                                                ? (get.dataModels!
                                                                .imagesProfile !=
                                                            null &&
                                                        get.dataModels!
                                                                .imagesProfile !=
                                                            '')
                                                    ? NetworkImage(
                                                        "${Repository().urlApi}${get.dataModels!.imagesProfile}",
                                                      )
                                                    : AssetImage(
                                                        'assets/images/logo.png')
                                                : (widget.data?.imageStudent !=
                                                            null &&
                                                        widget.data
                                                                ?.imageStudent !=
                                                            '')
                                                    ? NetworkImage(
                                                        "${Repository().urlApi}${widget.data?.imageStudent}",
                                                      )
                                                    : AssetImage(
                                                        'assets/images/logo.png'),
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
                                  backgroundColor:
                                      pickImageState.appColor.mainColor,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: pickImageState.appColor.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: CustomText(
                            text: widget.type == 's'
                                ? '${'label_code'.tr}: ${(get.dataModels?.admissionNumber.toString() != 'null' && get.dataModels?.admissionNumber.toString() != '') ? get.dataModels?.admissionNumber : 'XXXXXX'}'
                                : '${'label_code'.tr}: ${(widget.data?.admissionNumber.toString() != 'null' && widget.data?.admissionNumber.toString() != '') ? widget.data?.admissionNumber : 'XXXXXX'}',
                            color: appColor.mainColor,
                            fontSize: fSize * 0.0165,
                            fontWeight: FontWeight.bold,
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
                                    groupValue: registerState.gender,
                                    activeColor: appColor.mainColor,
                                    onChanged: (v) => {
                                      registerState.updateGender(v.toString())
                                    },
                                  ),
                                  CustomText(
                                    text: 'male',
                                    fontSize: fSize * 0.0165,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: '1',
                                    groupValue: registerState.gender,
                                    activeColor: appColor.mainColor,
                                    onChanged: (v) => {
                                      registerState.updateGender(v.toString())
                                    },
                                  ),
                                  CustomText(
                                    text: 'female',
                                    fontSize: fSize * 0.0165,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: '3',
                                    groupValue: registerState.gender,
                                    activeColor: appColor.mainColor,
                                    onChanged: (v) => {
                                      registerState.updateGender(v.toString())
                                    },
                                  ),
                                  CustomText(
                                    text: 'other',
                                    fontSize: fSize * 0.0165,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomText(text: '*', color: appColor.red),
                            CustomText(
                              text: 'firstname',
                              fontSize: fSize * 0.0165,
                            ),
                          ],
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          hintText: 'firstname'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: getRes.firstname,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.person,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'nick_name',
                          fontSize: fSize * 0.0165,
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          hintText: 'nick_name'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.nickname,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.person,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomText(text: '*', color: appColor.red),
                            CustomText(
                              text: 'lastname',
                              fontSize: fSize * 0.0165,
                            ),
                          ],
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          hintText: 'lastname'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.lastname,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.person,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomText(text: '*', color: appColor.red),
                            CustomText(
                              text: 'birtdaydate',
                              fontSize: fSize * 0.0165,
                            ),
                          ],
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          icon: Icons.lock,
                          hintText: 'birtdaydate'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.birthdayDate,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.calendar_month,
                            size: fSize * 0.02,
                          ),
                          readOnly: true,
                          textInputType: TextInputType.text,
                          onTap: () {
                            registerState.selectDate(context);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomText(text: '*', color: appColor.red),
                            CustomText(
                              text: 'province',
                              fontSize: fSize * 0.0165,
                            ),
                          ],
                        ),
                        GetBuilder<AddressState>(builder: (getAdress) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton2<ProvinceDropdownModel>(
                              isExpanded: true,
                              hint: CustomText(
                                text: 'province',
                                fontSize: fSize * 0.016,
                                color: Theme.of(context).hintColor,
                              ),
                              items: getAdress.provinceList
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: CustomText(
                                          text: item.nameLa ?? '',
                                          fontSize: fSize * 0.016,
                                        ),
                                      ))
                                  .toList(),
                              value: getAdress.selectProvince,
                              onChanged: (value) {
                                addressState.updateDropDownProvince(value!);
                                if (value.id != null) {
                                  addressState.getDistrict(value.id!, null);
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: fSize * 0.05,
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
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: size.height * 0.06,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController:
                                    registerState.searchprovinceGroup,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller:
                                        registerState.searchprovinceGroup,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: '${'search'.tr}...',
                                      hintStyle:
                                          TextStyle(fontSize: fSize * 0.016),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  return '${item.value!.nameLa}'
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                addressState.clearDistrict();
                                addressState.clearVillage();
                              },
                            ),
                          );
                        }),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        if (addressState.districtList.isNotEmpty)
                          Column(
                            children: [
                              Row(
                                children: [
                                  CustomText(text: '*', color: appColor.red),
                                  CustomText(
                                    text: 'district',
                                    fontSize: fSize * 0.0165,
                                  ),
                                ],
                              ),
                              GetBuilder<AddressState>(builder: (getAdress) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2<DistrictDropdownModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      text: 'district',
                                      fontSize: fSize * 0.016,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    items: getAdress.districtList
                                        .map((item) => DropdownMenuItem(
                                              value: item,
                                              child: CustomText(
                                                text: item.nameLa ?? '',
                                                fontSize: fSize * 0.016,
                                              ),
                                            ))
                                        .toList(),
                                    value: getAdress.selectDistrict,
                                    onChanged: (value) {
                                      addressState
                                          .updateDropDownDistrict(value!);
                                      if (value.id != null) {
                                        addressState.getVillage(
                                            value.id!, null);
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: fSize * 0.05,
                                      decoration: BoxDecoration(
                                        color: appColor.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius:
                                                fixSize(0.0025, context),
                                            offset: const Offset(0, 1),
                                            color: appColor.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: size.height * 0.06,
                                    ),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController:
                                          registerState.searchdistrictGroup,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller:
                                              registerState.searchdistrictGroup,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: '${'search'.tr}...',
                                            hintStyle: TextStyle(
                                                fontSize: fSize * 0.016),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return '${item.value!.nameLa}'
                                            .toLowerCase()
                                            .contains(
                                                searchValue.toLowerCase());
                                      },
                                    ),
                                    onMenuStateChange: (isOpen) {
                                      addressState.clearVillage();
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        if (addressState.villageList.isNotEmpty)
                          Column(
                            children: [
                              Row(
                                children: [
                                  CustomText(text: '*', color: appColor.red),
                                  CustomText(
                                    text: 'village',
                                    fontSize: fSize * 0.0165,
                                  ),
                                ],
                              ),
                              GetBuilder<AddressState>(builder: (getAdress) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2<VillageDropdownModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      text: 'village',
                                      fontSize: fSize * 0.016,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    items: getAdress.villageList
                                        .map((item) => DropdownMenuItem(
                                              value: item,
                                              child: CustomText(
                                                text: item.nameLa ?? '',
                                                fontSize: fSize * 0.016,
                                              ),
                                            ))
                                        .toList(),
                                    value: getAdress.selectVillage,
                                    onChanged: (value) {
                                      addressState
                                          .updateDropDownVillage(value!);
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: fSize * 0.05,
                                      decoration: BoxDecoration(
                                        color: appColor.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius:
                                                fixSize(0.0025, context),
                                            offset: const Offset(0, 1),
                                            color: appColor.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: size.height * 0.06,
                                    ),
                                    dropdownSearchData: DropdownSearchData(
                                      searchController:
                                          registerState.searchvillageGroup,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller:
                                              registerState.searchvillageGroup,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: '${'search'.tr}...',
                                            hintStyle: TextStyle(
                                                fontSize: fSize * 0.016),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return '${item.value!.nameLa}'
                                            .toLowerCase()
                                            .contains(
                                                searchValue.toLowerCase());
                                      },
                                    ),
                                    onMenuStateChange: (isOpen) {},
                                  ),
                                );
                              }),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          ),
                        CustomText(
                          text: 'religion',
                          fontSize: fSize * 0.0165,
                        ),
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
                            value: getAddress.religiongroupList
                                    .firstWhereOrNull((e) =>
                                        e.id.toString() ==
                                        addressState.selectReligion?.id
                                            .toString()) ??
                                addressState.selectReligion,
                            onChanged: (value) {
                              addressState.updateDropdownReligion(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: registerState.searchReligion,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
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
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'nationality',
                          fontSize: fSize * 0.0165,
                        ),
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
                            value: getAddress.nationalityList.firstWhereOrNull(
                                    (e) =>
                                        e.id.toString() ==
                                        addressState.selectNationality?.id
                                            .toString()) ??
                                addressState.selectNationality,
                            onChanged: (value) {
                              addressState.updateDropDownNationality(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: registerState.searchNationality,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
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
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'group_language',
                          fontSize: fSize * 0.0165,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<LanguageGroupDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'group_language',
                              fontSize: fSize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAddress.languageGroupList
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
                            value: getAddress.languageGroupList
                                    .firstWhereOrNull((e) =>
                                        e.id.toString() ==
                                        addressState.selectlanguageGroup?.id
                                            .toString()) ??
                                addressState.selectlanguageGroup,
                            onChanged: (value) {
                              addressState.updateDropDownlanguageDrop(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController:
                                  registerState.searchLanguageGroup,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: registerState.searchLanguageGroup,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: '${'search'.tr}...',
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'ethnicity',
                          fontSize: fSize * 0.0165,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<EthnicGroupDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'ethnicity',
                              fontSize: fSize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAddress.ethnicityList
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
                            value: getAddress.ethnicityList.firstWhereOrNull(
                                    (e) =>
                                        e.id.toString() ==
                                        addressState.selectEthinicity?.id
                                            .toString()) ??
                                addressState.selectEthinicity,
                            onChanged: (value) {
                              addressState.updateDropDownEthinicity(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: registerState.searchEthinicity,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: registerState.searchEthinicity,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: '${'search'.tr}...',
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'special_health',
                          fontSize: fSize * 0.0165,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<SpecialHealthdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'special_health',
                              fontSize: fSize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAddress.specialHealthList
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
                            value: getAddress.specialHealthList
                                    .firstWhereOrNull((e) =>
                                        e.id.toString() ==
                                        addressState.selectspecialHealth?.id
                                            .toString()) ??
                                addressState.selectspecialHealth,
                            onChanged: (value) {
                              addressState.updateDropDownspecialHealth(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController:
                                  registerState.searchSpecialHealth,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: registerState.searchSpecialHealth,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: '${'search'.tr}...',
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'living',
                          fontSize: fSize * 0.0165,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<ResidencedownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'living',
                              fontSize: fSize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAddress.residenList
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
                            value: getAddress.residenList.firstWhereOrNull(
                                    (e) =>
                                        e.id.toString() ==
                                        addressState.selectResidense?.id
                                            .toString()) ??
                                addressState.selectResidense,
                            onChanged: (value) {
                              addressState.updateDropDownResidences(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController:
                                  registerState.searchSpecialHealth,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: registerState.searchSpecialHealth,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: '${'search'.tr}...',
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'Blood_type',
                          fontSize: fixSize(0.0146, context),
                          fontWeight: FontWeight.w600,
                        ),
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
                            value: getAddress.bloodgroupList.firstWhereOrNull(
                                    (e) =>
                                        e.id.toString() ==
                                        addressState.selectBloodGroup?.id
                                            .toString()) ??
                                addressState.selectBloodGroup,
                            onChanged: (value) {
                              addressState.updateDropDownBloodGroup(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fSize * 0.05,
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
                              maxHeight: 200,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: size.height * 0.06,
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
                                    hintStyle:
                                        TextStyle(fontSize: fSize * 0.016),
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
                                return nameLa
                                        .contains(searchValue.toLowerCase()) ||
                                    nameEn.contains(searchValue.toLowerCase());
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'personal_talent',
                          fontSize: fSize * 0.0165,
                        ),
                        TextFielWidget(
                          contentPadding: EdgeInsets.only(left: 5),
                          height: fSize * 0.05,
                          hintText: 'personal_talent'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.personalTalent,
                          borderRaduis: 5.0,
                          margin: 0,
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomText(text: '*', color: appColor.red),
                            CustomText(
                              text: 'SelectClass_group',
                              fontSize: fSize * 0.0165,
                            ),
                          ],
                        ),
                        if (addressState.classgroupList.isNotEmpty)
                          GetBuilder<AddressState>(builder: (getAdress) {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton2<ClassGroupDropdownModel>(
                                isExpanded: true,
                                hint: CustomText(
                                  text: 'SelectClass_group',
                                  fontSize: fSize * 0.016,
                                  color: Theme.of(context).hintColor,
                                ),
                                items: getAdress.classgroupList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: CustomText(
                                            text: item.name ?? '',
                                            fontSize: fSize * 0.016,
                                          ),
                                        ))
                                    .toList(),
                                value: registerState.selectclassGroup,
                                onChanged: (value) {
                                  registerState
                                      .selectclassGroupDropdown(value!);
                                  if (value.id != null) {
                                    addressState.getClassList(
                                        id: value.id!.toString(),
                                        branchId: widget.type == 's'
                                            ? profileStudentState
                                                    .dataModels?.branchId
                                                    .toString() ??
                                                '0'
                                            : widget.data?.branchId ?? '');
                                  }
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: fSize * 0.05,
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
                                dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200,
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height: size.height * 0.06,
                                ),
                                dropdownSearchData: DropdownSearchData(
                                  searchController:
                                      registerState.searchclassGroup,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller:
                                          registerState.searchclassGroup,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: '${'search'.tr}...',
                                        hintStyle:
                                            TextStyle(fontSize: fSize * 0.016),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return '${item.value!.name}'
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase());
                                  },
                                ),
                                onMenuStateChange: (isOpen) {
                                  registerState.clearDropdownClass();
                                },
                              ),
                            );
                          }),
                        if (getAddress.classList.isNotEmpty) ...[
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            children: [
                              CustomText(text: '*', color: appColor.red),
                              CustomText(
                                text: 'Select_Class',
                                fontSize: fSize * 0.0165,
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<ClassListDropdownModel>(
                              isExpanded: true,
                              hint: CustomText(
                                text: 'Select_Class',
                                fontSize: fSize * 0.016,
                                color: Theme.of(context).hintColor,
                              ),
                              items: getAddress.classList
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: CustomText(
                                          text: item.name ?? '',
                                          fontSize: fSize * 0.016,
                                        ),
                                      ))
                                  .toList(),
                              value: registerState.selectClass,
                              onChanged: (value) {
                                registerState.selectclassDropdown(value!);
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: fSize * 0.05,
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
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: size.height * 0.06,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController:
                                    registerState.searchclassGroup,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: registerState.searchclassGroup,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: '${'search'.tr}...',
                                      hintStyle:
                                          TextStyle(fontSize: fSize * 0.016),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  return '${item.value!.name}'
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  // textEditingController.clear();
                                }
                              },
                            ),
                          ),
                        ],
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'phone',
                          fontSize: fSize * 0.0165,
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          icon: Icons.lock,
                          hintText: "phone",
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.phone,
                          readOnly: true,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.phone,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'password',
                          fontSize: fSize * 0.0165,
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          icon: Icons.lock,
                          hintText: 'password'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.password,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.lock,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.visiblePassword,
                          obscureText: obscureTextPasseord,
                          iconSuffix: IconButton(
                            icon: Icon(
                              obscureTextPasseord
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (obscureTextPasseord) {
                                  obscureTextPasseord = false;
                                } else {
                                  obscureTextPasseord = true;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomText(
                          text: 'confirm_password',
                          fontSize: fSize * 0.0165,
                        ),
                        TextFielWidget(
                          width: size.width,
                          height: fSize * 0.05,
                          icon: Icons.lock,
                          hintText: 'confirm_password'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.confirmPassword,
                          borderRaduis: 5.0,
                          margin: 0,
                          iconPrefix: Icon(
                            Icons.lock,
                            size: fSize * 0.02,
                          ),
                          textInputType: TextInputType.visiblePassword,
                          obscureText: obscureTextPasseord,
                          iconSuffix: IconButton(
                            icon: Icon(
                              obscureTextPasseord
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (obscureTextPasseord) {
                                  obscureTextPasseord = false;
                                } else {
                                  obscureTextPasseord = true;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                  height: fSize * 0.05,
                                  color: appColor.white,
                                  // ignore: deprecated_member_use
                                  backgroundColor: appColor.grey,
                                  fontSize: fSize * 0.0185,
                                  fontWeight: FontWeight.bold,
                                  borderRadius: 50,
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  text: 'cancel'),
                            ),
                            SizedBox(
                              width: size.width * 0.2,
                            ),
                            Expanded(
                              child: ButtonWidget(
                                  height: fSize * 0.05,
                                  color: appColor.white,
                                  // ignore: deprecated_member_use
                                  backgroundColor: appColor.mainColor,
                                  fontSize: fSize * 0.0185,
                                  fontWeight: FontWeight.bold,
                                  borderRadius: 50,
                                  onPressed: () async {
                                    if (registerState.firstname.text
                                            .trim()
                                            .isEmpty ||
                                        registerState.lastname.text
                                            .trim()
                                            .isEmpty ||
                                        registerState.birthdayDate.text
                                            .trim()
                                            .isEmpty) {
                                      CustomDialogs().showToast(
                                          // ignore: deprecated_member_use
                                          backgroundColor:
                                              appColor.red.withOpacity(0.8),
                                          text:
                                              'please_enter_complete_information'
                                                  .tr);
                                      return;
                                    }
                                    if (registerState
                                        .password.text.isNotEmpty) {
                                      if (registerState.password.text !=
                                          registerState.confirmPassword.text) {
                                        CustomDialogs().showToast(
                                            // ignore: deprecated_member_use
                                            backgroundColor:
                                                appColor.red.withOpacity(0.8),
                                            text: 'password_not_match'.tr);
                                        return;
                                      }
                                    }
                                    registerState.updateStudentProfile(
                                      context: context,
                                      type: widget.type,
                                      id: widget.type == 't'
                                          ? (widget.data!.userId != null
                                              ? widget.data!.userId.toString()
                                              : '0')
                                          : (profileStudentState.dataModels?.id
                                                  .toString() ??
                                              '0'),
                                      gender: registerState.gender,
                                      fileImage: pickImageState.file,
                                      nickname: registerState.nickname.text,
                                      firstname: registerState.firstname.text,
                                      lastname: registerState.lastname.text,
                                      birthdayDate:
                                          registerState.birthdayDate.text,
                                      phone: registerState.phone.text,
                                      password: registerState.password.text,
                                      myClassid: registerState.selectClass?.id
                                          .toString(),
                                      villId: addressState.selectVillage?.id
                                          .toString(),
                                      disId: addressState.selectDistrict?.id
                                          .toString(),
                                      proId: addressState.selectProvince?.id
                                          .toString(),
                                      parentData: registerState.parentData.text,
                                      parentContact:
                                          registerState.parentContact.text,
                                      personalTalent:
                                          registerState.personalTalent.text,
                                      groupLanguage: addressState
                                              .selectlanguageGroup?.id
                                              .toString() ??
                                          '',
                                      religion: addressState.selectReligion?.id
                                              .toString() ??
                                          '',
                                      email: registerState.email.text,
                                      nationality: addressState
                                              .selectNationality?.id
                                              .toString() ??
                                          '',
                                      spacialHealthy: addressState
                                              .selectspecialHealth?.id
                                              .toString() ??
                                          '',
                                      living: addressState.selectResidense?.id
                                              .toString() ??
                                          '',
                                      ethnicity: addressState
                                              .selectEthinicity?.id
                                              .toString() ??
                                          '',
                                      bloodGroup: addressState
                                              .selectBloodGroup?.id
                                              .toString() ??
                                          '',
                                    );
                                  },
                                  text: 'edit'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                      ]);
                });
              },
            ),
          ),
        );
      }),
    );
  }
}
