class ParentRecordeModels {
  int? id;
  String? job;
  String? jobAddress;
  String? jobPosition;
  String? createdAt;
  int? useId;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? religion;
  String? gender;
  String? address;
  String? nationality;
  String? bloodGroup;
  String? birthdayDate;
  String? useStatus;
  String? provinceName;
  String? districtName;
  String? villageName;
  String? branchName;

  ParentRecordeModels(
      {this.id,
      this.job,
      this.jobAddress,
      this.jobPosition,
      this.createdAt,
      this.useId,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.religion,
      this.gender,
      this.address,
      this.nationality,
      this.bloodGroup,
      this.birthdayDate,
      this.useStatus,
      this.provinceName,
      this.districtName,
      this.villageName,
      this.branchName});

  ParentRecordeModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    job = json['job'];
    jobAddress = json['job_address'];
    jobPosition = json['job_position'];
    createdAt = json['created_at'];
    useId = json['use_id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    religion = json['religion'];
    gender = json['gender'];
    address = json['address'];
    nationality = json['nationality'];
    bloodGroup = json['blood_group'];
    birthdayDate = json['birthday_date'];
    useStatus = json['use_status'];
    provinceName = json['province_name'];
    districtName = json['district_name'];
    villageName = json['village_name'];
    branchName = json['branch_name'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['job'] = this.job;
  //   data['job_address'] = this.jobAddress;
  //   data['job_position'] = this.jobPosition;
  //   data['created_at'] = this.createdAt;
  //   data['use_id'] = this.useId;
  //   data['profile_image'] = this.profileImage;
  //   data['firstname'] = this.firstname;
  //   data['lastname'] = this.lastname;
  //   data['email'] = this.email;
  //   data['phone'] = this.phone;
  //   data['religion'] = this.religion;
  //   data['gender'] = this.gender;
  //   data['address'] = this.address;
  //   data['nationality'] = this.nationality;
  //   data['blood_group'] = this.bloodGroup;
  //   data['birthday_date'] = this.birthdayDate;
  //   data['use_status'] = this.useStatus;
  //   data['province_name'] = this.provinceName;
  //   data['district_name'] = this.districtName;
  //   data['village_name'] = this.villageName;
  //   data['branch_name'] = this.branchName;
  //   return data;
  // }
}