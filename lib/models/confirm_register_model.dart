import 'package:pathana_school_app/models/my_classe_model.dart';
import 'package:pathana_school_app/models/province_model.dart';

class ConfirmRegisterModel {
  int? id;
  String? profileImage;
  String? firstname;
  String? nickname;
  String? lastname;
  String? email;
  String? phone;
  String? gender;
  ProvinceDropdownModel? proId;
  DistrictDropdownModel? disId;
  VillageDropdownModel? villId;
  String? birtdayDate;
  MyClasseModels? myClassId;
  String? personalTalent;
  ReligionDropdownModel? religionId;
  NationalityDropdownModel? nationalityId;
  BloodGroupDropdownModel? bloodGroupId;
  LanguageGroupDropdownModel? languageGroupId;
  EthnicGroupDropdownModel? ethnicityId;
  SpecialHealthdownModel? specialHealthId;
  ResidencedownModel? residenceId;
  String? admissionNumber;
  String? admissionDate;
  String? parentData;
  String? parentContact;

  ConfirmRegisterModel(
      {this.id,
      this.profileImage,
      this.firstname,
      this.nickname,
      this.lastname,
      this.email,
      this.phone,
      this.gender,
      this.proId,
      this.disId,
      this.villId,
      this.birtdayDate,
      this.myClassId,
      this.personalTalent,
      this.religionId,
      this.nationalityId,
      this.bloodGroupId,
      this.languageGroupId,
      this.ethnicityId,
      this.specialHealthId,
      this.residenceId,
      this.admissionNumber,
      this.admissionDate,
      this.parentData,
      this.parentContact});

  ConfirmRegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    nickname = json['nickname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    proId = json['pro_id'] != null
        ? new ProvinceDropdownModel.fromMap(json['pro_id'])
        : null;
    disId = json['dis_id'] != null
        ? new DistrictDropdownModel.fromMap(json['dis_id'])
        : null;
    villId = json['vill_id'] != null
        ? new VillageDropdownModel.fromMap(json['vill_id'])
        : null;
    birtdayDate = json['birtday_date'];
    myClassId = json['my_class_id'] != null
        ? new MyClasseModels.fromJson(json['my_class_id'])
        : null;
    personalTalent = json['personal_talent'];
    religionId = json['religion_id'] != null
        ? new ReligionDropdownModel.fromMap(json['religion_id'])
        : null;
    nationalityId = json['nationality_id'] != null
        ? new NationalityDropdownModel.fromMap(json['nationality_id'])
        : null;
    bloodGroupId = json['blood_group_id'] != null
        ? new BloodGroupDropdownModel.fromMap(json['blood_group_id'])
        : null;
    languageGroupId = json['language_group_id'] != null
        ? new LanguageGroupDropdownModel.fromMap(json['language_group_id'])
        : null;
    ethnicityId = json['ethnicity_id'] != null
        ? new EthnicGroupDropdownModel.fromMap(json['ethnicity_id'])
        : null;
    specialHealthId = json['special_health_id'] != null
        ? new SpecialHealthdownModel.fromMap(json['special_health_id'])
        : null;
    residenceId = json['residence_id'] != null
        ? new ResidencedownModel.fromMap(json['residence_id'])
        : null;
    admissionNumber = json['admission_number'];
    admissionDate = json['admission_date'];
    parentData = json['parent_data'];
    parentContact = json['parent_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_image'] = this.profileImage;
    data['firstname'] = this.firstname;
    data['nickname'] = this.nickname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    if (this.proId != null) {
      data['pro_id'] = this.proId!.toJson();
    }
    if (this.disId != null) {
      data['dis_id'] = this.disId!.toJson();
    }
    if (this.villId != null) {
      data['vill_id'] = this.villId!.toJson();
    }
    data['birtday_date'] = this.birtdayDate;
    if (this.myClassId != null) {
      data['my_class_id'] = this.myClassId!.toJson();
    }
    data['personal_talent'] = this.personalTalent;
    if (this.religionId != null) {
      data['religion_id'] = this.religionId!.toJson();
    }
    if (this.nationalityId != null) {
      data['nationality_id'] = this.nationalityId!.toJson();
    }
    if (this.bloodGroupId != null) {
      data['blood_group_id'] = this.bloodGroupId!.toJson();
    }
    if (this.languageGroupId != null) {
      data['language_group_id'] = this.languageGroupId!.toJson();
    }
    if (this.ethnicityId != null) {
      data['ethnicity_id'] = this.ethnicityId!.toJson();
    }
    if (this.specialHealthId != null) {
      data['special_health_id'] = this.specialHealthId!.toJson();
    }
    if (this.residenceId != null) {
      data['residence_id'] = this.residenceId!.toJson();
    }
    data['admission_number'] = this.admissionNumber;
    data['admission_date'] = this.admissionDate;
    data['parent_data'] = this.parentData;
    data['parent_contact'] = this.parentContact;
    return data;
  }
}
