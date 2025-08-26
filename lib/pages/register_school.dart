import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/models/package_model.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/models/select_dropdown_model.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/follow_student_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterSchool extends StatefulWidget {
  const RegisterSchool({super.key, this.data, this.packageId});
  final PackageModel? data;
  final String? packageId;
  @override
  State<RegisterSchool> createState() => _RegisterSchoolState();
}

class _RegisterSchoolState extends State<RegisterSchool> {
  // AuthState authState = Get.put(AuthState());
  // LocaleState localeState = Get.put(LocaleState());
  AddressState addressState = Get.put(AddressState());
  AppColor appColors = AppColor();
  FollowStudentState followStudentState = Get.put(FollowStudentState());
  RegisterState registerState = Get.put(RegisterState());
  StudentRecordDropdownModel? selectedValue;
  bool obscureText = true;
  bool obscureTextPasseord = true;
  @override
  void initState() {
    addressState.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fsize = size.width + size.height;
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: appColors.mainColor,
        elevation: 4,
        title: CustomText(
          text: widget.packageId != '' ? 'register' : widget.data?.name ?? '',
          color: appColors.white,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: appColors.white,
          ),
        ),
      ),
      body: GetBuilder<RegisterState>(builder: (getRes) {
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
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: '${'school_name'.tr}(${'lao'.tr})',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    hintText: '${'school_name'.tr}(${'lao'.tr})',
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.nameLa,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.school,
                      size: fsize * 0.02,
                    ),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: '${'school_name'.tr}(${'english'.tr})',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    hintText: '${'school_name'.tr}(${'english'.tr})',
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.nameEn,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.school,
                      size: fsize * 0.02,
                    ),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: 'School_owner',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    hintText: 'School_owner'.tr,
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.firstname,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.person,
                      size: fsize * 0.02,
                    ),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomText(
                    text: 'lastname',
                    fontSize: fsize * 0.0165,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    hintText: 'lastname'.tr,
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.lastname,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.person,
                      size: fsize * 0.02,
                    ),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: 'phone',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  Row(
                          children: [
                            Container(
                              height: fsize * 0.05,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: appColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: fsize * 0.0025,
                                        offset: const Offset(0, 1),
                                        color: appColors.grey)
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo_lao.png',
                                    width: size.width * 0.1,
                                  ),
                                  CustomText(text: '+85620', fontSize: fsize*0.0165),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFielWidget(
                                height: fsize * 0.05,
                                icon: Icons.person,
                                hintText: 'XXXXXXXX'.tr,
                                fixSize: fsize,
                                appColor: appColors,
                                controller: registerState.phone,
                                borderRaduis: 5.0,
                                maxLength: 8,
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
                  CustomText(
                    text: 'email',
                    fontSize: fsize * 0.0165,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    icon: Icons.lock,
                    hintText: 'email'.tr,
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.password,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.email,
                      size: fsize * 0.02,
                    ),
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: 'province',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<ProvinceDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'province',
                        fontSize: fsize * 0.016,
                        color: Theme.of(context).hintColor,
                      ),
                      items: getAdress.provinceList
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: CustomText(
                                  text: item.nameLa ?? '',
                                  fontSize: fsize * 0.016,
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
                        height: fsize * 0.05,
                        decoration: BoxDecoration(
                          color: appColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: fixSize(0.0025, context),
                              offset: const Offset(0, 1),
                              color: appColors.grey,
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
                              hintStyle: TextStyle(fontSize: fsize * 0.016),
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
                            CustomText(text: '*', color: appColors.red),
                            CustomText(
                              text: 'district',
                              fontSize: fsize * 0.0165,
                            ),
                          ],
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<DistrictDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'district',
                              fontSize: fsize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAdress.districtList
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: CustomText(
                                        text: item.nameLa ?? '',
                                        fontSize: fsize * 0.016,
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
                              height: fsize * 0.05,
                              decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: fixSize(0.0025, context),
                                    offset: const Offset(0, 1),
                                    color: appColors.grey,
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
                                        TextStyle(fontSize: fsize * 0.016),
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
                            CustomText(text: '*', color: appColors.red),
                            CustomText(
                              text: 'village',
                              fontSize: fsize * 0.0165,
                            ),
                          ],
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<VillageDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'village',
                              fontSize: fsize * 0.016,
                              color: Theme.of(context).hintColor,
                            ),
                            items: getAdress.villageList
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: CustomText(
                                        text: item.nameLa ?? '',
                                        fontSize: fsize * 0.016,
                                      ),
                                    ))
                                .toList(),
                            value: addressState.selectVillage,
                            onChanged: (value) {
                              addressState.updateDropDownVillage(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: fsize * 0.05,
                              decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: fixSize(0.0025, context),
                                    offset: const Offset(0, 1),
                                    color: appColors.grey,
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
                                        TextStyle(fontSize: fsize * 0.016),
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
                  Row(
                    children: [
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: 'password',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    icon: Icons.lock,
                    hintText: 'password'.tr,
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.password,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.lock,
                      size: fsize * 0.02,
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
                      CustomText(text: '*', color: appColors.red),
                      CustomText(
                        text: 'confirm_password',
                        fontSize: fsize * 0.0165,
                      ),
                    ],
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fsize * 0.05,
                    icon: Icons.lock,
                    hintText: 'confirm_password'.tr,
                    fixSize: fsize,
                    appColor: appColors,
                    controller: registerState.confirmPassword,
                    borderRaduis: 5.0,
                    margin: 0,
                    iconPrefix: Icon(
                      Icons.lock,
                      size: fsize * 0.02,
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
                      height: fsize * 0.05,
                      width: fsize * 0.5,
                      color: appColors.white,
                      // ignore: deprecated_member_use
                      backgroundColor: appColors.mainColor.withOpacity(0.8),
                      fontSize: fsize * 0.0185,
                      fontWeight: FontWeight.bold,
                      borderRadius: 5,
                      onPressed: () async {
                        if (registerState.nameLa.text.trim().isEmpty ||
                            registerState.nameEn.text.trim().isEmpty ||
                            registerState.firstname.text.trim().isEmpty ||
                            registerState.phone.text.trim().isEmpty ||
                            registerState.password.text.trim().isEmpty ||
                            registerState.confirmPassword.text.trim().isEmpty ||
                            addressState.selectVillage == null ||
                            addressState.selectDistrict == null ||
                            addressState.selectProvince == null) {
                          CustomDialogs().showToast(
                              // ignore: deprecated_member_use
                              backgroundColor: appColors.black.withOpacity(0.6),
                              text: 'please_enter_complete_information'.tr);
                          return;
                        }
                        if (registerState.password.text !=
                            registerState.confirmPassword.text) {
                          CustomDialogs().showToast(
                              // ignore: deprecated_member_use
                              backgroundColor: appColors.red.withOpacity(0.8),
                              text: 'password_not_match'.tr);
                          return;
                        }
                        registerState.registerSchool(
                          context: context,
                                   id: widget.packageId !=null ? widget.packageId.toString() : widget.data !=null ? widget.data!.id.toString() : '0',
                          nameLa: registerState.nameLa.text,
                          nameEn: registerState.nameEn.text,
                          firstname: registerState.firstname.text,
                          phone: '20${registerState.phone.text}',
                          password: registerState.password.text,
                          villId: addressState.selectVillage!.id.toString(),
                          disId: addressState.selectDistrict!.id.toString(),
                          proId: addressState.selectProvince!.id.toString(),
                        );
                      },
                      text: 'register'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {
                        Get.offAll(() => LoginPage(),
                            transition: Transition.downToUp)
                      },
                      child: CustomText(
                        text: 'login',
                        fontSize: fsize * 0.0145,
                        color: appColors.mainColor,
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
