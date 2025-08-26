// class StudentRecordDropdown {
//   int? id;
//   int? useId;
//   String? firstname;
//   String? lastname;

//   StudentRecordDropdown({this.id, this.useId, this.firstname, this.lastname});

//   StudentRecordDropdown.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     useId = json['use_id'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['use_id'] = this.useId;
//     data['firstname'] = this.firstname;
//     data['lastname'] = this.lastname;
//     return data;
//   }
// }
class StudentRecordDropdownModel {
  int? id;
  int? useId;
  String? firstname;
  String? lastname;
  StudentRecordDropdownModel({this.id, this.useId, this.firstname, this.lastname});
  StudentRecordDropdownModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    useId = map['use_id'];
    firstname = map['firstname'];
    lastname = map['lastname'];
  }
}
