class ScoreListModels {
  int? id;
  String? firstname;
  String? lastname;
  List<Items>? items;
  int? totalScore;
  double? averageScore;
  double? level;

  ScoreListModels(
      {this.id,
      this.firstname,
      this.lastname,
      this.items,
      this.totalScore,
      this.averageScore,
      this.level});

  ScoreListModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    // Ensure proper parsing with fallback for null values
    totalScore = int.tryParse(json['total_score'].toString()) ?? 0;
    averageScore = double.tryParse(json['average_score'].toString()) ?? 0.0;
    level = double.tryParse(json['level'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_score'] = this.totalScore;
    data['average_score'] = this.averageScore;
    data['level'] = this.level;
    return data;
  }
}

class Items {
  int? id;
  String? score;
  // String? dated;
  String? name;

  Items(
      {this.id,
      this.score,
      // this.dated,
      this.name});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    score = json['score'];
    // dated = json['dated'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['score'] = this.score;
    // data['dated'] = this.dated;
    data['name'] = this.name;
    return data;
  }
}
// class ScoreListModels {
//   int? id;
//   String? firstname;
//   String? lastname;
//   List<Items>? items;
//   double? totalScore;
//   double? level;

//   ScoreListModels(
//       {this.id,
//       this.firstname,
//       this.lastname,
//       this.items,
//       this.totalScore,
//       this.level});

//   ScoreListModels.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//     if (json['items'] != null) {
//       items = <Items>[];
//       json['items'].forEach((v) {
//         items!.add(new Items.fromJson(v));
//       });
//     }
//     totalScore = (json['total_score'] != null)
//         ? double.tryParse(json['total_score'].toString())
//         : null; // Ensure the conversion to double
//     level = double.tryParse(json['level'].toString());
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['firstname'] = this.firstname;
//     data['lastname'] = this.lastname;
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     data['total_score'] = this.totalScore;
//     data['level'] = this.level;
//     return data;
//   }
// }

// class Items {
//   int? id;
//   String? score;
//   String? dated;
//   String? name;

//   Items({this.id, this.score, this.dated, this.name});

//   Items.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     score = json['score'];
//     dated = json['dated'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['score'] = this.score;
//     data['dated'] = this.dated;
//     data['name'] = this.name;
//     return data;
//   }
// }
