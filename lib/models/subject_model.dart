
class SubjectModels {
  int? id;
  String? name;
  String? shortName;
  String? createdAt;
  SubjectModels({this.id, this.name, this.shortName, this.createdAt});
  SubjectModels.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    shortName = map['short_name'];
    createdAt = map['created_at'];
  }
}
