class ScoreChildrenModels {
  int? id;
  int? myClassId;
  int? pruId;
  int? prId;
  String? profileImage;
  String? firstname;
  String? lastname;
  String? className;
  List<Months>? months;

  ScoreChildrenModels({
    this.id,
    this.myClassId,
    this.pruId,
    this.prId,
    this.profileImage,
    this.firstname,
    this.lastname,
    this.className,
    this.months,
  });

  ScoreChildrenModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myClassId = json['my_class_id'];
    pruId = json['pru_id'];
    prId = json['pr_id'];
    profileImage = json['profile_image'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    className = json['class_name'];
    if (json['months'] != null) {
      months = <Months>[];
      json['months'].forEach((v) {
        try {
          months!.add(Months.fromJson(v));
        } catch (e) {
          print('❌ Failed to parse month: $e');
        }
      });
    }
  }
}

class Months {
  int? month;
  int? year;
  List<Items>? items;
  int? totalScore;
  double? averageScore;
  int? level;

  Months({
    this.month,
    this.year,
    this.items,
    this.totalScore,
    this.averageScore,
    this.level,
  });

  Months.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        try {
          items!.add(Items.fromJson(v));
        } catch (e) {
          print('❌ Failed to parse item: $e');
        }
      });
    }
    totalScore = json['total_score'];

    // Handle averageScore as int or double
    if (json['average_score'] is int) {
      averageScore = (json['average_score'] as int).toDouble();
    } else if (json['average_score'] is double) {
      averageScore = json['average_score'];
    } else if (json['average_score'] is String) {
      averageScore = double.tryParse(json['average_score']);
    }

    level = json['level'];
  }
}

class Items {
  String? name;
  int? id;
  String? score;

  Items({
    this.name,
    this.id,
    this.score,
  });

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];

    // Convert score to string safely
    if (json['score'] != null) {
      score = json['score'].toString();
    }
  }
}

// class ScoreChildrenModels {
//   int? id;
//   int? myClassId;
//   int? pruId;
//   int? prId;
//   String? profileImage;
//   String? firstname;
//   String? lastname;
//   String? className;
//   List<Items>? items;
//   int? totalScore;
//   double? averageScore;
//   double? level;

//   ScoreChildrenModels(
//       {this.id,
//       this.myClassId,
//       this.pruId,
//       this.prId,
//       this.profileImage,
//       this.firstname,
//       this.lastname,
//       this.className,
//       this.items,
//       this.totalScore,
//       this.averageScore,
//       this.level});

//   ScoreChildrenModels.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     myClassId = json['my_class_id'];
//     pruId = json['pru_id'];
//     prId = int.parse(json['pr_id'].toString());
//     profileImage = json['profile_image'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//     className = json['class_name'];
//     if (json['items'] != null) {
//       items = <Items>[];
//       json['items'].forEach((v) {
//         items!.add(new Items.fromJson(v));
//       });
//     }
//     // Ensure proper parsing with fallback for null values
//     totalScore = int.tryParse(json['total_score'].toString()) ?? 0;
//     averageScore = double.tryParse(json['average_score'].toString()) ?? 0.0;
//     level = double.tryParse(json['level'].toString()) ?? 0.0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['my_class_id'] = this.myClassId;
//     data['pru_id'] = this.pruId;
//     data['pr_id'] = this.prId;
//     data['profile_image'] = this.profileImage;
//     data['firstname'] = this.firstname;
//     data['lastname'] = this.lastname;
//     data['class_name'] = this.className;
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     data['total_score'] = this.totalScore;
//     data['average_score'] = this.averageScore;
//     data['level'] = this.level;
//     return data;
//   }
// }

// class Items {
//   String? name;
//   int? id;
//   String? score;

//   Items({this.name, this.id, this.score});

//   Items.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     id = json['id'];
//     score = json['score'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['score'] = this.score;
//     return data;
//   }
// }
