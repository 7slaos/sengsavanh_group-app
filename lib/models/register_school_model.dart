class RegisterSchoolModel {
  int? id;
  String? nameLa;
  String? nameEn;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? village;
  String? district;
  String? province;

  RegisterSchoolModel(
      {this.id,
      this.nameLa,
      this.nameEn,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.village,
      this.district,
      this.province});

  RegisterSchoolModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'].toString();
    village = json['village'];
    district = json['district'];
    province = json['province'];
  }
}
