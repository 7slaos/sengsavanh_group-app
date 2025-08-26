class AdminStudentModel {
  int? id;
  String? gender;
  String? admissionNumber;
  String? firstname;
  String? lastname;
  String? phone;
  String? myClass;
  String? date;

  AdminStudentModel(
      {this.id,
      this.gender,
        this.admissionNumber,
      this.firstname,
      this.lastname,
      this.phone,
      this.myClass,
      this.date});

  AdminStudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gender = json['gender'];
    admissionNumber = json['admission_number'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    myClass = json['my_class'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['admission_number'] = this.admissionNumber;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['my_class'] = this.myClass;
    data['date'] = this.date;
    return data;
  }
}