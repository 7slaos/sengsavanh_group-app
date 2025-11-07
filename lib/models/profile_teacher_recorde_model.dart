// teacher_record_models.dart
import 'package:pathana_school_app/models/province_model.dart';
class TeacherRcordeModels {
  int? id;
  String? code;
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
  String? birtdayDate; // 'dd/MM/yyyy' or ''
  String? salary;      // formatted string, e.g. "1,200,000"
  String? educationSystem;
  String? specialSubject;
  String? finishSchool;
  String? yearSystemLearn;
  String? yearFinished;
  String? stayAt;
  String? duty;
  String? note;
  String? teacherRecordId;
  double? lat;
  double? lng;
  double? km;
  int? appleStore;

  /// New: student list from API (`select u.id, u.firstname, u.lastname, u.phone, student_records_id`)
  List<StudentLite> student;

  TeacherRcordeModels({
    this.id,
    this.code,
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
    this.educationLevel,
    this.address,
    this.birtdayDate,
    this.salary,
    this.educationSystem,
    this.specialSubject,
    this.finishSchool,
    this.yearSystemLearn,
    this.yearFinished,
    this.stayAt,
    this.duty,
    this.note,
    this.teacherRecordId,
    this.lat,
    this.lng,
    this.km,
    this.appleStore,
    List<StudentLite>? student,
  }) : student = student ?? <StudentLite>[];

  factory TeacherRcordeModels.fromJson(Map<String, dynamic> json) {
    return TeacherRcordeModels(
      id: _asInt(json['id']),
      code: json['code']?.toString(),
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      phone: json['phone']?.toString(),
      imagesProfile: json['images_profile']?.toString(),
      nickname: json['nickname']?.toString(),
      email: json['email']?.toString(),
      religion: json['religion'] != null
          ? ReligionDropdownModel.fromMap(json['religion'])
          : null,
      gender: json['gender']?.toString(),
      villId: json['vill_id'] != null
          ? VillageDropdownModel.fromMap(json['vill_id'])
          : null,
      disId: json['dis_id'] != null
          ? DistrictDropdownModel.fromMap(json['dis_id'])
          : null,
      proId: json['pro_id'] != null
          ? ProvinceDropdownModel.fromMap(json['pro_id'])
          : null,
      nationality: json['nationality'] != null
          ? NationalityDropdownModel.fromMap(json['nationality'])
          : null,
      bloodGroup: json['blood_group'] != null
          ? BloodGroupDropdownModel.fromMap(json['blood_group'])
          : null,
      educationLevel: json['education_level'] != null
          ? EducationLevelDropdownModel.fromMap(json['education_level'])
          : null,
      address: json['address']?.toString(),
      birtdayDate: json['birtday_date']?.toString(),
      salary: json['salary']?.toString(),
      educationSystem: json['education_system']?.toString(),
      specialSubject: json['special_subject']?.toString(),
      finishSchool: json['finish_school']?.toString(),
      yearSystemLearn: json['year_system_learn']?.toString(),
      yearFinished: json['year_finished']?.toString(),
      stayAt: json['stay_at']?.toString(),
      duty: json['duty']?.toString(),
      note: json['note']?.toString(),
      teacherRecordId: json['teacher_records_id']?.toString(),
      lat: _asDouble(json['lat']),
      lng: _asDouble(json['lng']),
      km: _asDouble(json['km']),
      appleStore: _asInt(json['apple_store']),
      student: (json['student'] is List)
          ? (json['student'] as List)
          .whereType<Map<String, dynamic>>()
          .map(StudentLite.fromJson)
          .toList()
          : <StudentLite>[],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phone'] = phone;
    data['images_profile'] = imagesProfile;
    data['nickname'] = nickname;
    data['email'] = email;
    if (religion != null) data['religion'] = religion!.toJson();
    data['gender'] = gender;
    if (villId != null) data['vill_id'] = villId!.toJson();
    if (disId != null) data['dis_id'] = disId!.toJson();
    if (proId != null) data['pro_id'] = proId!.toJson();
    if (nationality != null) data['nationality'] = nationality!.toJson();
    if (bloodGroup != null) data['blood_group'] = bloodGroup!.toJson();
    if (educationLevel != null) {
      data['education_level'] = educationLevel!.toJson();
    }
    data['address'] = address;
    data['birtday_date'] = birtdayDate;
    data['salary'] = salary;
    data['education_system'] = educationSystem;
    data['special_subject'] = specialSubject;
    data['finish_school'] = finishSchool;
    data['year_system_learn'] = yearSystemLearn;
    data['year_finished'] = yearFinished;
    data['stay_at'] = stayAt;
    data['duty'] = duty;
    data['note'] = note;
    data['teacher_records_id'] = teacherRecordId;
    data['lat'] = lat;
    data['lng'] = lng;
    data['km'] = km;
    data['apple_store'] = appleStore;
    data['student'] = student.map((e) => e.toJson()).toList();
    return data;
  }
}

/// Minimal student item matching your SELECT:
///  u.id, u.firstname, u.lastname, u.phone, student_records_id
class StudentLite {
  final int? id; // user (u.id)
  final String? profile;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final int? studentRecordsId;

  const StudentLite({
    this.id,
    this.profile,
    this.firstname,
    this.lastname,
    this.phone,
    this.studentRecordsId,
  });

  factory StudentLite.fromJson(Map<String, dynamic> json) => StudentLite(
    id: _asInt(json['id']),
    profile: json['profile']?.toString(),
    firstname: json['firstname']?.toString(),
    lastname: json['lastname']?.toString(),
    phone: json['phone']?.toString(),
    studentRecordsId: _asInt(json['student_records_id']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'profile': profile,
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'student_records_id': studentRecordsId,
  };

  String get fullName =>
      [firstname, lastname].where((e) => (e ?? '').isNotEmpty).join(' ').trim();
}

/// ===== helpers =====

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
