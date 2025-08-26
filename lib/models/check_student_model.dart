class CheckStudentModel {
  int? id;
  String? admissionNumber;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? phone;
  String? birtdayDate;
  String? age;
  String? myClass;
  String? village;
  String? district;
  String? province;

  CheckStudentModel(
      {this.id,
      this.admissionNumber,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.phone,
      this.birtdayDate,
      this.age,
      this.myClass,
      this.village,
      this.district,
      this.province});

  CheckStudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    admissionNumber = json['admission_number'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    birtdayDate = json['birtday_date'];
    age = json['age'].toString();
    myClass = json['my_class'];
    village = json['village'];
    district = json['district'];
    province = json['province'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['admission_number'] = this.admissionNumber;
  //   data['profile_image'] = this.profileImage;
  //   data['firstname'] = this.firstname;
  //   data['lastname'] = this.lastname;
  //   data['phone'] = this.phone;
  //   data['birtday_date'] = this.birtdayDate;
  //   data['age'] = this.age;
  //   data['my_class'] = this.myClass;
  //   data['village'] = this.village;
  //   data['district'] = this.district;
  //   data['province'] = this.province;
  //   return data;
  // }
}
