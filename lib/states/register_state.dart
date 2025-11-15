// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/home_model.dart';
import 'package:pathana_school_app/models/package_model.dart';
import 'package:pathana_school_app/models/profile_student_record_model.dart';
import 'package:pathana_school_app/models/profiled_model.dart';
import 'package:pathana_school_app/models/province_model.dart';
import 'package:pathana_school_app/models/register_school_model.dart';
import 'package:pathana_school_app/models/register_student_mode.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/pages/register_student_success.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/update_images_profile_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import '../repositorys/repository.dart';
import 'package:http/http.dart' as http;

class RegisterState extends GetMaterialController {
  AppVerification appVerification = Get.put(AppVerification());
  HomeState homeState = Get.put(HomeState());
  PickImageState pickImageState = Get.put(PickImageState());
  AddressState addressState = Get.put(AddressState());
  ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  final Repository rep = Get.put(Repository());
  List<SchoolListModel> schoolList = [];
  List<PackageModel> packageList = [];
  RegisterStudentModel? registerStudentModel;
  RegisterSchoolModel? registerSchoolModel;
  int index = 0;
  String gender = '2';
  final nameLa = TextEditingController();
  final nameEn = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final nickname = TextEditingController();
  final birthdayDate = TextEditingController();
  final email = TextEditingController();
  final religion = TextEditingController();
  final job = TextEditingController();
  final jobAddress = TextEditingController();
  final jobPosition = TextEditingController();
  final carNumber = TextEditingController();
  final nationality = TextEditingController();
  final groupLanguage = TextEditingController();
  final ethnicity = TextEditingController();
  final spacialHealthy = TextEditingController();
  final living = TextEditingController();
  final personalTalent = TextEditingController();
  final parentData = TextEditingController();
  final parentContact = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final searchprovinceGroup = TextEditingController();
  final searchdistrictGroup = TextEditingController();
  final searchvillageGroup = TextEditingController();
  final searchclassGroup = TextEditingController();
  final searchBloodGroup = TextEditingController();
  final searchReligion = TextEditingController();
  final searchNationality = TextEditingController();
  final searchEducationLevel = TextEditingController();
  final searchLanguageGroup = TextEditingController();
  final searchEthinicity = TextEditingController();
  final searchSpecialHealth = TextEditingController();
  final searchResidense = TextEditingController();
  final searchJob = TextEditingController();
  bool checkSchool = false;
  bool checkEditStudentProfile = false;
  ClassGroupDropdownModel? selectclassGroup;
  ClassListDropdownModel? selectClass;
  Future<void> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 50), // Set your desired range
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selectedDate != null) {
      birthdayDate.text =
          '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      update();
    }
  }

  updateIndex(int v) {
    index = v;
    update();
  }

  updateGender(String g) {
    gender = g;
    update();
  }

  selectclassGroupDropdown(ClassGroupDropdownModel v) {
    selectclassGroup = v;
    update();
  }

  selectclassDropdown(ClassListDropdownModel v) {
    selectClass = v;
    update();
  }

  List<ClassListDropdownModel> classList = [];
  getSchools() async {
    schoolList = [];
    checkSchool = false;
    var res = await rep.get(url: '${rep.nuXtJsUrlApi}api/Application/AddressApiController/get_schools');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        schoolList.add(SchoolListModel.fromMap(item));
      }
    }
    checkSchool = true;
    update();
  }

  getPackages() async {
    packageList = [];
    var res = await rep.get(url: '${rep.nuXtJsUrlApi}api/Application/LoginApiController/get_packages');
    // print(res.body);
    if (res.statusCode == 200) {
      for (var item
          in jsonDecode(utf8.decode(res.bodyBytes))['data']) {
        packageList.add(PackageModel.fromJson(item));
      }
    }
    update();
  }

  cleardropdownList() {
    selectclassGroup = null;
    update();
  }

  clearDropdownClass() {
    selectClass = null;
    update();
  }

  clearClassGroupAndClass() {
    selectclassGroup = null;
    selectClass = null;
    update();
  }

  clearData() {
    gender = '2';
    nameLa.text = '';
    nameEn.text = '';
    firstname.text = '';
    lastname.text = '';
    nickname.text = '';
    birthdayDate.text = '';
    email.text = '';
    religion.text = '';
    nationality.text = '';
    groupLanguage.text = '';
    ethnicity.text = '';
    spacialHealthy.text = '';
    living.text = '';
    parentData.text = '';
    parentContact.text = '';
    phone.text = '';
    password.text = '';
    job.text = '';
    jobAddress.text = '';
    jobPosition.text = '';
    carNumber.text = '';
    confirmPassword.text = '';
    searchprovinceGroup.text = '';
    searchdistrictGroup.text = '';
    searchvillageGroup.text = '';
    searchclassGroup.text = '';
    selectclassGroup = null;
    selectClass = null;
    personalTalent.text = '';
    update();
    addressState.clearData();
    pickImageState.deleteFileImage();
  }

  getCurrentProfile(
      ProfileStudentRecordModel? data, HomeModel? pData, String type) async {
    checkEditStudentProfile = false;
    if (data != null && type == 's') {
      gender = data.gender ?? '';
      firstname.text = data.firstname ?? '';
      lastname.text = data.lastname ?? '';
      nickname.text = data.nickname ?? '';
      birthdayDate.text = data.birtdayDate ?? '';
      email.text = data.email ?? '';
      parentData.text = data.parentData ?? '';
      parentContact.text = data.parentContact ?? '';
      phone.text = data.phone ?? '';
      personalTalent.text = data.personalTalent ?? '';
      await addressState.getProvinceById(data.proId.toString());
      await addressState.getDistrict(int.parse(data.proId.toString()), null);
      await addressState.getVillage(int.parse(data.disId.toString()), null);
      await getclassGroupById(data.classGroupId.toString());
      await addressState.getClassList(
          branchId: data.branchId.toString(), id: data.classGroupId.toString());
    } else if (pData != null && type == 't') {
      gender = pData.gender ?? '';
      firstname.text = pData.firstname ?? '';
      lastname.text = pData.lastname ?? '';
      nickname.text = pData.nickname ?? '';
      birthdayDate.text = pData.birtdayDate ?? '';
      email.text = pData.email ?? '';
      phone.text = pData.phone ?? '';
      if (pData.proId != 'null' && pData.proId != '') {
        await addressState.getProvinceById(pData.proId.toString());
        await addressState.getDistrict(int.parse(pData.proId.toString()), null);
        await addressState.getDistrictById(pData.disId.toString());
      }
      if (pData.disId != 'null' && pData.disId != '') {
        await addressState.getVillage(int.parse(pData.disId.toString()), null);
        await addressState.getVillageById(pData.villId.toString());
      }
      getclassGroupById(pData.classgroupId.toString());
      await addressState.getClassList(
          id: pData.classgroupId.toString(),
          branchId: pData.branchId.toString());
      getmyClassById(pData.myClassId.toString());
    }
    checkEditStudentProfile = true;
    update();
  }

  getCurrentProfileParent(ProfiledModels data) async {
    selectClass = null;
    selectclassGroup = null;
    addressState.clearData();
    update();
    gender = data.gender ?? '';
    firstname.text = data.firstname ?? '';
    lastname.text = data.lastname ?? '';
    nickname.text = data.nickname ?? '';
    birthdayDate.text = data.birtdayDate ?? '';
    email.text = data.email ?? '';
    phone.text = data.phone ?? '';
    searchprovinceGroup.text = '';
    searchdistrictGroup.text = '';
    searchvillageGroup.text = '';
    jobAddress.text = data.jobAddress ?? '';
    jobPosition.text = data.jobPosition ?? '';
    carNumber.text = data.carNumber ?? '';
    await addressState.getProvinceById(data.proId.toString());
    await addressState.getDistrict(int.parse(data.proId.toString()), null);
    await addressState.getVillage(int.parse(data.disId.toString()), null);
    update();
  }

  getclassGroupById(String id) {
    if (addressState.classgroupList.isNotEmpty) {
      selectclassGroup = addressState.classgroupList
          .firstWhereOrNull((e) => e.id.toString() == id);
      update();
    }
  }

  getmyClassById(String id) {
    if (addressState.classList.isNotEmpty) {
      selectClass =
          addressState.classList.firstWhereOrNull((e) => e.id.toString() == id);
      update();
    }
  }

  Future<void> registerStudent({
    required BuildContext context,
    required String firstname,
    required String lastname,
    required String branchId,
    required String gender,
    required String birthdayDate,
    required String phone,
    required String password,
    required String myClassid,
    String? nickname,
    String? email,
    String? religion,
    String? nationality,
    String? groupLanguage,
    String? ethnicity,
    String? spacialHealthy,
    String? living,
    String? bloodgroupId,
    String? parentData,
    String? parentContact,
    String? villId,
    String? disId,
    String? proId,
    String? personalTalent,
    XFile? fileImage,
    String? appleSetting
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse('${rep.nuXtJsUrlApi}api/Application/LoginApiController/register_student');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        'branch_id': branchId,
        'gender': gender,
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname ?? '',
        'email': email ?? '',
        'religion_id': religion ?? '',
        'birtday_date': birthdayDate,
        'nationality_id': nationality ?? '',
        'language_group_id': groupLanguage ?? '',
        'ethnicity_id': ethnicity ?? '',
        'special_health_id': spacialHealthy ?? '',
        'residence_id': living ?? '',
        'blood_group_id': bloodgroupId ?? '',
        'parent_data': parentData ?? '',
        'parent_contact': parentContact ?? '',
        'password': password,
        'my_class_id': myClassid,
        'vill_id': villId ?? '',
        'dis_id': disId ?? '',
        'pro_id': proId ?? '',
        'personal_talent': personalTalent ?? '',
        'phone': phone,
        'apple_setting': appleSetting ?? ''
      });
      if (fileImage != null) {
        var picture =
            await http.MultipartFile.fromPath('profile_image', fileImage.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      var responseBody = await response.stream.bytesToString();
      // print('2222222222222222222222222222222222222222222');
      // print(jsonDecode(responseBody));
      if (response.statusCode == 200) {
        addressState.clearData();
        clearData();
        registerStudentModel =
            RegisterStudentModel.fromJson(jsonDecode(responseBody)['data']);
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        if (registerStudentModel != null) {
          Get.offAll(() => RegisterStudentSuccess(data: registerStudentModel!),
              transition: Transition.fadeIn);
        }
      } else if (response.statusCode == 404) {
        CustomDialogs().showToast(
          backgroundColor: AppColor().red.withOpacity(0.9),
          text: jsonDecode(responseBody)['message'],
        );
      } else {
        CustomDialogs().showToast(
          backgroundColor: AppColor().red.withOpacity(0.9),
          text:
              jsonDecode(responseBody)['message'] ?? 'Something went wrong'.tr,
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().red,
        text: 'something_went_wrong'.tr,
      );
    }
  }

  Future<void> registerSchool({
    required BuildContext context,
    required String id,
    required String nameLa,
    required String nameEn,
    required String firstname,
    required String phone,
    required String villId,
    required String disId,
    required String proId,
    required String password,
    String? lastname,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var res = await rep.post(url: '${rep.nuXtJsUrlApi}api/Application/LoginApiController/register_school', body: {
        'id': id,
        'name_la': nameLa,
        'name_en': nameEn,
        'firstname': firstname,
        'lastname': lastname ?? '',
        'phone': phone,
        'password': password,
        'vill_id': villId,
        'dis_id': disId,
        'pro_id': proId,
      });
      // print(res.body);
      Get.back();
      if (res.statusCode == 200) {
        clearData();
        registerSchoolModel = RegisterSchoolModel.fromJson(
            jsonDecode(utf8.decode(res.bodyBytes))['data']);
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        if (registerSchoolModel != null) {
          // ignore: use_build_context_synchronously
          showMyDialogSuccess(context, registerSchoolModel!);
        }
      } else {
        CustomDialogs().showToast(
          backgroundColor: AppColor().red.withOpacity(0.9),
          text: jsonDecode(utf8.decode(res.bodyBytes))['message'] ??
              'Something went wrong'.tr,
        );
      }
    } catch (e) {
      Get.back();
      CustomDialogs().showToast(
        backgroundColor: AppColor().black,
        text: 'something_went_wrong'.tr,
      );
    }
  }

  showMyDialogSuccess(BuildContext context, RegisterSchoolModel data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColor().green,
                  size: fixSize(0.07, context),
                ),
              ),
              Center(child: CustomText(text: 'success')),
              Center(
                child: CustomText(
                    text: 'register',
                    fontSize: fixSize(0.0165, context),
                    fontWeight: FontWeight.bold),
              ),
              const Divider(),
              CustomText(
                text: 'school',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: CheckLang(
                        nameLa: data.nameLa ?? '',
                        nameCn: data.nameEn ?? '',
                        nameEn: data.nameEn ?? '')
                    .toString(),
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
              CustomText(
                text: 'School_owner',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: '${data.firstname ?? ""} ${data.lastname ?? ""}',
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
              CustomText(
                text: 'phone',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: data.phone ?? '',
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
              CustomText(
                text: 'village',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: data.village ?? '',
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
              CustomText(
                text: 'district',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: data.district ?? '',
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
              CustomText(
                text: 'province',
                fontSize: fixSize(0.0135, context),
                fontWeight: FontWeight.w300,
                color: AppColor().grey,
              ),
              CustomText(
                text: data.province ?? '',
                fontSize: fixSize(0.0145, context),
              ),
              const Divider(),
            ],
          ),
          backgroundColor: AppColor().white,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ButtonWidget(
                height: fixSize(0.05, context),
                width: fixSize(0.5, context),
                color: AppColor().white,
                backgroundColor: AppColor().mainColor.withOpacity(0.8),
                fontSize: fixSize(0.0165, context),
                fontWeight: FontWeight.bold,
                borderRadius: 5,
                onPressed: () async {
                  Get.offAll(() => LoginPage(), transition: Transition.fadeIn);
                },
                text: 'success'),
          ],
        );
      },
    );
  }

  Future<void> updateStudentProfile({
    required BuildContext context,
    required String type,
    required String id,
    required String firstname,
    required String lastname,
    required String gender,
    required String birthdayDate,
    required String phone,
    required String password,
    String? myClassid,
    String? nickname,
    String? email,
    String? religion,
    String? nationality,
    String? groupLanguage,
    String? ethnicity,
    String? spacialHealthy,
    String? living,
    String? parentData,
    String? parentContact,
    String? villId,
    String? disId,
    String? proId,
    String? personalTalent,
    String? bloodGroup,
    XFile? fileImage,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var uri = Uri.parse('${rep.nuXtJsUrlApi}api/Application/LoginApiController/update_profiled_studentrecord');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.token}',
      });
      request.fields.addAll({
        'id': id,
        'gender': gender,
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname ?? '',
        'email': email ?? '',
        'religion_id': religion ?? '',
        'blood_group_id': bloodGroup ?? '',
        'birtday_date': birthdayDate,
        'nationality_id': nationality ?? '',
        'language_group_id': groupLanguage ?? '',
        'ethnicity_id': ethnicity ?? '',
        'special_health_id': spacialHealthy ?? '',
        'residence_id': living ?? '',
        'parent_data': parentData ?? '',
        'parent_contact': parentContact ?? '',
        'password': password,
        'my_class_id': myClassid ?? '',
        'vill_id': villId ?? '',
        'dis_id': disId ?? '',
        'pro_id': proId ?? '',
        'personal_talent': personalTalent ?? '',
        'phone': phone
      });
      if (fileImage != null) {
        var picture =
            await http.MultipartFile.fromPath('profile_image', fileImage.path);
        request.files.add(picture);
      }
      var response = await request.send().timeout(const Duration(seconds: 120));
      Get.back();
      var responseBody = await response.stream.bytesToString();
      // print('2222222222222222222222222222222222222222222');
      // print(jsonDecode(responseBody));
      if (response.statusCode == 200) {
        pickImageState.deleteFileImage();
        if (type == 's') {
          clearData();
          profileStudentState.getProfileStudent();
        } else {
          homeState.getHomeParentAndStudentList();
        }
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.6),
          text: 'success'.tr,
        );
        Get.back(result: true);
      } else {
        CustomDialogs().showToast(
          backgroundColor: AppColor().red,
          text: jsonDecode(responseBody)['message'],
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black,
        text: 'something_went_wrong'.tr,
      );
    }
  }
}
