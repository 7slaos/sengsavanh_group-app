import 'package:pathana_school_app/models/province_model.dart';

class TeacherRcordeModels {
  int? id;
  String? firstname;
  String? lastname;
  String? phone;
  String? imagesProfile;
  String? nickname;
  String? email;
  ReligionDropdownModel? religion;
  String? gender;
  VillageDropdownModel? villId;
  DistrictDropdownModel? disId;
  ProvinceDropdownModel? proId;
  NationalityDropdownModel? nationality;
  BloodGroupDropdownModel? bloodGroup;
  EducationLevelDropdownModel? educationLevel;
  String? address;
  String? birtdayDate;
  String? salary;
  String? educationSystem;
  String? specialSubject;
  String? finishSchool;
  String? yearSystemLearn;
  String? yearFinished;
  String? stayAt;
  String? duty;
  String? note;
  String? teacherRecordId;

  TeacherRcordeModels(
      {this.id,
      this.firstname,
      this.lastname,
      this.phone,
      this.imagesProfile,
      this.nickname,
      this.email,
      this.religion,
      this.gender,
      this.villId,
      this.disId,
      this.proId,
      this.nationality,
      this.bloodGroup,
      this.address,
      this.birtdayDate,
      this.salary,
      this.educationSystem,
      this.educationLevel,
      this.specialSubject,
      this.finishSchool,
      this.yearSystemLearn,
      this.yearFinished,
      this.stayAt,
      this.duty,
      this.note, this.teacherRecordId});

  TeacherRcordeModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    imagesProfile = json['images_profile'];
    nickname = json['nickname'];
    email = json['email'];
    religion = json['religion'] != null
        ? new ReligionDropdownModel.fromMap(json['religion'])
        : null;
    gender = json['gender'];
    villId = json['vill_id'] != null
        ? new VillageDropdownModel.fromMap(json['vill_id'])
        : null;
    disId = json['dis_id'] != null
        ? new DistrictDropdownModel.fromMap(json['dis_id'])
        : null;
    proId = json['pro_id'] != null
        ? new ProvinceDropdownModel.fromMap(json['pro_id'])
        : null;
    nationality = json['nationality'] != null
        ? new NationalityDropdownModel.fromMap(json['nationality'])
        : null;
    bloodGroup = json['blood_group'] != null
        ? new BloodGroupDropdownModel.fromMap(json['blood_group'])
        : null;
    address = json['address'];
    birtdayDate = json['birtday_date'];
    salary = json['salary'];
    educationSystem = json['education_system'];
    educationLevel = json['education_level'] != null
        ? new EducationLevelDropdownModel.fromMap(json['education_level'])
        : null;
    specialSubject = json['special_subject'];
    finishSchool = json['finish_school'];
    yearSystemLearn = json['year_system_learn'];
    yearFinished = json['year_finished'].toString();
    stayAt = json['stay_at'];
    duty = json['duty'];
    note = json['note'];
    teacherRecordId = json['teacher_records_id'].toString();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['firstname'] = this.firstname;
  //   data['lastname'] = this.lastname;
  //   data['phone'] = this.phone;
  //   data['images_profile'] = this.imagesProfile;
  //   data['nickname'] = this.nickname;
  //   data['email'] = this.email;
  //   if (this.religion != null) {
  //     data['religion'] = this.religion!.toJson();
  //   }
  //   data['gender'] = this.gender;
  //   data['vill_id'] = this.villId;
  //   data['dis_id'] = this.disId;
  //   data['pro_id'] = this.proId;
  //   if (this.nationality != null) {
  //     data['nationality'] = this.nationality!.toJson();
  //   }
  //   if (this.bloodGroup != null) {
  //     data['blood_group'] = this.bloodGroup!.toJson();
  //   }
  //   data['address'] = this.address;
  //   data['birtday_date'] = this.birtdayDate;
  //   data['salary'] = this.salary;
  //   data['education_system'] = this.educationSystem;
  //   data['education_level'] = this.educationLevel;
  //   data['special_subject'] = this.specialSubject;
  //   data['finish_school'] = this.finishSchool;
  //   data['year_system_learn'] = this.yearSystemLearn;
  //   data['year_finished'] = this.yearFinished;
  //   data['stay_at'] = this.stayAt;
  //   data['duty'] = this.duty;
  //   data['note'] = this.note;
  //   return data;
  // }
}
