class DashboardTeacherModels {
  int? id;
  String? educationSystem;
  String? educationLevel;
  String? specialSubject;
  String? finishSchool;
  String? yearSystemLearn;
  int? yearFinished;
  String? stayAt;
  String? duty;
  int? status;
  int? useId;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? religion;
  String? gender;
  String? nationality;
  String? bloodGroup;
  String? birtdayDate;
  int? useStatus;
  String? villageName;
  String? districtName;
  String? provinceName;
  String? branchName;

  DashboardTeacherModels(
      {this.id,
      this.educationSystem,
      this.educationLevel,
      this.specialSubject,
      this.finishSchool,
      this.yearSystemLearn,
      this.yearFinished,
      this.stayAt,
      this.duty,
      this.status,
      this.useId,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.religion,
      this.gender,
      this.nationality,
      this.bloodGroup,
      this.birtdayDate,
      this.useStatus,
      this.villageName,
      this.districtName,
      this.provinceName,
      this.branchName});

  DashboardTeacherModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    educationSystem = json['education_system'];
    educationLevel = json['education_level'];
    specialSubject = json['special_subject'];
    finishSchool = json['finish_school'];
    yearSystemLearn = json['year_system_learn'];
    yearFinished = json['year_finished'];
    stayAt = json['stay_at'];
    duty = json['duty'];
    status = json['status'];
    useId = json['use_id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    religion = json['religion'];
    gender = json['gender'];
    nationality = json['nationality'];
    bloodGroup = json['blood_group'];
    birtdayDate = json['birtday_date'];
    useStatus = json['use_status'];
    villageName = json['village_name'];
    districtName = json['district_name'];
    provinceName = json['province_name'];
    branchName = json['branch_name'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['education_system'] = this.educationSystem;
  //   data['education_level'] = this.educationLevel;
  //   data['special_subject'] = this.specialSubject;
  //   data['finish_school'] = this.finishSchool;
  //   data['year_system_learn'] = this.yearSystemLearn;
  //   data['year_finished'] = this.yearFinished;
  //   data['stay_at'] = this.stayAt;
  //   data['duty'] = this.duty;
  //   data['status'] = this.status;
  //   data['use_id'] = this.useId;
  //   data['profile_image'] = this.profileImage;
  //   data['firstname'] = this.firstname;
  //   data['lastname'] = this.lastname;
  //   data['email'] = this.email;
  //   data['phone'] = this.phone;
  //   data['religion'] = this.religion;
  //   data['gender'] = this.gender;
  //   data['nationality'] = this.nationality;
  //   data['blood_group'] = this.bloodGroup;
  //   data['birtday_date'] = this.birtdayDate;
  //   data['use_status'] = this.useStatus;
  //   data['village_name'] = this.villageName;
  //   data['district_name'] = this.districtName;
  //   data['province_name'] = this.provinceName;
  //   data['branch_name'] = this.branchName;
  //   return data;
  // }
}