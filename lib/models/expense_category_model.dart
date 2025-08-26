class ExpenseCategoryModel {
  int? id;
  String? name;
  ExpenseCategoryModel({this.id, this.name});
  ExpenseCategoryModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
