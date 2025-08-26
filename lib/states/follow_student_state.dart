// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pathana_school_app/models/follow_student_detail_model.dart';
import 'package:pathana_school_app/models/select_dropdown_model.dart';
import 'package:pathana_school_app/pages/teacher_recordes/follow_student_detail_page.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';

import '../repositorys/repository.dart';

class FollowStudentState extends GetMaterialController {
  final Repository repository = Get.put(Repository());

  List<StudentRecordDropdownModel> allStudentRecords = [];
  List<StudentRecordDropdownModel> studentList = [];
  StudentRecordDropdownModel? selectedStudent;
  List<FollowStudentDetailModels> detailModels = [];
  bool checkDetail = false;
  num totalScore = 0;
  List<String> statusList = [
    'missing_the_morning'.tr, // Morning
    'missing_evening'.tr, // Evening
    'missing_all_day'.tr, // All day
  ];

  // Currently selected status
  String? selectedStatus;

  void updateStatus(String newStatus) {
    selectedStatus = newStatus;
    update(); // Notify listeners
  }

  clearData() {
    selectedStudent = null;
    selectedStatus = null;
    update();
  }

  init() {
    getStudent();
    update();
  }

  /// Fetch dropdown data from the API
  fetchStudentDropdown({String? id}) async {
    var res = await http.post(
      Uri.parse('${repository.urlApi}api/get_student_records'),
      body: {'id': id ?? ''},
    );

    for (var item in jsonDecode(res.body)['data']) {
      allStudentRecords.add(StudentRecordDropdownModel.fromMap(item));
    }
    update();
  }

  getStudent() {
    studentList = [];
    studentList = allStudentRecords;
    studentList = studentList;
    update();
  }

  /// Update the selected student from dropdown
  void updateDropDownStudent(StudentRecordDropdownModel data) {
    selectedStudent = data;
    update(); // Notify UI to rebuild
  }

  ///  start add follow student
  createFollowStudent({
    required BuildContext context,
    required String studentId,
    String? type,
    String? date,
    String? score,
    String? note,
  }) async {
    CustomDialogs().dialogLoading();
    try {
      var respon = await repository.post(
        url: repository.urlApi + repository.followStudents,
        auth: true,
        body: {
          'student_id': studentId.toString(),
          'type': type ?? '',
          'dated': date ?? '',
          'score': score.toString(),
          'note': note ?? '',
        },
      );
      Get.back();
      // print('111111111111111111111111');
      // print(respon.body);
      if (respon.statusCode == 200) {
        //allStudentRecords = [];
        clearData();
        CustomDialogs().showToast(
          backgroundColor: Colors.green.withOpacity(0.5),
          text: 'success',
        );
        Get.to(() => const FollowStudentDetailPage(),
            transition: Transition.leftToRight);
        fetchStudentDropdown();
      } else if (respon.statusCode == 400) {
        CustomDialogs().showToast(
          backgroundColor: Colors.amber.withOpacity(0.5),
          text: 'please_enter_complete_information'.tr,
        );
      }
    } catch (e) {
      // print(e);
      CustomDialogs().showToast(
        backgroundColor: Colors.amber.withOpacity(0.5),
        text: 'something_went_wrong'.tr,
      );
    }
    update();
  }

  /// start get list follow student
  createFollowStudentDetail({String? id, String? startDate, String? endDate}) async {
    try {
      checkDetail = false;
      detailModels = [];
      // Make API request
      var resp = await repository.post(
          url: '${repository.urlApi}${repository.followStudentDetail}',
          auth: true,
          body: {
            'id': id ?? '',
            'start_date': startDate ?? '',
            'end_date': endDate ?? '' 
          });

      if (resp.statusCode == 200) {
        for (var items in jsonDecode(resp.body)['data']) {
          detailModels.add(FollowStudentDetailModels.fromJson(items));
        }
        checkDetail = true;
        sumTotalScore();
      } else {
        CustomDialogs().showToast(
          backgroundColor: Colors.red.withOpacity(0.5),
          text: 'please_enter_complete_information'.tr, // Request error
        );
      }
    } catch (e) {
      // print('Error: $e'); // Log the error
      CustomDialogs().showToast(
        backgroundColor: Colors.amber.withOpacity(0.5),
        text: 'something_went_wrong'.tr, // Something went wrong
      );
    }

    update(); // Notify listeners to update UI
  }

  ///  start sum score
  sumTotalScore() {
    if (detailModels.isNotEmpty) {
      totalScore = detailModels.fold<num>(
        0,
        (sum, detail) => sum + int.parse(detail.score.toString()),
      );
    } else {
      totalScore = 0;
    }

    // Ensures update() is called only after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  /// start remove delete list
  Future<void> removeListId({
    required BuildContext context,
    required int id,
  }) async {
    try {
      // Make the API call
      final response = await repository.post(
        url: '${repository.urlApi}${repository.deleteFollowStudents}',
        auth: true,
        body: {'id': id.toString()},
      );

      // Handle the response
      if (response.statusCode == 200) {
        CustomDialogs().showToast(
          backgroundColor: Colors.green.withOpacity(0.5),
          text: 'delete_successfully',
        );
        detailModels.clear();
        createFollowStudentDetail();
        sumTotalScore();
      } else if (response.statusCode == 404) {
        CustomDialogs().showToast(
          backgroundColor: Colors.red.withOpacity(0.5),
          text: 'no_information_found'.tr,
        );
      }
    } catch (e) {
      CustomDialogs().showToast(
        backgroundColor: Colors.amber.withOpacity(0.5),
        text: 'something_went_wrong'.tr,
      );
    }
    // Trigger a UI update if needed
    update();
  }

  /// update edit list
  updateListFollowStudent({
    int? id, // Include the record ID
    int? studentId,
    int? typeId,
    String? date,
    String? score,
    String? note,
  }) async {
    try {
      // Send the update request
      var response = await repository.post(
        url: repository.urlApi + repository.updateFollowStudents,
        auth: true,
        body: {
          'id': id.toString(), // Include the ID in the request body
          'student_record_id': studentId?.toString() ?? '',
          'type': typeId?.toString() ?? '',
          'dated': date.toString(), // Send the formatted date
          'score': score ?? '',
          'note': note ?? '',
        },
      );

      if (response.statusCode == 200) {
        // Success message
        CustomDialogs().showToast(
          backgroundColor: Colors.green.withOpacity(0.5),
          text: 'success',
        );
        Get.to(() => const FollowStudentDetailPage(),
            transition: Transition.leftToRight);
        // createFollowStudentDetail();
        // sumTotalScore();
        // Get.back();
      } else {
        // Handle errors
        CustomDialogs().showToast(
          backgroundColor: Colors.red.withOpacity(0.5),
          text: 'update_failed'.tr,
        );
      }
    } catch (e) {
      // Handle exceptions
      CustomDialogs().showToast(
        backgroundColor: Colors.amber.withOpacity(0.5),
        text: 'An error occurred.',
      );
      // print('Error: $e');
    } finally {
      update(); // Notify GetX to rebuild UI
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
