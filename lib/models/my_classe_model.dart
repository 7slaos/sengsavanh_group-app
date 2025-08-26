class MyClasseModels {
  int? id;
  String? name;
  int? classGroupId;
  int? teacherRecordsId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  TeacherRecords? teacherRecords;

  MyClasseModels(
      {this.id,
      this.name,
      this.classGroupId,
      this.teacherRecordsId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.teacherRecords});

  MyClasseModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    classGroupId = json['class_group_id'];
    teacherRecordsId = json['teacher_records_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    teacherRecords = json['teacher_records'] != null
        ? new TeacherRecords.fromJson(json['teacher_records'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['class_group_id'] = this.classGroupId;
    data['teacher_records_id'] = this.teacherRecordsId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.teacherRecords != null) {
      data['teacher_records'] = this.teacherRecords!.toJson();
    }
    return data;
  }
}

class TeacherRecords {
  int? id;
  int? userId;
  int? srSalaryId;
  String? educationSystem;
  String? educationLevel;
  String? specialSubject;
  String? finishSchool;
  String? yearSystemLearn;
  int? yearFinished;
  String? stayAt;
  String? duty;
  String? note;
  int? status;
  String? createdAt;
  String? updatedAt;

  TeacherRecords(
      {this.id,
      this.userId,
      this.srSalaryId,
      this.educationSystem,
      this.educationLevel,
      this.specialSubject,
      this.finishSchool,
      this.yearSystemLearn,
      this.yearFinished,
      this.stayAt,
      this.duty,
      this.note,
      this.status,
      this.createdAt,
      this.updatedAt});

  TeacherRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    srSalaryId = json['sr_salary_id'];
    educationSystem = json['education_system'];
    educationLevel = json['education_level'];
    specialSubject = json['special_subject'];
    finishSchool = json['finish_school'];
    yearSystemLearn = json['year_system_learn'];
    yearFinished = json['year_finished'];
    stayAt = json['stay_at'];
    duty = json['duty'];
    note = json['note'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['sr_salary_id'] = this.srSalaryId;
    data['education_system'] = this.educationSystem;
    data['education_level'] = this.educationLevel;
    data['special_subject'] = this.specialSubject;
    data['finish_school'] = this.finishSchool;
    data['year_system_learn'] = this.yearSystemLearn;
    data['year_finished'] = this.yearFinished;
    data['stay_at'] = this.stayAt;
    data['duty'] = this.duty;
    data['note'] = this.note;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}