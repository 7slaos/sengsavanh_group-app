import 'package:pathana_school_app/models/province_model.dart';

class ProfiledModels {
  int? id;
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

  ProfiledModels(
      {this.id,
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
      this.birtdayDate});

  ProfiledModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
  }
}
