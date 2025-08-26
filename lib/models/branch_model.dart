class BranchModel {
  int? id;
  String? logo;
  String? nameLa;
  String? nameEn;
  String? nameCn;
  String? phone;
  String? email;
  String? addressLa;
  String? addressCn;
  String? addressEn;
  String? packageStartDate;
  String? packageEndDate;
  int? status;
  String? studentWoman;
  String? studentMan;

  BranchModel(
      {this.id,
      this.logo,
      this.nameLa,
      this.nameEn,
      this.nameCn,
      this.phone,
      this.email,
      this.addressLa,
      this.addressCn,
      this.addressEn,
      this.packageStartDate,
      this.packageEndDate,
      this.status,
      this.studentWoman,
      this.studentMan});

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    nameCn = json['name_cn'];
    phone = json['phone'];
    email = json['email'];
    addressLa = json['address_la'];
    addressCn = json['address_cn'];
    addressEn = json['address_en'];
    packageStartDate = json['package_start_date'];
    packageEndDate = json['package_end_date'];
    status = json['status'];
    studentWoman = json['student_women'].toString();
    studentMan = json['student_man'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['name_la'] = this.nameLa;
    data['name_en'] = this.nameEn;
    data['name_cn'] = this.nameCn;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address_la'] = this.addressLa;
    data['address_cn'] = this.addressCn;
    data['address_en'] = this.addressEn;
    data['package_start_date'] = this.packageStartDate;
    data['package_end_date'] = this.packageEndDate;
    data['status'] = this.status;
    data['student_women'] = this.studentWoman;
    data['student_man'] = this.studentMan;
    return data;
  }
}
