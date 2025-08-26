class StudentScoreModels {
  int? id;
  String? groupLanguage;
  String? ethnicity;
  String? specialHealth;
  String? personalTalent;
  String? living;
  String? admissionNumber;
  int? status;
  int? checkStudy;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? phone;
  String? score;

  StudentScoreModels(
      {this.id,
      this.groupLanguage,
      this.ethnicity,
      this.specialHealth,
      this.personalTalent,
      this.living,
      this.admissionNumber,
      this.status,
      this.checkStudy,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.phone,
      this.score});

  StudentScoreModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupLanguage = json['group_language'];
    ethnicity = json['ethnicity'];
    specialHealth = json['special_health'];
    personalTalent = json['personal_talent'];
    living = json['living'];
    admissionNumber = json['admission_number'];
    status = json['status'];
    checkStudy = json['check_study'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_language'] = this.groupLanguage;
    data['ethnicity'] = this.ethnicity;
    data['special_health'] = this.specialHealth;
    data['personal_talent'] = this.personalTalent;
    data['living'] = this.living;
    data['admission_number'] = this.admissionNumber;
    data['status'] = this.status;
    data['check_study'] = this.checkStudy;
    data['profile_image'] = this.profileImage;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['score'] = this.score;
    return data;
  }
}
