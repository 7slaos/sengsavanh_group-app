class AdminSchoolsModel {
  int? id;
  String? nameLa;
  String? nameEn;
  String? nameCn;
  AdminSchoolsModel({this.id, this.nameLa, this.nameEn, this.nameCn});
  AdminSchoolsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameLa = map['name_la'];
    nameEn = map['name_en'];
    nameCn = map['name_cn'];
  }
}
