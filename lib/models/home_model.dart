import 'package:pathana_school_app/models/province_model.dart';

class HomeModel {
  int? id;
  int? stId;
  int? userId;
  int? myClassId;
  String? branchId;
  String? classgroupId;
  String? villId;
  String? disId;
  String? proId;
  LanguageGroupDropdownModel? groupLanguage;
  EthnicGroupDropdownModel? ethnicity;
  SpecialHealthdownModel? specialHealth;
  String? personalTalent;
  ResidencedownModel? living;
  String? admissionNumber;
  int? studentStatus;
  String? imageStudent;
  String? firstname;
  String? lastname;
  String? nickname;
  String? email;
  String? phone;
  ReligionDropdownModel? religion;
  String? gender;
  NationalityDropdownModel? nationality;
  BloodGroupDropdownModel? bloodGroup;
  String? address;
  String? birtdayDate;
  int? userStatus;
  String? className;

  HomeModel({
    this.id,
    this.stId,
    this.userId,
    this.myClassId,
    this.branchId,
    this.classgroupId,
    this.villId,
    this.disId,
    this.proId,
    this.groupLanguage,
    this.ethnicity,
    this.specialHealth,
    this.personalTalent,
    this.living,
    this.admissionNumber,
    this.studentStatus,
    this.imageStudent,
    this.firstname,
    this.lastname,
    this.nickname,
    this.email,
    this.phone,
    this.religion,
    this.gender,
    this.nationality,
    this.bloodGroup,
    this.address,
    this.birtdayDate,
    this.userStatus,
    this.className,
  });

  /// ✅ **Convert JSON to HomeModel**
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'],
      stId: json['st_id'],
      userId: json['user_id'],
      myClassId: json['my_class_id'],
      classgroupId: json['class_group_id'] !=null ? json['class_group_id'].toString() : '0',
      branchId: json['branch_id'] != null ? json['branch_id'].toString() : '0',
      villId: json['vill_id'] != null ? json['vill_id'].toString() : '0',
      disId: json['dis_id'] != null ? json['dis_id'].toString() : '0',
      proId: json['pro_id'] != null ? json['pro_id'].toString() : '0',
      groupLanguage: json['group_language'] is Map<String, dynamic>
          ? LanguageGroupDropdownModel.fromMap(json['group_language'])
          : null,
      ethnicity: json['ethnicity'] is Map<String, dynamic>
          ? EthnicGroupDropdownModel.fromMap(json['ethnicity'])
          : null,
      specialHealth: json['special_health'] is Map<String, dynamic>
          ? SpecialHealthdownModel.fromMap(json['special_health'])
          : null,
      personalTalent: json['personal_talent'],
      living: json['living'] is Map<String, dynamic>
          ? ResidencedownModel.fromMap(json['living'])
          : null,
      admissionNumber: json['admission_number'],
      studentStatus: json['student_status'],
      imageStudent: json['image_student'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      nickname: json['nickname'],
      email: json['email'],
      phone: json['phone'],
      religion: json['religion'] is Map<String, dynamic>
          ? ReligionDropdownModel.fromMap(json['religion'])
          : null,
      gender: json['gender'],
      nationality: json['nationality'] is Map<String, dynamic>
          ? NationalityDropdownModel.fromMap(json['nationality'])
          : null,
      bloodGroup: json['blood_group'] is Map<String, dynamic>
          ? BloodGroupDropdownModel.fromMap(json['blood_group'])
          : null,
      address: json['address'],
      birtdayDate: json['birtday_date'],
      userStatus: json['user_status'],
      className: json['class_name'],
    );
  }

  /// ✅ **Convert HomeModel to JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'st_id': stId,
      'user_id': userId,
      'my_class_id': myClassId,
      'class_group_id': classgroupId,
      'branch_id': branchId,
      'vill_id': villId,
      'dis_id': disId,
      'pro_id': proId,
      'group_language': groupLanguage?.toJson(),
      'ethnicity': ethnicity?.toJson(),
      'special_health': specialHealth?.toJson(),
      'personal_talent': personalTalent,
      'living': living?.toJson(),
      'admission_number': admissionNumber,
      'student_status': studentStatus,
      'image_student': imageStudent,
      'firstname': firstname,
      'lastname': lastname,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'religion': religion?.toJson(),
      'gender': gender,
      'nationality': nationality?.toJson(),
      'blood_group': bloodGroup?.toJson(),
      'address': address,
      'birtday_date': birtdayDate,
      'user_status': userStatus,
      'class_name': className,
    };
  }
}
