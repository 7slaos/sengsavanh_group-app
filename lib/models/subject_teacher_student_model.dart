class SubjectTeacherScheduleMeta {
  final int? id;
  final int? type;
  final String? term;
  final String? academicYear;
  final String? dated;

  SubjectTeacherScheduleMeta({
    this.id,
    this.type,
    this.term,
    this.academicYear,
    this.dated,
  });

  factory SubjectTeacherScheduleMeta.fromJson(Map<String, dynamic> json) {
    return SubjectTeacherScheduleMeta(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      type: json['type'] is int ? json['type'] : int.tryParse(json['type']?.toString() ?? ''),
      term: json['term']?.toString(),
      academicYear: json['academic_year']?.toString(),
      dated: json['dated']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'term': term,
      'academic_year': academicYear,
      'dated': dated,
    };
  }
}

class SubjectTeacherMeta {
  final int subjectTeacherId;
  final int subjectId;
  final String? subjectName;
  final int classId;
  final String? className;
  final SubjectTeacherScheduleMeta? schedule;
  final bool hasSchedule;
  final int? totalStudents;
  final int? year;
  final int? month;
  final String? startDate;
  final String? endDate;

  SubjectTeacherMeta({
    required this.subjectTeacherId,
    required this.subjectId,
    required this.classId,
    this.subjectName,
    this.className,
    this.schedule,
    this.hasSchedule = true,
    this.totalStudents,
    this.year,
    this.month,
    this.startDate,
    this.endDate,
  });

  factory SubjectTeacherMeta.fromJson(Map<String, dynamic> json) {
    return SubjectTeacherMeta(
      subjectTeacherId: json['subject_teacher_id'] is int
          ? json['subject_teacher_id']
          : int.tryParse(json['subject_teacher_id']?.toString() ?? '') ?? 0,
      subjectId: json['subject_id'] is int
          ? json['subject_id']
          : int.tryParse(json['subject_id']?.toString() ?? '') ?? 0,
      subjectName: json['subject_name']?.toString(),
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '') ?? 0,
      className: json['class_name']?.toString(),
      schedule: json['schedule'] != null
          ? SubjectTeacherScheduleMeta.fromJson(json['schedule'] as Map<String, dynamic>)
          : null,
      hasSchedule: json['has_schedule'] == false
          ? false
          : json['has_schedule'] == true || json['has_schedule']?.toString() == 'true',
      totalStudents: json['total_students'] is int
          ? json['total_students']
          : int.tryParse(json['total_students']?.toString() ?? ''),
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? ''),
      month:
          json['month'] is int ? json['month'] : int.tryParse(json['month']?.toString() ?? ''),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_teacher_id': subjectTeacherId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'class_id': classId,
      'class_name': className,
      'schedule': schedule?.toJson(),
      'has_schedule': hasSchedule,
      'total_students': totalStudents,
      'year': year,
      'month': month,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class SubjectTeacherStudent {
  final int studentRecordId;
  final int studentUserId;
  final String? firstname;
  final String? lastname;
  final String? nickname;
  final int? gender;
  final double? score;
  final String? dated;
  final bool hasScore;

  SubjectTeacherStudent({
    required this.studentRecordId,
    required this.studentUserId,
    this.firstname,
    this.lastname,
    this.nickname,
    this.gender,
    this.score,
    this.dated,
    this.hasScore = false,
  });

  factory SubjectTeacherStudent.fromJson(Map<String, dynamic> json) {
    final rawScore = json['score'];
    double? parsedScore;
    if (rawScore != null) {
      parsedScore = double.tryParse(rawScore.toString());
    }
    return SubjectTeacherStudent(
      studentRecordId: json['student_record_id'] is int
          ? json['student_record_id']
          : int.tryParse(json['student_record_id']?.toString() ?? '') ?? 0,
      studentUserId: json['student_user_id'] is int
          ? json['student_user_id']
          : int.tryParse(json['student_user_id']?.toString() ?? '') ?? 0,
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      nickname: json['nickname']?.toString(),
      gender: json['gender'] is int
          ? json['gender']
          : int.tryParse(json['gender']?.toString() ?? ''),
      score: parsedScore,
      dated: json['dated']?.toString(),
      hasScore: json['has_score'] == true || json['has_score']?.toString() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_record_id': studentRecordId,
      'student_user_id': studentUserId,
      'firstname': firstname,
      'lastname': lastname,
      'nickname': nickname,
      'gender': gender,
      'score': score,
      'dated': dated,
      'has_score': hasScore,
    };
  }
}

class SubjectTeacherStudentsResult {
  final SubjectTeacherMeta meta;
  final List<SubjectTeacherStudent> students;
  final bool hasSchedule;
  final int totalStudents;

  SubjectTeacherStudentsResult({
    required this.meta,
    required this.students,
    this.hasSchedule = true,
    this.totalStudents = 0,
  });
}
