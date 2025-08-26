class CallStudentModel {
  int? id;
  String? date;
  String? pFirstname;
  String? pLastname;
  String? pPhone;
  String? pCarnumber;
  int? parentRecordsId;
  String? teacherRecordsId;
  int? status;
  String? note;
  List<Items>? items;

  CallStudentModel(
      {this.id,
      this.date,
      this.pFirstname,
      this.pLastname,
      this.pPhone,
      this.pCarnumber,
      this.parentRecordsId,
      this.teacherRecordsId,
      this.status,
      this.note,
      this.items});

  CallStudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    pFirstname = json['p_firstname'];
    pLastname = json['p_lastname'];
    pPhone = json['p_phone'];
    pCarnumber = json['p_car_number'];
    parentRecordsId = json['parent_records_id'];
    teacherRecordsId = json['teacher_records_id'].toString();
    status = json['status'];
    note = json['note'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['p_firstname'] = this.pFirstname;
    data['p_lastname'] = this.pLastname;
    data['p_phone'] = this.pPhone;
    data['p_car_number'] = this.pCarnumber;
    data['parent_records_id'] = this.parentRecordsId;
    data['teacher_records_id'] = this.teacherRecordsId;
    data['status'] = this.status;
    data['note'] = this.note;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? stId;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? phone;
  String? age;
  String? myClass;

  Items(
      {this.id,
      this.stId,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.phone,
      this.myClass,
      this.age});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stId = json['st_id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    age = json['age'].toString();
    myClass = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['st_id'] = this.stId;
    data['profile_image'] = this.profileImage;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['age'] = this.age;
    data['class'] = this.myClass;
    return data;
  }
}
