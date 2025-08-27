import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/models/select_dropdown_model.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/follow_student_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.data});
  final SchoolListModel data;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // AuthState authState = Get.put(AuthState());
  // LocaleState localeState = Get.put(LocaleState());
  AddressState addressState = Get.put(AddressState());
  AppColor appColor = AppColor();
  FollowStudentState followStudentState = Get.put(FollowStudentState());
  RegisterState registerState = Get.put(RegisterState());
  PickImageState pickImageState = Get.put(PickImageState());
  StudentRecordDropdownModel? selectedValue;
  bool obscureText = true;
  bool obscureTextPasseord = true;
  @override
  void initState() {
    super.initState();
    addressState.clearData();
    getData();
  }

  getData() {
    addressState.getclassGroup(int.parse(widget.data.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: appColor.white.withOpacity(0.5),
        // ignore: deprecated_member_use
        surfaceTintColor: appColor.white.withOpacity(0.5),
        elevation: 4,
        title: CustomText(
          text: widget.data.nameLa ?? '',
          color: appColor.mainColor,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: appColor.mainColor,
          ),
        ),
      ),
      body: GetBuilder<RegisterState>(builder: (getRes) {
        int appleSetting = getRes.schoolList.first.appleSetting ?? 0;
        return GetBuilder<AddressState>(builder: (getAdress) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.02,
                right: size.width * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<PickImageState>(builder: (getFile) {
                    return Center(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          pickImageState.showPickImage(context);
                        },
                        child: Container(
                          width: size.width * 0.5,
                          height: size.width *
                              0.5, // Ensure it's a square for a perfect circle
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 5, color: appColor.mainColor),
                            image: DecorationImage(
                              image: (getFile.file != null &&
                                      getFile.file!.path.isNotEmpty)
                                  ? FileImage(File(getFile.file!.path))
                                      as ImageProvider
                                  : const AssetImage(
                                      'assets/images/istockphoto-587805078-612x612.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
                              onChanged: (v) =>
                                  {registerState.updateGender(v.toString())},
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
                              onChanged: (v) =>
                                  {registerState.updateGender(v.toString())},
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
                              onChanged: (v) =>
                                  {registerState.updateGender(v.toString())},
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
                    controller: registerState.firstname,
                    borderRaduis: 5.0,
                    margin: 0,
                    fontSize: fixSize(0.0146, context),
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
                    fontSize: fixSize(0.0146, context),
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
                    fontSize: fixSize(0.0146, context),
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
                  CustomText(
                    text: 'birtdaydate',
                    fontSize: fSize * 0.0165,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fSize * 0.05,
                    icon: Icons.lock,
                    hintText: 'birtdaydate'.tr,
                    fontSize: fixSize(0.0146, context),
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
                                  controller: registerState.searchdistrictGroup,
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
                                  controller: registerState.searchvillageGroup,
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
                      value: addressState.selectReligion,
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
                          return nameLa.contains(searchValue.toLowerCase()) ||
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
                      items: getAdress.nationalityList
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
                      value: addressState.selectNationality,
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
                      items: getAdress.languageGroupList
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
                      value: addressState.selectlanguageGroup,
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
                        searchController: registerState.searchLanguageGroup,
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
                      items: getAdress.ethnicityList
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
                      value: addressState.selectEthinicity,
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
                      items: getAdress.specialHealthList
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
                      value: addressState.selectspecialHealth,
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
                        searchController: registerState.searchSpecialHealth,
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
                  if (appleSetting == 0) ...[
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
                        items: getAdress.residenList
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
                        value: addressState.selectResidense,
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
                          searchController: registerState.searchSpecialHealth,
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
                    )
                  ],
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomText(
                    text: 'Blood_type',
                    fontSize: fixSize(0.0146, context),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<BloodGroupDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'Blood_type',
                        fontSize: fSize * 0.016,
                        color: Theme.of(context).hintColor,
                      ),
                      items: getAdress.bloodgroupList
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
                      value: addressState.selectBloodGroup,
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
                  CustomText(
                    text: 'personal_talent',
                    fontSize: fixSize(0.0146, context),
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
                    fontSize: fixSize(0.0146, context),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (appleSetting == 0) ...[
                    CustomText(
                      text: 'SelectClass_group',
                      fontSize: fSize * 0.0165,
                    ),
                    DropdownButtonHideUnderline(
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
                          registerState.selectclassGroupDropdown(value!);
                          if (value.id != null) {
                            addressState.getClassList(
                                id: value.id!.toString(),
                                branchId: widget.data.id.toString());
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
                          searchController: registerState.searchclassGroup,
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
                            return '${item.value!.name}'
                                .toLowerCase()
                                .contains(searchValue.toLowerCase());
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          registerState.clearDropdownClass();
                        },
                      ),
                    ),
                    if (getAdress.classList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          CustomText(
                            text: 'Select_Class',
                            fontSize: fSize * 0.0165,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<ClassListDropdownModel>(
                              isExpanded: true,
                              hint: CustomText(
                                text: 'Select_Class',
                                fontSize: fSize * 0.016,
                                color: Theme.of(context).hintColor,
                              ),
                              items: getAdress.classList
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
                      ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomText(
                      text: '${'phone'.tr}(${'student'.tr})',
                      fontSize: fSize * 0.0165,
                    ),
                    Row(
                      children: [
                        Container(
                          height: fSize * 0.05,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: appColor.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: fSize * 0.0025,
                                    offset: const Offset(0, 1),
                                    color: appColor.grey)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo_lao.png',
                                width: size.width * 0.1,
                              ),
                              CustomText(
                                  text: '+85620', fontSize: fSize * 0.0165),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextFielWidget(
                            height: fSize * 0.05,
                            icon: Icons.person,
                            hintText: 'XXXXXXXX'.tr,
                            fixSize: fSize,
                            appColor: appColor,
                            controller: registerState.phone,
                            borderRaduis: 5.0,
                            maxLength: 8,
                            margin: 0,
                            fontSize: fSize * 0.0165,
                            contentPadding: EdgeInsets.only(left: 5),
                            textInputType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (appleSetting == 0) ...[
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomText(
                      text: 'parent',
                      fontSize: fSize * 0.0165,
                    ),
                    TextFielWidget(
                      contentPadding: EdgeInsets.only(left: 5),
                      height: fSize * 0.05,
                      hintText: 'parent'.tr,
                      fixSize: fSize,
                      appColor: appColor,
                      controller: registerState.parentData,
                      borderRaduis: 5.0,
                      margin: 0,
                      fontSize: fixSize(0.0146, context),
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    )
                  ],
                  Row(
                    children: [
                      if(appleSetting == 0)
                      CustomText(text: '*', color: appColor.red),
                      CustomText(
                        text: appleSetting == 1
                            ? 'phone'
                            : '${'phone'.tr}(${'parent'.tr})',
                        fontSize: fSize * 0.0165,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: fSize * 0.05,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: appColor.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: fSize * 0.0025,
                                  offset: const Offset(0, 1),
                                  color: appColor.grey)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo_lao.png',
                              width: size.width * 0.1,
                            ),
                            CustomText(
                                text: '+85620', fontSize: fSize * 0.0165),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextFielWidget(
                          height: fSize * 0.05,
                          icon: Icons.person,
                          hintText: 'XXXXXXXX'.tr,
                          fixSize: fSize,
                          appColor: appColor,
                          controller: registerState.parentContact,
                          borderRaduis: 5.0,
                          maxLength: 8,
                          fontSize: fixSize(0.0146, context),
                          margin: 0,
                          contentPadding: EdgeInsets.only(left: 5),
                          textInputType: TextInputType.phone,
                        ),
                      ),
                    ],
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
                    fontSize: fixSize(0.0146, context),
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
                    fontSize: fixSize(0.0146, context),
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
                  ButtonWidget(
                      height: fSize * 0.05,
                      width: fSize * 0.5,
                      color: appColor.white,
                      // ignore: deprecated_member_use
                      backgroundColor: appColor.mainColor.withOpacity(0.8),
                      fontSize: fSize * 0.0185,
                      fontWeight: FontWeight.bold,
                      borderRadius: 5,
                      onPressed: () async {
                        if (registerState.firstname.text.trim().isEmpty ||
                            registerState.lastname.text.trim().isEmpty ||
                            registerState.parentContact.text.trim().isEmpty ||
                            registerState.password.text.trim().isEmpty ||
                            addressState.selectProvince == null ||
                            addressState.selectDistrict == null ||
                            addressState.selectVillage == null) {
                          CustomDialogs().showToast(
                            // ignore: deprecated_member_use
                              backgroundColor: appColor.red.withOpacity(0.8),
                              text: 'please_enter_complete_information'.tr);
                          return;
                        }
                        if (registerState.password.text !=
                            registerState.confirmPassword.text) {
                          CustomDialogs().showToast(
                            // ignore: deprecated_member_use
                              backgroundColor: appColor.red.withOpacity(0.8),
                              text: 'password_not_match'.tr);
                          return;
                        }
                        registerState.registerStudent(
                            context: context,
                            gender: registerState.gender,
                            fileImage: pickImageState.file,
                            nickname: registerState.nickname.text,
                            firstname: registerState.firstname.text,
                            lastname: registerState.lastname.text,
                            branchId: widget.data.id.toString(),
                            birthdayDate: registerState.birthdayDate.text,
                            phone: registerState.phone.text != ''
                                ? '20${registerState.phone.text}'
                                : '',
                            password: registerState.password.text,
                            myClassid: registerState.selectClass != null
                                ? registerState.selectClass!.id.toString()
                                : '',
                            villId: addressState.selectVillage!.id.toString(),
                            disId: addressState.selectDistrict!.id.toString(),
                            proId: addressState.selectProvince!.id.toString(),
                            parentData: registerState.parentData.text,
                            parentContact:
                            '20${registerState.parentContact.text}',
                            personalTalent: registerState.personalTalent.text,
                            groupLanguage: addressState.selectlanguageGroup?.id
                                .toString() ??
                                '',
                            religion:
                            addressState.selectReligion?.id.toString() ??
                                '',
                            email: registerState.email.text,
                            nationality:
                            addressState.selectNationality?.id.toString() ??
                                '',
                            spacialHealthy: addressState.selectspecialHealth?.id
                                .toString() ??
                                '',
                            living:
                            addressState.selectResidense?.id.toString() ??
                                '',
                            ethnicity:
                            addressState.selectEthinicity?.id.toString() ??
                                '',
                            bloodgroupId:
                            addressState.selectBloodGroup?.id.toString() ??
                                '',
                            appleSetting: appleSetting.toString());
                      },
                      text: 'register'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => {
                      Get.offAll(() => LoginPage(),
                          transition: Transition.downToUp)
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        text: 'login',
                        fontSize: fSize * 0.0145,
                        color: appColor.mainColor,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
