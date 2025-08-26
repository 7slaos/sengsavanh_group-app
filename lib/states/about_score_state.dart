import 'package:intl/intl.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/models/my_classe_model.dart';
import 'package:pathana_school_app/models/score_children_model.dart';
import 'package:pathana_school_app/models/score_list_model.dart';
import 'package:pathana_school_app/models/score_student_model.dart';
import 'package:pathana_school_app/models/student_score_model.dart';
import 'package:pathana_school_app/models/subject_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
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

  getAllScore(String? id, String monthly) {
    getMyClasses();
    getTotalScore(id, monthly);
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
          url: repository.urlApi + repository.getMyClasse, auth: true);

      if (response.statusCode == 200) {
        for (var items in jsonDecode(response.body)['data']) {
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
          url: '${repository.urlApi}api/getAllMyClass', auth: true);

      if (response.statusCode == 200) {
        for (var items in jsonDecode(response.body)['data']) {
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
        url: repository.urlApi + repository.getSubjects,
        auth: true,
        body: {'id': id ?? ''});

    if (res.statusCode == 200) {
      for (var item in jsonDecode(res.body)['data']) {
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
        url: repository.urlApi + repository.studentScore,
        auth: true,
        body: {
          'id': id ?? '',
          'subject_id': subjectId ?? '0',
          'date': date ?? '',
        },
      );

      if (resp.statusCode == 200) {
        var responseData = jsonDecode(resp.body);

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
        var errorMessage =
            jsonDecode(resp.body)['message'] ?? 'Unknown error occurred';
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
        url: '${repository.urlApi}${repository.saveScoreStudent}',
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
        url: repository.urlApi + repository.totalScore,
        auth: true,
        body: {
          'classId': classId.toString(),
          'monthly': monthly.toString(), // Verify this is being populated
        },
      );
      // print(resUpdate.body);
      if (resUpdate.statusCode == 200) {
        for (var item in jsonDecode(resUpdate.body)['data']) {
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
          url: repository.urlApi + repository.scoreChildren,
          auth: true,
          body: {
            'monthly': monthly ?? '',
          });
      // print(jsonDecode(res.body));
      // print('00000000000000000000000000000000000000000000000000000');
      if (res.statusCode == 200) {
        for (var item in jsonDecode(res.body)['data']) {
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
          url: repository.urlApi + repository.scoreStudent,
          auth: true,
          body: {
            'monthly': monthly ?? '',
          });
      // print('Response: ${response.body}');
      // print('Fetching student scores completed.');
      if (response.statusCode == 200) {
        for (var item in jsonDecode(response.body)['data']) {
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
