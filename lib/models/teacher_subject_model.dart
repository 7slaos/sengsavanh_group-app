class TeacherSubjectModel {
  final int scheduleId;
  final int scheduleType;
  final String? term;
  final String? academicYear;
  final int scheduleItemId;
  final String? days;
  final String? startTime;
  final String? endTime;
  final int subjectTeacherId;
  final String? subjectName;
  final int classId;
  final String? className;

  TeacherSubjectModel({
    required this.scheduleId,
    required this.scheduleType,
    required this.scheduleItemId,
    required this.subjectTeacherId,
    required this.classId,
    this.term,
    this.academicYear,
    this.days,
    this.startTime,
    this.endTime,
    this.subjectName,
    this.className,
  });

  factory TeacherSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectModel(
      scheduleId: json['schedule_id'] is int
          ? json['schedule_id']
          : int.tryParse(json['schedule_id']?.toString() ?? '') ?? 0,
      scheduleType: json['schedule_type'] is int
          ? json['schedule_type']
          : int.tryParse(json['schedule_type']?.toString() ?? '') ?? 0,
      term: json['term']?.toString(),
      academicYear: json['academic_year']?.toString(),
      scheduleItemId: json['schedule_item_id'] is int
          ? json['schedule_item_id']
          : int.tryParse(json['schedule_item_id']?.toString() ?? '') ?? 0,
      days: json['days']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      subjectTeacherId: json['subject_teacher_id'] is int
          ? json['subject_teacher_id']
          : int.tryParse(json['subject_teacher_id']?.toString() ?? '') ?? 0,
      subjectName: json['subject_name']?.toString(),
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '') ?? 0,
      className: json['class_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
      'schedule_type': scheduleType,
      'term': term,
      'academic_year': academicYear,
      'schedule_item_id': scheduleItemId,
      'days': days,
      'start_time': startTime,
      'end_time': endTime,
      'subject_teacher_id': subjectTeacherId,
      'subject_name': subjectName,
      'class_id': classId,
      'class_name': className,
    };
  }
}
