class ScoreStudentModels {
  int? id;
  int? myClassId;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? className;
  List<Items>? items;
  String? totalScore;
  String? averageScore;
  String? level;
  String? month;

  ScoreStudentModels(
      {this.id,
      this.myClassId,
      this.profileImage,
      this.firstname,
      this.lastname,
      this.className,
      this.items,
      this.totalScore,
      this.averageScore,
      this.level,
      this.month});

  ScoreStudentModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myClassId = json['my_class_id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    className = json['class_name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    totalScore = json['total_score'].toString();
    averageScore = json['average_score'].toString();
    level = json['level'].toString();
    month = json['month'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['my_class_id'] = this.myClassId;
    data['profile_image'] = this.profileImage;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['class_name'] = this.className;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_score'] = this.totalScore;
    data['average_score'] = this.averageScore;
    data['level'] = this.level;
    data['month'] = this.month;
    return data;
  }
}

class Items {
  String? name;
  int? id;
  String? score;

  Items({this.name, this.id, this.score});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['score'] = this.score;
    return data;
  }
}
