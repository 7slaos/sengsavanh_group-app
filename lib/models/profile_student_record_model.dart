import 'package:multiple_school_app/models/province_model.dart';

class ProfileStudentRecordModel {
  int? id;
  String? code;
  String? branchId;
  String? admissionNumber;
  String? firstname;
  String? lastname;
  String? phone;
  String? myClass;
  String? imagesProfile;
  String? age;
  String? nickname;
  String? email;
  ReligionDropdownModel? religion;
  String? gender;
  String? proId;
  String? disId;
  String? villId;
  NationalityDropdownModel? nationality;
  String? birtdayDate;
  String? classGroupId;
  String? myClassId;
  LanguageGroupDropdownModel? groupLanguage;
  EthnicGroupDropdownModel? ethnicity;
  SpecialHealthdownModel? specialHealth;
  String? personalTalent;
  ResidencedownModel? living;
  BloodGroupDropdownModel? bloodGroup;
  String? admissionDate;
  String? parentData;
  String? parentContact;
  String? studentRecordsId;
  double? lat;
  double? lng;
  double? km;

  ProfileStudentRecordModel(
      {this.id,
        this.code,
      this.branchId,
      this.admissionNumber,
      this.firstname,
      this.lastname,
      this.phone,
      this.myClass,
      this.imagesProfile,
      this.age,
      this.nickname,
      this.email,
      this.religion,
      this.gender,
      this.proId,
      this.disId,
      this.villId,
      this.nationality,
      this.birtdayDate,
      this.classGroupId,
      this.myClassId,
      this.groupLanguage,
      this.ethnicity,
      this.specialHealth,
      this.personalTalent,
      this.living,
      this.bloodGroup,
      this.admissionDate,
      this.parentData,
      this.parentContact, this.studentRecordsId, this.lat
        ,this.lng,this.km});

  ProfileStudentRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    branchId = json['branch_id']!=null ? json['branch_id'].toString() : '0';
    admissionNumber = json['admission_number'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    myClass = json['my_class'];
    imagesProfile = json['images_profile'];
    age = json['age'].toString();
    nickname = json['nickname'];
    email = json['email'];
    religion = json['religion'] != null
        ? new ReligionDropdownModel.fromMap(json['religion'])
        : null;
    gender = json['gender'];
    proId = json['pro_id']!=null ? json['pro_id'].toString() : '0';
    disId = json['dis_id']!=null ? json['dis_id'].toString() : '0';
    villId = json['vill_id'] !=null ? json['vill_id'].toString() : '0';
    nationality = json['nationality'] != null
        ? new NationalityDropdownModel.fromMap(json['nationality'])
        : null;
    birtdayDate = json['birtday_date'];
    classGroupId = json['class_group_id']!=null ? json['class_group_id'].toString() : '0';
    myClassId = json['my_class_id']!=null ? json['my_class_id'].toString() : '0';
    groupLanguage = json['group_language'] != null
        ? new LanguageGroupDropdownModel.fromMap(json['group_language'])
        : null;
    ethnicity = json['ethnicity'] != null
        ? new EthnicGroupDropdownModel.fromMap(json['ethnicity'])
        : null;
    specialHealth = json['special_health'] != null
        ? new SpecialHealthdownModel.fromMap(json['special_health'])
        : null;
    personalTalent = json['personal_talent'];
    living = json['living'] != null
        ? new ResidencedownModel.fromMap(json['living'])
        : null;
    bloodGroup = json['blood_group'] != null
        ? new BloodGroupDropdownModel.fromMap(json['blood_group'])
        : null;
    admissionDate = json['admission_date'];
    parentData = json['parent_data'];
    parentContact = json['parent_contact'];
    studentRecordsId = json['student_records_id'].toString();

    // Safely parse optional numeric fields (may be null from API)
    dynamic _numOrNull(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      final s = value.toString();
      return double.tryParse(s);
    }

    lat = _numOrNull(json['lat']) ?? 0.0;
    lng = _numOrNull(json['lng']) ?? 0.0;
    km = _numOrNull(json['km']) ?? 0.0;
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['branch_id'] = this.branchId;
  //   data['admission_number'] = this.admissionNumber;
  //   data['firstname'] = this.firstname;
  //   data['lastname'] = this.lastname;
  //   data['phone'] = this.phone;
  //   data['my_class'] = this.myClass;
  //   data['images_profile'] = this.imagesProfile;
  //   data['age'] = this.age;
  //   data['nickname'] = this.nickname;
  //   data['email'] = this.email;
  //   data['religion'] = this.religion;
  //   data['gender'] = this.gender;
  //   data['pro_id'] = this.proId;
  //   data['dis_id'] = this.disId;
  //   data['vill_id'] = this.villId;
  //   data['nationality'] = this.nationality;
  //   data['birtday_date'] = this.birtdayDate;
  //   data['class_group_id'] = this.classGroupId;
  //   data['my_class_id'] = this.myClassId;
  //   data['group_language'] = this.groupLanguage;
  //   data['ethnicity'] = this.ethnicity;
  //   data['special_health'] = this.specialHealth;
  //   data['personal_talent'] = this.personalTalent;
  //   data['living'] = this.living;
  //   data['admission_date'] = this.admissionDate;
  //   data['parent_data'] = this.parentData;
  //   data['parent_contact'] = this.parentContact;
  //   return data;
  // }
}
