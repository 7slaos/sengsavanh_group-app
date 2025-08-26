class FollowStudentDetailModels {
  int? id;
  String? score;
  int? type;
  String? dated;
  String? note;
  int? stuId;
  int? useId;
  String? firstname;
  String? lastname;
  String? createFullname;
  String? createLastname;

  FollowStudentDetailModels(
      {this.id,
      this.score,
      this.type,
      this.dated,
      this.note,
      this.stuId,
      this.useId,
      this.firstname,
      this.lastname,
      this.createFullname,
      this.createLastname});

  FollowStudentDetailModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    score = json['score'];
    type = json['type'];
    dated = json['dated'];
    note = json['note'];
    stuId = json['stu_id'];
    useId = json['use_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    createFullname = json['create_fullname'];
    createLastname = json['create_lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['score'] = score;
    data['type'] = type;
    data['dated'] = dated;
    data['note'] = note;
    data['stu_id'] = stuId;
    data['use_id'] = useId;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['create_fullname'] = createFullname;
    data['create_lastname'] = createLastname;
    return data;
  }

  @override
  String toString() {
    return 'FollowStudentDetailModels(id: $id, firstname: $firstname, lastname: $lastname, type: $type, dated: $dated, score: $score, note: $note, stuId: $stuId, useId: $useId, createFullname: $createFullname, createLastname: $createLastname)';
  }
}
