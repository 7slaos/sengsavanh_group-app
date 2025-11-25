import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/models/province_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/states/address_state.dart';
import 'package:multiple_school_app/states/profile_state.dart';
import 'package:multiple_school_app/states/register_state.dart';
import 'package:multiple_school_app/states/update_images_profile_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import '../../widgets/text_field_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileState profileState = Get.put(ProfileState());
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
    if (profileState.profiledModels != null) {
      if (profileState.profiledModels?.religion != null) {
        addressState
            .updateDropdownReligion(profileState.profiledModels!.religion!);
      }
      if (profileState.profiledModels?.job != null) {
        addressState.updateDropDownJob(profileState.profiledModels!.job!);
      }
      await registerState.getCurrentProfileParent(profileState.profiledModels!);
      Future.delayed(Duration(seconds: 10));
      await addressState
          .getDistrictById(profileState.profiledModels!.disId.toString());
      await addressState
          .getVillageById(profileState.profiledModels!.villId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      body: GetBuilder<RegisterState>(builder: (getRes) {
        return GetBuilder<AddressState>(builder: (getAdress) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(fSize * 0.008),
              child: GetBuilder<ProfileState>(
                builder: (get) {
                  if (get.check == false) {
                    return SizedBox(
                      height: fSize * 0.5,
                      child: Center(
                        child: CircleLoad(),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.05),
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
                                          : (get.profiledModels!.profileImage !=
                                                      null &&
                                                  get.profiledModels!
                                                          .profileImage !=
                                                      '')
                                              ? CachedNetworkImageProvider(
                                                  "${Repository().nuXtJsUrlApi}${get.profiledModels!.profileImage}",
                                                  errorListener: (p0) => {
                                                    Image.asset(
                                                        'assets/images/logo.png')
                                                  },
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
                                CustomText(text: 'male')
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
                                CustomText(text: 'female')
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
                                CustomText(text: 'other')
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
                      DropdownButtonHideUnderline(
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
                          value: addressState.selectProvince,
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
                            searchController: registerState.searchprovinceGroup,
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
                      ),
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
                            DropdownButtonHideUnderline(
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
                                value: addressState.selectDistrict,
                                onChanged: (value) {
                                  addressState.updateDropDownDistrict(value!);
                                  if (value.id != null) {
                                    addressState.getVillage(value.id!, null);
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
                                    return '${item.value!.nameLa}'
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase());
                                  },
                                ),
                                onMenuStateChange: (isOpen) {
                                  addressState.clearVillage();
                                },
                              ),
                            ),
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
                            DropdownButtonHideUnderline(
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
                                value: addressState.selectVillage,
                                onChanged: (value) {
                                  addressState.updateDropDownVillage(value!);
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
                                    return '${item.value!.nameLa}'
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase());
                                  },
                                ),
                                onMenuStateChange: (isOpen) {},
                              ),
                            ),
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
                          items: getAdress.religiongroupList
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
                          value: getAdress.religiongroupList.firstWhereOrNull(
                                  (e) =>
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
                        text: 'job',
                        fontSize: fSize * 0.0165,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<JobDropdownModel>(
                          isExpanded: true,
                          hint: CustomText(
                            text: 'job',
                            fontSize: fSize * 0.016,
                            color: Theme.of(context).hintColor,
                          ),
                          items: getAdress.jobList
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
                          value: getAdress.jobList.firstWhereOrNull((e) =>
                                  e.id.toString() ==
                                  addressState.selectJob?.id.toString()) ??
                              addressState.selectJob,
                          onChanged: (value) {
                            addressState.updateDropDownJob(value!);
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
                            searchController: registerState.searchJob,
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
                                controller: registerState.searchJob,
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
                        text: 'job_address',
                        fontSize: fSize * 0.0165,
                      ),
                      TextFielWidget(
                        height: fSize * 0.05,
                        hintText: 'job_address'.tr,
                        contentPadding: EdgeInsets.only(left: 5),
                        fixSize: fSize,
                        appColor: appColor,
                        controller: registerState.jobAddress,
                        borderRaduis: 5.0,
                        margin: 0,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'job_position',
                        fontSize: fSize * 0.0165,
                      ),
                      TextFielWidget(
                        height: fSize * 0.05,
                        hintText: 'job_position'.tr,
                        contentPadding: EdgeInsets.only(left: 5),
                        fixSize: fSize,
                        appColor: appColor,
                        controller: registerState.jobPosition,
                        borderRaduis: 5.0,
                        margin: 0,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'car_number',
                        fontSize: fSize * 0.0165,
                      ),
                      TextFielWidget(
                        height: fSize * 0.05,
                        hintText: 'car_number'.tr,
                        contentPadding: EdgeInsets.only(left: 5),
                        fixSize: fSize,
                        appColor: appColor,
                        controller: registerState.carNumber,
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
                            text: 'phone',
                            fontSize: fSize * 0.0165,
                          ),
                        ],
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
                      Row(
                        children: [
                          CustomText(text: '*', color: appColor.red),
                          CustomText(
                            text: 'password',
                            fontSize: fSize * 0.0165,
                          ),
                        ],
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
                      Row(
                        children: [
                          CustomText(text: '*', color: appColor.red),
                          CustomText(
                            text: 'confirm_password',
                            fontSize: fSize * 0.0165,
                          ),
                        ],
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
                                  if (registerState.password.text.isNotEmpty) {
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
                                  profileState.updateProfiled(
                                      context: context,
                                      gender: registerState.gender,
                                      imageFile: pickImageState.file,
                                      nickname: registerState.nickname.text,
                                      firstname: registerState.firstname.text,
                                      lastname: registerState.lastname.text,
                                      birthdayDate:
                                          registerState.birthdayDate.text,
                                      password: registerState.password.text,
                                      villId: addressState.selectVillage!.id
                                          .toString(),
                                      disId: addressState.selectDistrict!.id
                                          .toString(),
                                      proId: addressState.selectProvince!.id
                                          .toString(),
                                      religion: addressState.selectReligion?.id.toString() ?? '',
                                      email: registerState.email.text,
                                      job: addressState.selectJob?.id.toString() ?? '',
                                      jobAddress: registerState.jobAddress.text,
                                      jobPosition:
                                          registerState.jobPosition.text,
                                      carNumber: registerState.carNumber.text);
                                },
                                text: 'edit'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
      }),
    );
  }
}
