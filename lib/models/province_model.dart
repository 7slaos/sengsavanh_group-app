class SchoolListModel {
  int? id;
  String? logo;
  String? nameLa;
  String? nameEn;
  String? nameCn;
  String? addressLa;
  String? addressEn;
  String? addressCn;
  int? appleSetting;
  SchoolListModel(
      {this.id,
        this.logo,
      this.nameLa,
      this.nameEn,
      this.nameCn,
      this.addressLa,
      this.addressEn,
      this.addressCn, this.appleSetting});
  SchoolListModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    logo = map['logo'];
    nameLa = map['name_la'];
    nameEn = map['name_en'];
    nameCn = map['name_cn'];
    addressLa = map['address_la'];
    addressEn = map['address_en'];
    addressCn = map['address_cn'];
    appleSetting = map['apple_setting'] ?? 0;
  }
}

class ProvinceDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  ProvinceDropdownModel({this.id, this.nameLa, this.nameEn});

  ProvinceDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameLa = map['name_la'];
    nameEn = map['name_en']; // Fixed "name_end" to "name_en"
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class DistrictDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;
  int? proId;

  DistrictDropdownModel({this.id, this.nameLa, this.nameEn, this.proId});

  DistrictDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameLa = map['name_la'];
    nameEn = map['name_en'];
    proId = map['pro_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
      'pro_id': proId,
    };
  }
}

class VillageDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;
  int? disId;

  VillageDropdownModel({this.id, this.nameLa, this.nameEn, this.disId});

  VillageDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameLa = map['name_la'];
    nameEn = map['name_en'];
    disId = map['dis_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
      'dis_id': disId,
    };
  }
}

class ClassGroupDropdownModel {
  int? id;
  String? name;

  ClassGroupDropdownModel({this.id, this.name});

  ClassGroupDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ClassListDropdownModel {
  int? id;
  String? name;

  ClassListDropdownModel({this.id, this.name});

  ClassListDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}

class BloodGroupDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  BloodGroupDropdownModel({this.id, this.nameLa, this.nameEn});

  // Factory constructor for fromMap()
  factory BloodGroupDropdownModel.fromMap(Map<String, dynamic> map) {
    return BloodGroupDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class ReligionDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  ReligionDropdownModel({this.id, this.nameLa, this.nameEn});

  factory ReligionDropdownModel.fromMap(Map<String, dynamic> map) {
    return ReligionDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class NationalityDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  NationalityDropdownModel({this.id, this.nameLa, this.nameEn});

  factory NationalityDropdownModel.fromMap(Map<String, dynamic> map) {
    return NationalityDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class EducationLevelDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  EducationLevelDropdownModel({this.id, this.nameLa, this.nameEn});

  factory EducationLevelDropdownModel.fromMap(Map<String, dynamic> map) {
    return EducationLevelDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class LanguageGroupDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  LanguageGroupDropdownModel({this.id, this.nameLa, this.nameEn});

  factory LanguageGroupDropdownModel.fromMap(Map<String, dynamic> map) {
    return LanguageGroupDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class EthnicGroupDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  EthnicGroupDropdownModel({this.id, this.nameLa, this.nameEn});

  factory EthnicGroupDropdownModel.fromMap(Map<String, dynamic> map) {
    return EthnicGroupDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class SpecialHealthdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  SpecialHealthdownModel({this.id, this.nameLa, this.nameEn});

  factory SpecialHealthdownModel.fromMap(Map<String, dynamic> map) {
    return SpecialHealthdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class ResidencedownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  ResidencedownModel({this.id, this.nameLa, this.nameEn});

  factory ResidencedownModel.fromMap(Map<String, dynamic> map) {
    return ResidencedownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}

class JobDropdownModel {
  int? id;
  String? nameLa;
  String? nameEn;

  JobDropdownModel({this.id, this.nameLa, this.nameEn});

  factory JobDropdownModel.fromMap(Map<String, dynamic> map) {
    return JobDropdownModel(
      id: map['id'],
      nameLa: map['name_la'],
      nameEn: map['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_la': nameLa,
      'name_en': nameEn,
    };
  }
}
