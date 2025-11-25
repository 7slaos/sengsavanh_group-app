import 'package:multiple_school_app/models/province_model.dart';

class ProfiledModels {
  int? id;
  String? code;
  String? profileImage;
  String? firstname;
  String? nickname;
  String? lastname;
  String? email;
  String? phone;
  ReligionDropdownModel? religion;
  JobDropdownModel? job;
  String? jobAddress;
  String? jobPosition;
  String? carNumber;
  String? gender;
  String? villId;
  String? disId;
  String? proId;
  String? birtdayDate;
  double? lat;
  double? lng;
  double? km;

  ProfiledModels(
      {this.id,
        this.code,
      this.profileImage,
      this.firstname,
      this.nickname,
      this.lastname,
      this.email,
      this.phone,
      this.religion,
      this.job,
      this.jobAddress,
      this.jobPosition,
      this.carNumber,
      this.gender,
      this.villId,
      this.disId,
      this.proId,
      this.birtdayDate,this.lat,this.lng,this.km});

  ProfiledModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    nickname = json['nickname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    religion = json['religion'] != null
        ? new ReligionDropdownModel.fromMap(json['religion'])
        : null;
    job =
        json['job'] != null ? new JobDropdownModel.fromMap(json['job']) : null;
    jobAddress = json['job_address'];
    jobPosition = json['job_position'];
    carNumber = json['car_number'];
    gender = json['gender'];
    villId = json['vill_id'].toString();
    disId = json['dis_id'].toString();
    proId = json['pro_id'].toString();
    birtdayDate = json['birtday_date'];
    // The Nuxt get_Profileds endpoint may not provide these; parse defensively
    try {
      final latRaw = json['lat'];
      lat = latRaw == null || latRaw.toString().isEmpty || latRaw.toString() == 'null'
          ? null
          : double.tryParse(latRaw.toString());
    } catch (_) { lat = null; }
    try {
      final lngRaw = json['lng'];
      lng = lngRaw == null || lngRaw.toString().isEmpty || lngRaw.toString() == 'null'
          ? null
          : double.tryParse(lngRaw.toString());
    } catch (_) { lng = null; }
    try {
      final kmRaw = json['km'];
      km = kmRaw == null || kmRaw.toString().isEmpty || kmRaw.toString() == 'null'
          ? null
          : double.tryParse(kmRaw.toString());
    } catch (_) { km = null; }
  }
}
