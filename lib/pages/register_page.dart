import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/models/province_model.dart';
import 'package:multiple_school_app/models/select_dropdown_model.dart';
import 'package:multiple_school_app/pages/login_page.dart';
import 'package:multiple_school_app/states/address_state.dart';
import 'package:multiple_school_app/states/follow_student_state.dart';
import 'package:multiple_school_app/states/register_state.dart';
import 'package:multiple_school_app/states/update_images_profile_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/widgets/text_field_widget.dart';
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
  Map<String, String> _fieldErrors = {};
  @override
  void initState() {
    super.initState();
    addressState.clearData();
    getData();
  }

  getData() {
    addressState.getclassGroup(int.parse(widget.data.id.toString()));
  }

  Widget _errorText(BuildContext context, String key) {
    final msg = _fieldErrors[key];
    if (msg == null || msg.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: CustomText(
        text: msg,
        color: appColor.red,
        fontSize: fixSize(0.013, context),
      ),
    );
  }

  bool _validateForm(int appleSetting) {
    final errors = <String, String>{};

    if (registerState.firstname.text.trim().isEmpty) {
      errors['firstname'] = 'ກະລຸນາປ້ອນຊື່';
    }
    if (registerState.lastname.text.trim().isEmpty) {
      errors['lastname'] = 'ກະລຸນາປ້ອນນາມສະກຸນ';
    }
    if (registerState.parentData.text.trim().isEmpty) {
      errors['parentData'] = 'ກະລຸນາປ້ອນຊື່ຜູ້ປົກຄອງ';
    }
    if (registerState.parentContact.text.trim().isEmpty) {
      errors['parentContact'] = 'ກະລຸນາປ້ອນເບີໂທ';
    } else if (registerState.parentContact.text.trim().length < 8) {
      errors['parentContact'] = 'ເບີໂທ 8 ໂຕເລກ';
    }
    if (registerState.password.text.trim().isEmpty) {
      errors['password'] = 'ກະລຸນາຕັ້ງລະຫັດ';
    }
    if (registerState.confirmPassword.text.trim().isEmpty) {
      errors['confirmPassword'] = 'ກະລຸນາຢືນຢັນລະຫັດ';
    } else if (registerState.password.text !=
        registerState.confirmPassword.text) {
      errors['confirmPassword'] = 'ລະຫັດບໍ່ກົງກັນ';
    }
    if (appleSetting == 0) {
      if (registerState.selectclassGroup == null) {
        errors['classGroup'] = 'ເລືອກລະດັບຊັ້ນ';
      }
      if (registerState.selectClass == null) {
        errors['class'] = 'ເລືອກຫ້ອງຮຽນ';
      }
    }

    setState(() {
      _fieldErrors = errors;
    });
    return errors.isEmpty;
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
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              registerState.updateGender('2');
                              setState(() {});
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                color: registerState.gender == '2'
                                    ? appColor.mainColor.withOpacity(0.12)
                                    : appColor.white,
                                border: Border.all(
                                  color: registerState.gender == '2'
                                      ? appColor.mainColor
                                      : appColor.grey,
                                  width: 1.4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColor.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: registerState.gender == '2'
                                        ? appColor.mainColor
                                        : appColor.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text: 'male',
                                    color: registerState.gender == '2'
                                        ? appColor.mainColor
                                        : appColor.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              registerState.updateGender('1');
                              setState(() {});
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                color: registerState.gender == '1'
                                    ? appColor.mainColor.withOpacity(0.12)
                                    : appColor.white,
                                border: Border.all(
                                  color: registerState.gender == '1'
                                      ? appColor.mainColor
                                      : appColor.grey,
                                  width: 1.4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColor.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.female,
                                    color: registerState.gender == '1'
                                        ? appColor.mainColor
                                        : appColor.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text: 'female',
                                    color: registerState.gender == '1'
                                        ? appColor.mainColor
                                        : appColor.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fSize * 0.05,
                    hintText: 'ຊື່ແທ້ນັກຮຽນ',
                    fixSize: fSize,
                    appColor: appColor,
                    controller: registerState.firstname,
                    borderRaduis: 5.0,
                    margin: 0,
                    fontSize: fixSize(0.0146, context),
                    iconPrefix: (registerState.gender == '1' ||
                            registerState.gender == '2')
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomText(
                              text: registerState.gender == '1'
                                  ? 'ນາງ'
                                  : 'ທ້າວ',
                              color: appColor.mainColor,
                              fontSize: fixSize(0.0146, context),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                    textInputType: TextInputType.text,
                  ),
                  _errorText(context, 'firstname'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fSize * 0.05,
                    hintText: 'ນາມສະກຸນນັກຮຽນ',
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
                  _errorText(context, 'lastname'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFielWidget(
                    width: size.width,
                    height: fSize * 0.05,
                    hintText: 'ຊື່ຫຼິ້ນນັກຮຽນ',
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
                  TextFielWidget(
                    width: size.width,
                    height: fSize * 0.05,
                    icon: Icons.lock,
                    hintText: 'ວັນ/ເດືອນ/ປີ ເກີດນັກຮຽນ',
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
                  _errorText(context, 'province'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<ProvinceDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'ເລຶອກແຂວງ',
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
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<DistrictDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'ເລືອກເມືອງ',
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
                  _errorText(context, 'district'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (addressState.villageList.isNotEmpty)
                    Column(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<VillageDropdownModel>(
                            isExpanded: true,
                            hint: CustomText(
                              text: 'ເລືອກບ້ານ',
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
                  // Hidden optional fields per request.
                  if (false) ...[
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
                      height: size.height * 0.015,
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
                  ],
                  // Hidden: residence field not used
                  if (false) ...[
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
                    ),
                  ],
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (false) ...[
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
                    TextFielWidget(
                      contentPadding: EdgeInsets.only(left: 5),
                      height: fSize * 0.05,
                      hintText: 'ຄວາມສາມາດພິເສດ ຫຼື ຄວາມສົນໃຈຂອງນັກຮຽນ',
                      fixSize: fSize,
                      appColor: appColor,
                      controller: registerState.personalTalent,
                      borderRaduis: 5.0,
                      margin: 0,
                      fontSize: fixSize(0.0146, context),
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                  ],
                  // if (appleSetting == 0) ...[
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
                    _errorText(context, 'classGroup'),
                    if (getAdress.classList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
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
                          _errorText(context, 'class'),
                        ],
                      ),
                  _errorText(context, 'village'),
                  SizedBox(
                    height: size.height * 0.02,
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
                            hintText: 'ເບີໂທ 8 ໂຕເລກ',
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
                  // ],
                  // if (appleSetting == 0) ...[
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: appColor.mainColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'ຂໍ້ມູນຜູ້ປົກຄອງເຂົ້າສູ່ລະບົບ',
                          color: appColor.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFielWidget(
                      contentPadding: EdgeInsets.only(left: 5),
                      height: fSize * 0.05,
                      hintText: 'ຊື່ຜູ້ປົກຄອງ',
                      fixSize: fSize,
                    appColor: appColor,
                    controller: registerState.parentData,
                    borderRaduis: 5.0,
                    margin: 0,
                    fontSize: fixSize(0.0146, context),
                    textInputType: TextInputType.text,
                  ),
                    _errorText(context, 'parentData'),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  // ],
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
                          hintText: 'ເບີໂທ 8 ໂຕເລກ',
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
                  _errorText(context, 'parentContact'),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFielWidget(
                                width: size.width,
                              height: fSize * 0.05,
                              icon: Icons.lock,
                              hintText: 'ລະຫັດຜ່ານເຂົ້າໃຊ້',
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
                                    obscureTextPasseord =
                                        !obscureTextPasseord;
                                  });
                                },
                                ),
                              ),
                              _errorText(context, 'password'),
                            ],
                          ),
                        ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFielWidget(
                                width: size.width,
                              height: fSize * 0.05,
                              icon: Icons.lock,
                              hintText: 'ຢືນຢັນລະຫັດຜ່ານ',
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
                                    obscureTextPasseord =
                                        !obscureTextPasseord;
                                  });
                                },
                                ),
                              ),
                              _errorText(context, 'confirmPassword'),
                            ],
                          ),
                        ),
                    ],
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
                        if (!_validateForm(appleSetting)) return;
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
                            villId: addressState.selectVillage?.id.toString() ??
                                '',
                            disId: addressState.selectDistrict?.id.toString() ??
                                '',
                            proId: addressState.selectProvince?.id.toString() ??
                                '',
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
