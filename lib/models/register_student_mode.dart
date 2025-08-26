class RegisterStudentModel {
  int? id;
  String? profileImage;
  String? branchLa;
  String? branchEn;
  String? branchCn;
  String? firstname;
  String? nickname;
  String? lastname;
  String? email;
  String? phone;
  String? religionLa;
  String? religionEn;
  String? gender;
  String? province;
  String? district;
  String? village;
  String? nationalityLa;
  String? nationalityEn;
  String? birtdayDate;
  String? myClass;
  String? groupLanguageLa;
  String? groupLanguageEn;
  String? ethnicityLa;
  String? ethnicityEn;
  String? specialHealthLa;
  String? specialHealthEn;
  String? personalTalent;
  String? livingLa;
  String? livingEn;
  String? admissionNumber;
  String? admissionDate;
  String? parentData;
  String? parentContact;
  String? bloodGroupLa;
  String? bloodGroupEn;

  RegisterStudentModel(
      {this.id,
      this.profileImage,
      this.branchLa,
      this.branchEn,
      this.branchCn,
      this.firstname,
      this.nickname,
      this.lastname,
      this.email,
      this.phone,
      this.religionLa,
      this.religionEn,
      this.gender,
      this.province,
      this.district,
      this.village,
      this.nationalityLa,
      this.nationalityEn,
      this.birtdayDate,
      this.myClass,
      this.groupLanguageLa,
      this.groupLanguageEn,
      this.ethnicityLa,
      this.ethnicityEn,
      this.specialHealthLa,
      this.specialHealthEn,
      this.personalTalent,
      this.livingLa,
      this.livingEn,
      this.admissionNumber,
      this.admissionDate,
      this.parentData,
      this.parentContact,
      this.bloodGroupLa,
      this.bloodGroupEn});

  RegisterStudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImage = json['profile_image'];
    branchLa = json['branch_la'];
    branchEn = json['branch_en'];
    branchCn = json['branch_cn'];
    firstname = json['firstname'];
    nickname = json['nickname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    religionLa = json['religion_la'];
    religionEn = json['religion_en'];
    gender = json['gender'];
    province = json['province'];
    district = json['district'];
    village = json['village'];
    nationalityLa = json['nationality_la'];
    nationalityEn = json['nationality_en'];
    birtdayDate = json['birtday_date'];
    myClass = json['my_class'];
    groupLanguageLa = json['group_language_la'];
    groupLanguageEn = json['group_language_en'];
    ethnicityLa = json['ethnicity_la'];
    ethnicityEn = json['ethnicity_en'];
    specialHealthLa = json['special_health_la'];
    specialHealthEn = json['special_health-en'];
    personalTalent = json['personal_talent'];
    livingLa = json['living_la'];
    livingEn = json['living_en'];
    admissionNumber = json['admission_number'].toString();
    admissionDate = json['admission_date'];
    parentData = json['parent_data'];
    parentContact = json['parent_contact'];
    bloodGroupLa = json['bloodGroup_la'];
    bloodGroupEn = json['bloodGroup_en'];
  }
}
