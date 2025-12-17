import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/models/my_classe_model.dart';
import 'package:multiple_school_app/models/score_children_model.dart';
import 'package:multiple_school_app/models/score_list_model.dart';
import 'package:multiple_school_app/models/score_student_model.dart';
import 'package:multiple_school_app/models/student_score_model.dart';
import 'package:multiple_school_app/models/subject_model.dart';
import 'package:multiple_school_app/models/subject_teacher_student_model.dart';
import 'package:multiple_school_app/models/teacher_subject_model.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScoreState extends GetxController {
  Repository repository = Repository();
  List<MyClasseModels> classeList = [];
  List<MyClasseModels> allCLasseList = [];
  List<SubjectModels> submodelsList = [];
  List<SubjectModels> allsubjects = [];
  List<TextEditingController> qtyControllers = [];
  List<StudentScoreModels> studentScoreList = [];
  List<ScoreListModels> scoreListModel = [];
  SubjectModels? updateSubject;
  List<ScoreChildrenModels> scoreChildrenModels = [];
  List<ScoreStudentModels> scoreStudentModels = [];
  bool checkClasse = false;
  bool checkStudenScore = false;
  bool checkScoreList = false;
  bool checkStudentScoreList = false;
  bool checkscoreChildren = false;
  bool checkMyOwnScore = false;
  bool loadingTeacherSubjects = false;
  List<TeacherSubjectModel> teacherSubjects = [];
  Map<int, SubjectTeacherStudentsResult> subjectTeacherStudents = {};
  Map<int, bool> loadingSubjectTeacherStudents = {};
  Set<int> fetchedSubjectTeacherIds = {};
  bool savingTeacherScores = false;

  getAllScore(String? id, String monthly) {
    getMyClasses();
    getTotalScore(id, monthly);
  }

  void resetTeacherSubjects() {
    teacherSubjects = [];
    clearSubjectTeacherStudentsCache();
    loadingTeacherSubjects = false;
    update();
  }

  void clearSubjectTeacherStudentsCache() {
    subjectTeacherStudents = {};
    loadingSubjectTeacherStudents = {};
    fetchedSubjectTeacherIds = {};
    update();
  }

  Future<void> fetchTeacherSubjects({
    required int scheduleType,
    required int year,
    required int month,
  }) async {
    loadingTeacherSubjects = true;
    teacherSubjects = [];
    update();
    try {
      final uri = Uri.parse(
        '${repository.nuXtJsUrlApi}${repository.teacherSubjectsByScheduleType}',
      ).replace(queryParameters: {
        'type': scheduleType.toString(),
        'year': year.toString(),
        'month': month.toString(),
      });

      final response = await repository.get(url: uri.toString(), auth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final data = decoded['data_list'] as List? ?? [];
        teacherSubjects = data
            .map((item) => TeacherSubjectModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList();
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
    loadingTeacherSubjects = false;
    update();
  }

  Future<void> fetchSubjectTeacherStudents({
    required int subjectTeacherId,
    int? scheduleId,
    required int year,
    required int month,
    bool force = false,
  }) async {
    if (!force && fetchedSubjectTeacherIds.contains(subjectTeacherId)) {
      return;
    }
    fetchedSubjectTeacherIds.add(subjectTeacherId);
    loadingSubjectTeacherStudents[subjectTeacherId] = true;
    update();
    try {
      final params = {
        'subject_teacher_id': subjectTeacherId.toString(),
        'year': year.toString(),
        'month': month.toString(),
        if (scheduleId != null && scheduleId > 0) 'schedule_id': scheduleId.toString(),
      };

      final uri = Uri.parse(
        '${repository.nuXtJsUrlApi}${repository.studentsBySubjectTeacher}',
      ).replace(queryParameters: params);

      final response = await repository.get(url: uri.toString(), auth: true);
      if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final meta = SubjectTeacherMeta.fromJson(
        Map<String, dynamic>.from(decoded['meta'] ?? {}),
      );
      final list = (decoded['data_list'] as List? ?? [])
          .map((item) => SubjectTeacherStudent.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
      subjectTeacherStudents[subjectTeacherId] = SubjectTeacherStudentsResult(
        meta: meta,
        students: list,
        hasSchedule: meta.hasSchedule,
        totalStudents: meta.totalStudents ?? list.length,
      );
    }
  } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
    loadingSubjectTeacherStudents[subjectTeacherId] = false;
    update();
  }

  Future<bool> saveTeacherScores({
    required SubjectTeacherStudentsResult subjectData,
    required Map<int, String> scores,
    String? datedOverride,
  }) async {
    if (savingTeacherScores) return false;
    savingTeacherScores = true;
    update();
    bool success = false;
    try {
      final payload = scores.entries
          .map((e) => {
                'studentId': e.key,
                'qty': e.value,
              })
          .toList();
      final meta = subjectData.meta;
      final subjectId = meta.subjectId;
      final now = DateTime.now();
      String dateStr = DateFormat('yyyy-MM-dd').format(now);
      if (datedOverride != null && datedOverride.isNotEmpty) {
        dateStr = datedOverride;
      }

      if (subjectId == null || subjectId == 0) {
        CustomDialogs().showToast(
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'something_went_wrong'.tr,
        );
        savingTeacherScores = false;
        update();
        return false;
      }

      if (kDebugMode) {
        print('[SAVE TEACHER SCORES] subject_teacher_id=${meta.subjectTeacherId}, '
            'subject_id=$subjectId, date=$dateStr, count=${payload.length}');
        print('[SAVE TEACHER SCORES] payload: ${jsonEncode(payload)}');
      }

      final res = await repository.post(
        url: '${repository.nuXtJsUrlApi}${repository.saveTeacherScores}',
        auth: true,
        body: {
          'subject_teacher_id': meta.subjectTeacherId.toString(),
          'subject_id': subjectId.toString(),
          'schedule_id': meta.schedule?.id?.toString() ?? '',
          'scores': jsonEncode(payload),
          'dated': dateStr,
        },
      );
      if (kDebugMode) {
        final text = (() {
          try {
            return utf8.decode(res.bodyBytes);
          } catch (_) {
            return res.body;
          }
        })();
        print('[SAVE TEACHER SCORES] status=${res.statusCode}, response=$text');
      }
      if (res.statusCode == 200) {
        success = true;
        CustomDialogs().showToast(
          backgroundColor: AppColor().green.withOpacity(0.8),
          text: 'ໃຫ້ຄະແນນສຳເລັດ',
        );
        // Refresh the cache for this subject to reflect saved data
        fetchedSubjectTeacherIds.remove(meta.subjectTeacherId);
        final parsedDate = DateTime.tryParse(dateStr);
        final refreshYear = meta.year ?? parsedDate?.year;
        final refreshMonth = meta.month ?? parsedDate?.month;
        if (refreshYear != null && refreshMonth != null) {
          await fetchSubjectTeacherStudents(
            subjectTeacherId: meta.subjectTeacherId,
            scheduleId: meta.schedule?.id,
            year: refreshYear,
            month: refreshMonth,
            force: true,
          );
        }
      } else {
        CustomDialogs().showToast(
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'something_went_wrong'.tr,
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    savingTeacherScores = false;
    update();
    return success;
  }

  clearSubject() {
    updateSubject = null;
    allsubjects = [];
    update();
  }

  getMyClasses() async {
    try {
      checkClasse = false;
      classeList = [];

      var response = await repository.get(
          url: repository.nuXtJsUrlApi + repository.getMyClasse, auth: true);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        for (var items in decoded['data']) {
          classeList.add(MyClasseModels.fromJson(items));
        }
      } else {
        throw response;
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
    checkClasse = true;
    update();
  }

  getAllMyClasses() async {
    try {
      checkClasse = false;
      allCLasseList = [];

      var response = await repository.get(
          url: '${repository.nuXtJsUrlApi}api/Application/AboutScoreController/getAllMyClass', auth: true);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        for (var items in decoded['data']) {
          allCLasseList.add(MyClasseModels.fromJson(items));
        }
      } else {
        throw response;
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong',
      );
    }
    checkClasse = true;
    update();
  }

  getSubjectDropdown({String? id}) async {
    submodelsList = [];
    var res = await repository.post(
        url: repository.nuXtJsUrlApi + repository.getSubjects,
        auth: true,
        body: {'id': id ?? ''});

    if (res.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      for (var item in decoded['data']) {
        submodelsList.add(SubjectModels.fromMap(item));
      }
    }
    update();
  }

  selectSubject() {
    allsubjects = submodelsList;
    update(); // Notify listeners to rebuild the UI
  }

  void updateDropDownSubjects(SubjectModels subjectModels) {
    updateSubject = subjectModels;
    update();
  }

  List<Map<String, dynamic>> studentQtyData =
      []; // Store both qty and studentId

  getStudentList({String? id, String? subjectId, String? date}) async {
    try {
      checkStudenScore = false;
      studentScoreList = [];
      studentQtyData = []; // Reset the studentQtyData list

      var resp = await repository.post(
        url: repository.nuXtJsUrlApi + repository.studentScore,
        auth: true,
        body: {
          'id': id ?? '',
          'subject_id': subjectId ?? '0',
          'date': date ?? '',
        },
      );

      if (resp.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(resp.bodyBytes));

        if (responseData['data'] != null) {
          for (var item in responseData['data']) {
            studentScoreList.add(StudentScoreModels.fromJson(item));
          }
          checkStudenScore = true;

          qtyControllers = List.generate(studentScoreList.length, (index) {
            String qty = studentScoreList[index].score ?? '';
            if (studentScoreList[index].score == null ||
                studentScoreList[index].score.toString() == 'null') {
              qty = '';
            }
            return TextEditingController(
                text: qty); // Initialize with empty text
          });

          // Initialize studentQtyData to pair studentId and qty
          studentQtyData = studentScoreList.map((student) {
            return {
              'studentId':
                  student.id, // Assuming the student model has an id field
              'qty': student.score.toString(), // Initial empty value for qty
            };
          }).toList();
        }
      } else {
        // Log the error and show a user-friendly message
        var errorMessage = jsonDecode(utf8.decode(resp.bodyBytes))['message'] ??
            'Unknown error occurred';
        // print('Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      // print(e);
      CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'ກະລຸນາເພີ່ມນັກຮຽນກ່ອນ');
    }

    update();
  }

  String formatDate(String date) {
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
    String formattedDate = DateFormat('MM/yyyy').format(parsedDate);
    return formattedDate;
  }

  saveScoreStudent(
      {required BuildContext context,
      required String subjectId,
      required String myClassId,
      required String date}) async {
    CustomDialogs().dialogLoading();
    try {
      var response = await repository.post(
        url: '${repository.nuXtJsUrlApi}${repository.saveScoreStudent}',
        auth: true,
        body: {
          'subjectId': subjectId,
          'studentScores': jsonEncode(
              studentQtyData), // No need for jsonEncode if the backend handles array decoding
          'date': date,
        },
      );
      Get.back();
      // print('11111111111111111111111111111111111111111');
      // print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        submodelsList.clear();
        studentScoreList.clear();
        updateSubject = null;
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().green.withOpacity(0.8),
          text: 'score_added_successfully'.tr,
        );
        Get.back();
        Get.back();
        getTotalScore(myClassId, formatDate(date));
      } else {
        CustomDialogs().showToast(
          // ignore: deprecated_member_use
          backgroundColor: AppColor().black.withOpacity(0.8),
          text: 'something_went_wrong'.tr,
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  // ສິດອາຈານ
  getTotalScore(String? classId, String monthly) async {
    // Future.delayed(const Duration(seconds: 5));
    try {
      checkScoreList = false;
      scoreListModel = [];

      var resUpdate = await repository.post(
        url: repository.nuXtJsUrlApi + repository.totalScore,
        auth: true,
        body: {
          'classId': classId.toString(),
          'monthly': monthly.toString(), // Verify this is being populated
        },
      );
      // print(resUpdate.body);
      if (resUpdate.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(resUpdate.bodyBytes));
        for (var item in decoded['data']) {
          scoreListModel.add(ScoreListModels.fromJson(item));
        }
        scoreListModel
            .sort((a, b) => b.averageScore!.compareTo(a.averageScore!));
        checkScoreList = true;
      }
    } catch (e) {
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

//ສິດພໍ່ແມ່
  getScoreViewChildren({String? monthly}) async {
    try {
      checkscoreChildren = false;
      scoreChildrenModels = [];
      update();
      var res = await repository.post(
          url: repository.nuXtJsUrlApi + repository.scoreChildren,
          auth: true,
          body: {
            'monthly': monthly ?? '',
          });
      // print(jsonDecode(res.body));
      // print('00000000000000000000000000000000000000000000000000000');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(res.bodyBytes));
        for (var item in decoded['data']) {
          scoreChildrenModels.add(ScoreChildrenModels.fromJson(item));
        }
        checkscoreChildren = true;
      }
      update();
    } catch (e,stackTrace) {
      // print(stackTrace);
      // print('88888888888888888888888888888888888');
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
    }
  }

// ສິດ ນັກຮຽນ ຫືຼ ລູກ
  getScoreStudent({String? monthly}) async {
    try {
      checkMyOwnScore = false;
      scoreStudentModels = [];
      update();
      final response = await repository.post(
          url: repository.nuXtJsUrlApi + repository.scoreStudent,
          auth: true,
          body: {
            'monthly': monthly ?? '',
          });
      // print('Response: ${response.body}');
      // print('Fetching student scores completed.');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        for (var item in decoded['data']) {
          scoreStudentModels.add(ScoreStudentModels.fromJson(item));
        }
      }
      checkMyOwnScore = true;
      update();
    } catch (e, stackTrace) {
      // print('Error: $e');
      // print('11111111111111111111111111');
      // print(stackTrace);
      CustomDialogs().showToast(
        // ignore: deprecated_member_use
        backgroundColor: AppColor().red.withOpacity(0.8),
        text: 'something_went_wrong', // Error loading data
      );
    }
  }
}
