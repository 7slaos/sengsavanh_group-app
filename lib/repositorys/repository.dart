import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_school_app/pages/login_page.dart';


import '../states/appverification.dart';

export 'dart:convert';

class Repository {
  String nuXtJsUrlApi = 'https://www.citschool.net/';
  // String nuXtJsUrlApi = 'http://192.168.100.230:3000/';
  String getFunctionAvailableByRole = 'api/get_function_available_by_role';
  String loginUser = 'api/Application/login_users';
  String logoutUser = 'api/Application/LoginApiController/logouts';
  String getProfiled = 'api/Application/LoginApiController/get_Profileds';
  String updateProfiled = 'api/Application/LoginApiController/update_Profiled_Parents';
  String parentDashboard = 'api/Application/HomeParentComponent/DashboardParentRecorde';
  String parentHomeStudentList = 'api/Application/HomeParentComponent/HomeParent_and_StudentList';
  String scoreChildren = 'api/Application/AboutScoreController/score_children';
  String getDataListStudent = 'api/Application/DashboardComponent/get_list_students';
  String getProfileStudentRecord = 'api/Application/LoginApiController/get_student_profiled';
  String updateProfileStudentRecord = 'api/Application/LoginApiController/update_profiled_studentrecord';
  String dashboardStudentRecorde = 'api/Application/DashboardComponent/Dashboard_student';
  String countId = 'api/Application/HomeParentComponent/counts';
  String authNameSchool = 'api/Application/HomeParentComponent/AuthUserName';
  String dashboardTeacherRecorde = 'api/Application/DashboardComponent/Dashboard_teacher';
  String teacherRecordePofiled = 'api/Application/LoginApiController/get_TeacherRecorde_Profiled';
  String updateTeacherRecorde = 'api/Application/LoginApiController/update_profiled_teacherrecord';
  // Check-in/out student group
  String checkInOutBase = 'api/Application/checkin-out-student';
  String checkStudent = 'api/Application/checkin-out-student/check_student';
  String checkInStudent = 'api/Application/checkin-out-student/check_in';
  String getCheckInOutSettingTime = 'api/Application/checkin-out-student/get_check_in_out_setting_time';
  // Nuxt LoginApiController endpoints
  String loginRegisterStudent = 'api/Application/LoginApiController/register_student';
  String loginRegisterSchool = 'api/Application/LoginApiController/register_school';
  String loginGetPackages = 'api/Application/LoginApiController/get_packages';
  String loginSaveTokenUser = 'api/Application/LoginApiController/savetokenUser';
  String loginUpdateImagesProfileStudent = 'api/Application/LoginApiController/update_images_profile_student';
  String loginDeleteAccount = 'api/Application/LoginApiController/delete_account';
  String loginGetRegisters = 'api/Application/LoginApiController/get_registers';
  String loginConfirmRegisterStudent = 'api/Application/LoginApiController/confirm_register_student';
  String loginUpdateAdminProfile = 'api/Application/LoginApiController/update_admin_profile';
  String loginDeleteTokenDevices = 'api/Application/LoginApiController/deleteTokenDevices';

  // String logoutTeacher = 'api/logout_teacher';
  String aboutScoreBase = 'api/Application/AboutScoreController';
  String getAllMyClass = 'api/Application/AboutScoreController/getAllMyClass';
  String getMyClasse = 'api/Application/AboutScoreController/getMyClass';
  String getSubjects = 'api/Application/AboutScoreController/getSubject';
  String studentScore = 'api/Application/AboutScoreController/student_score';
  String saveScoreStudent = 'api/Application/AboutScoreController/SaveScoreStudent';
  String scoreStudent = 'api/Application/AboutScoreController/score_list_student';
  String totalScore = 'api/Application/AboutScoreController/total_score';
  String followStudents = 'api/follow_student_records';
  String followStudentDetail = 'api/follow_student_rercod_details';
  String deleteFollowStudents = 'api/deleteFollowStudents';
  String updateFollowStudents = 'api/updateFollowStudents';
  // String getStudentDropwon = 'api/get_student_records';

  //gdev
  // PaymentApiController group
  String paymentBase = 'api/Application/PaymentApiController';
  String updatePayment = 'api/Application/PaymentApiController/updatePayment';
  String updatePaymentCash = 'api/Application/PaymentApiController/updatePaymentCash';
  String callStudents = 'api/Application/PaymentApiController/call_students';
  String allCallStudents = 'api/Application/PaymentApiController/all_call_students';
  String tearchconfirmcallStudent = 'api/Application/PaymentApiController/teach_confirm_send_student';
  String checkRolePermission = 'api/Application/PaymentApiController/check_role_permission';
  String updateTransactionIdPayment = 'api/Application/PaymentApiController/update_transactionId_payment';
  String checkPaymentTransaction = 'api/Application/PaymentApiController/checkPaymentTransaction';
  String bankPayments = 'api/Application/PaymentApiController/bankPayments';

  // ExpenseApiController group
  String expenseBase = 'api/Application/ExpenseApiController';
  String expenseCategory = 'api/Application/ExpenseApiController/epxense_category';
  String expenseStore = 'api/Application/ExpenseApiController/store_expense';

  // DashboardComponent group
  String dashboardBase = 'api/Application/DashboardComponent';

  // GetDropdownController group
  String dropdownBase = 'api/Application/GetDropdownController';
  String dropdownGetStudentRecord = 'api/Application/GetDropdownController/get_student_record';

  // AdminSchoolController group
  String adminSchoolBase = 'api/Application/AdminSchoolController';
  String adminGetAdminSchools = 'api/Application/AdminSchoolController/get_admin_schools';
  String adminGetAdminSchoolsDashboard = 'api/Application/AdminSchoolController/get_admin_schools_dashboard';
  String adminGetAllSchools = 'api/Application/AdminSchoolController/get_all_schools';
  String adminUpdateBranchByAdmin = 'api/Application/AdminSchoolController/update_branch_by_admin';
  String adminTuitionFee = 'api/Application/AdminSchoolController/admin_tuition_fee';
  String adminExpenses = 'api/Application/AdminSchoolController/admin_expenses';
  String adminStudents = 'api/Application/AdminSchoolController/admin_students';
  String adminGetSettingPayment = 'api/Application/AdminSchoolController/get_setting_payment';
  String adminPaymentPackage = 'api/Application/AdminSchoolController/admin_payment_package';
  String adminGetStudentCount = 'api/Application/AdminSchoolController/getStudentCount';
  String adminGetTotalLog = 'api/Application/AdminSchoolController/getTotalLog';
  String adminGetTotalAll = 'api/Application/AdminSchoolController/getTotalAll';
  String adminGetTotalDebt = 'api/Application/AdminSchoolController/getTotalDebt';
  String adminGetTotalIncome = 'api/Application/AdminSchoolController/getTotalIncome';
  String adminGetTotalExpense = 'api/Application/AdminSchoolController/getTotalExpense';

  // SuperAdminApiController group
  String superAdminBase = 'api/Application/SuperAdminApiController';
  String superAdminGetSchoolPayPackages = 'api/Application/SuperAdminApiController/get_school_pay_packages';
  String superAdminPushCheckInOut = 'api/Application/SuperAdminApiController/check_in_check_out_push_notification_to_users';

  // Public store device token (Nuxt)
  String saveDeviceToken = 'api/Application/store_s_chool_app_user';
  String parentFollowStudent = 'api/parent_follow_student_record_detail';
  String scancheckstudentBarcode = 'api/scan_scheck_student';
  //admin school
  String getadminschoolProfile = 'api/get_admin_school_profile';
  //end

  //NUXT API
  String GetSubjectByTeacher =
      'api/api_for_app/mark_student/get_subject_by_teacher';
  String GetStudentBySubject =
      'api/api_for_app/mark_student/get_student_by_subjects';
  String CheckMissingSchools =
      'api/api_for_app/mark_student/check_missing_schools';
  String GetCheckMissingSchools =
      'api/api_for_app/mark_student/get_check_missing_schools';
  String EditCheckMissingStudent =
      'api/api_for_app/mark_student/edit_check_missing_student';
  String DeleteCheckMissing =
      'api/api_for_app/mark_student/delete_check_missing';
  String GetMarkStatus = 'api/api_for_app/mark_student/get_mark_status';
  String GetHistoryCheckInOut = 'api/api_for_app/mark_student/get_history_check_in_out';
  String GetStudentMissingSchool = 'api/api_for_app/mark_student/get_student_missing_school';
  String teacherSubjectsByScheduleType =
      'api/Application/TeacherScoreController/subjects_by_schedule_type';
  String studentsBySubjectTeacher =
      'api/Application/TeacherScoreController/students_by_subject_teacher';
  String saveTeacherScores =
      'api/Application/TeacherScoreController/save_scores';
  AppVerification appVerification = Get.put(AppVerification());
  Future<http.Response> get(
      {required String url, Map<String, String>? header, bool? auth}) async {
    try {
      if (kDebugMode) {
        print('[GET] ' + url);
      }
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (auth ?? false)
          'Authorization':
              'Bearer ' + ((appVerification.nUxtToken.isNotEmpty)
                  ? appVerification.nUxtToken
                  : appVerification.token)
      };
      var res = await http
          .get(Uri.parse(url), headers: header ?? defaultHeaders)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });
      if (kDebugMode) {
        final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
        print('[GET] status: ${res.statusCode}');
        print('[GET] response: ' + text);
      }
      if (res.statusCode == 401 || res.statusCode == 408) {
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }

      return res;
    } catch (e) {
      // please comment print line before release
      // print(e);
      return http.Response("error", 503);
    }
  }

  Future<http.Response> post(
      {required String url,
        Map<String, String>? header,
        Map<String, String>? body,
        bool? auth}) async {
    try {
      if (kDebugMode) {
        print('[POST] ' + url);
        // Avoid logging secrets
        final raw = jsonEncode(body);
        final redacted = raw.replaceAll(RegExp(r'"password"\s*:\s*".*?"'), '"password":"***"');
        print('[POST] body: ' + redacted);
      }
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (auth ?? false)
          'Authorization':
              'Bearer ' + ((appVerification.nUxtToken.isNotEmpty)
                  ? appVerification.nUxtToken
                  : appVerification.token)
      };
      var res = await http
          .post(Uri.parse(url),
          body: jsonEncode(body),
          headers: header ?? defaultHeaders)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });
      if (kDebugMode) {
        final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
        print('[POST] status: ${res.statusCode}');
        print('[POST] response: ' + text);
      }
      if (res.statusCode == 401) {
        appVerification.storage.erase();
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }
      return res;
    } catch (e) {
      // please comment print line before release
      // print(e);
      return http.Response("error", 503);
    }
  }

  Future<http.Response> put(
      {required String url, Map<String, String>? header, bool? auth}) async {
    try {
      var res = await http
          .put(Uri.parse(url),
          headers: header ??
              {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                if (auth ?? false)
                  'Authorization': 'Bearer ${appVerification.token}'
              })
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });
      if (res.statusCode == 401) {
        appVerification.storage.erase();
        // Get.off(() => const LoginPage(
        //       status: 1,
        //     ));
        return res;
      }
      return res;
    } catch (e) {
      // please comment print line before release
      // print(e);
      return http.Response("error", 503);
    }
  }

  Future<http.Response> delete(
      {required String url, Map<String, String>? header, bool? auth}) async {
    try {
      var res = await http
          .delete(Uri.parse(url),
          headers: header ??
              {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                if (auth ?? false)
                  'Authorization': 'Bearer ${appVerification.token}'
              })
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });
      if (res.statusCode == 401) {
        appVerification.storage.erase();
        // Get.off(() => const LoginPage(
        //       status: 1,
        //     ));
        return res;
      }
      return res;
    } catch (e) {
      // please comment print line before release
      // print(e);
      return http.Response("error", 503);
    }
  }

// ====== API NUXT JS
  Future<http.Response> postNUxt(
      {required String url,
        Map<String, String>? header,
        Map<String, dynamic>? body, // ✅ เปลี่ยนตรงนี้
        bool? auth}) async {
    try {
      if (kDebugMode) {
        // Redact password if present
        final raw = jsonEncode(body);
        final redacted = raw.replaceAll(RegExp(r'"password"\s*:\s*".*?"'), '"password":"***"');
        print('[POST] $url');
        print('[POST] body: ' + redacted);
      }

      var res = await http
          .post(Uri.parse(url),
          body: jsonEncode(body),
          headers: header ??
              {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                if (auth ?? false)
                  'Authorization': 'Bearer ${appVerification.nUxtToken}'
              })
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });
      if (kDebugMode) {
        final text = (() { try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; } })();
        print('[POST] status: ${res.statusCode}');
        print('[POST] response: ' + text);
      }
      if (res.statusCode == 401 || res.statusCode == 403) {
        appVerification.storage.erase();
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }
      return res;
    } catch (e) {
      // please comment print line before release
      // print(e);
      return http.Response("error", 503);
    }
  }

  Future<http.Response> getNUxt({
    required String url,
    Map<String, String>? header,
    bool? auth,
  }) async {
    try {
      var res = await http
          .get(
        Uri.parse(url),
        headers: header ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (auth ?? false)
                'Authorization': 'Bearer ${appVerification.nUxtToken}'
            },
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });

      if (res.statusCode == 401 || res.statusCode == 403) {
        appVerification.storage.erase();
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }
      return res;
    } catch (e) {
      return http.Response("error", 503);
    }
  }

  Future<http.Response> putNUxt({
    required String url,
    Map<String, String>? header,
    Map<String, dynamic>? body,
    bool? auth,
  }) async {
    try {
      var res = await http
          .put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: header ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (auth ?? false)
                'Authorization': 'Bearer ${appVerification.nUxtToken}'
            },
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });

      if (res.statusCode == 401 || res.statusCode == 403) {
        appVerification.storage.erase();
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }
      return res;
    } catch (e) {
      return http.Response("error", 503);
    }
  }

  Future<http.Response> deleteNUxt({
    required String url,
    Map<String, String>? header,
    bool? auth,
  }) async {
    try {
      var res = await http
          .delete(
        Uri.parse(url),
        headers: header ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (auth ?? false)
                'Authorization': 'Bearer ${appVerification.nUxtToken}'
            },
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response("Error", 408);
      });

      if (res.statusCode == 401 || res.statusCode == 403) {
        appVerification.storage.erase();
        appVerification.removeToken();
        Get.offAll(() => const LoginPage());
        return res;
      }
      return res;
    } catch (e) {
      return http.Response("error", 503);
    }
  }

  Future<Map<String, dynamic>> getSubjectByTeacherAPI() async {
    final res = await getNUxt(
      url: "$nuXtJsUrlApi$GetSubjectByTeacher",
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
    );

    if (res.statusCode == 200) {
      // ✅ decode UTF-8 ก่อน
      final decodedBody = utf8.decode(res.bodyBytes);
      return jsonDecode(decodedBody); // ✅ ใช้ decodedBody
    } else {
      throw Exception("Failed to fetch subjects: ${res.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getStudentBySubjectAPI(
      int subjectTeacherId) async {
    final res = await getNUxt(
      url:
      "$nuXtJsUrlApi$GetStudentBySubject?subject_teacher_id=$subjectTeacherId",
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
    );

    if (res.statusCode == 200) {
      // ✅ decode UTF-8 ก่อน
      final decodedBody = utf8.decode(res.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception("Failed to fetch students: ${res.statusCode}");
    }
  }

  Future<Map<String, dynamic>> saveCheckStudentAPI(
      Map<String, dynamic> payload,
      ) async {
    try {
      final url = Uri.parse("$nuXtJsUrlApi$CheckMissingSchools");

      // ✅ Debug Payload ก่อนส่ง
      print("📤 Sending to API: $payload");

      final token = appVerification.nUxtToken;
      if (token == null || token.isEmpty) {
        return {"success": false, "message": "Token not found"};
      }

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ แนบ token
        },
        body: jsonEncode(payload), // ✅ ส่ง JSON
      );

      print("🔹 Response code: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      // ✅ เช็คผลลัพธ์
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          return {
            "success": false,
            "message": "Invalid JSON response",
            "raw": response.body
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
          "raw": response.body
        };
      }
    } catch (e) {
      return {"success": false, "message": "Exception: $e"};
    }
  }

  /// GET /api/api_for_app/mark_student/get_check_missing_schools
  /// - date (DateTime) -> sent as "YYYY-MM-DD"
  Future<Map<String, dynamic>> getCheckMissingSchools({
    int? scheduleItemsId,
    DateTime? date,
  }) async {
    // build base + path safely
    final base = nuXtJsUrlApi.endsWith('/')
        ? nuXtJsUrlApi.substring(0, nuXtJsUrlApi.length - 1)
        : nuXtJsUrlApi;
    final path = GetCheckMissingSchools.startsWith('/')
        ? GetCheckMissingSchools.substring(1)
        : GetCheckMissingSchools;

    // query params
    final qp = <String, String>{};
    if (scheduleItemsId != null) qp['schedule_items_id'] = '$scheduleItemsId';
    if (date != null) {
      final y = date.year.toString().padLeft(4, '0');
      final m = date.month.toString().padLeft(2, '0');
      final d = date.day.toString().padLeft(2, '0');
      qp['date'] = '$y-$m-$d';
    }

    final uri = Uri.parse('$base/$path').replace(
      queryParameters: qp.isEmpty ? null : qp,
    );

    // headers
    final token = appVerification.nUxtToken;
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final res = await getNUxt(url: uri.toString(), header: headers);

    // decode UTF-8 safely
    final bodyText = (() {
      try {
        return utf8.decode(res.bodyBytes);
      } catch (_) {
        return res.body;
      }
    })();

    if (res.statusCode == 200) {
      return jsonDecode(bodyText) as Map<String, dynamic>;
    }

    // simple error
    throw Exception(
        'getCheckMissingSchools failed: HTTP ${res.statusCode} → $bodyText');
  }

// 🔹 Edit Check Missing Student
  Future<Map<String, dynamic>> editCheckMissingStudentAPI({
    required int id,
    int? score,
    int? status,
    String? note,
    String? dated, // e.g. "2025-08-20 09:15:00"
  }) async {
    final body = <String, dynamic>{
      "id": id,
      if (score != null) "score": score,
      if (status != null) "status": status,
      if (note != null) "note": note,
      if (dated != null) "dated": dated,
    };

    // ✅ safe base/path join (no _baseUrl)
    final base = nuXtJsUrlApi.endsWith('/')
        ? nuXtJsUrlApi.substring(0, nuXtJsUrlApi.length - 1)
        : nuXtJsUrlApi;
    final path = EditCheckMissingStudent.startsWith('/')
        ? EditCheckMissingStudent.substring(1)
        : EditCheckMissingStudent;
    final url = "$base/$path";

    final res = await postNUxt(
      url: url,
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
      body: body,
    );

    final text = (() {
      try {
        return utf8.decode(res.bodyBytes);
      } catch (_) {
        return res.body;
      }
    })();

    if (res.statusCode == 200) {
      return jsonDecode(text) as Map<String, dynamic>;
    }
    throw Exception(
        "❌ editCheckMissingStudentAPI failed: HTTP ${res.statusCode} → $text");
  }

  Future<Map<String, dynamic>> deleteCheckMissingAPI({
    required int id,
  }) async {
    final res = await postNUxt(
      url: "$nuXtJsUrlApi$DeleteCheckMissing",
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
      // postNUxt expects Map<String, String>?, so send as strings
      body: {
        'id': id.toString(),
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } else {
      final text = (() {
        try {
          return utf8.decode(res.bodyBytes);
        } catch (_) {
          return res.body;
        }
      })();
      throw Exception("Failed to delete: HTTP ${res.statusCode} → $text");
    }
  }

// 🔹 ฟังก์ชันดึง mark_status ตาม branch_id (filter status = 1 อยู่ที่ฝั่ง API แล้ว)
  Future<Map<String, dynamic>> getMarkStatusAPI() async {
    final res = await getNUxt(
      url: "$nuXtJsUrlApi$GetMarkStatus",
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
    );

    if (res.statusCode == 200) {
      final decodedBody = utf8.decode(res.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw Exception("Failed to fetch mark_status: ${res.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getMarkStatusUpdateAPI() async {
    final res = await getNUxt(
      url: "$nuXtJsUrlApi$GetMarkStatus",
      header: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${appVerification.nUxtToken}',
      },
    );

    if (res.statusCode == 200) {
      final decodedBody = utf8.decode(res.bodyBytes);
      return jsonDecode(decodedBody); // <-- return Map<String, dynamic>
    } else {
      throw Exception("Failed to fetch mark_status: ${res.statusCode}");
    }
  }

  /// Fetch check-in/out history from Nuxt API

  Future<Map<String, dynamic>> getHistoryCheckInOutAPI({
    required DateTime startDate,
    required DateTime endDate,
    int? parentRecordId,   // optional (ไม่ต้องส่งก็ได้ เมื่อเป็น parent-only)
    int? parentUserId,     // optional
    int? studentRecordsId, // optional
    int? studentUserId,    // optional
  }) async {
    String _two(int n) => n.toString().padLeft(2, '0');
    String _ymd(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

    // --- sanitize ---
    if (endDate.isBefore(startDate)) {
      endDate = startDate;
    }

    // สร้าง URL
    final base = nuXtJsUrlApi.endsWith('/')
        ? nuXtJsUrlApi.substring(0, nuXtJsUrlApi.length - 1)
        : nuXtJsUrlApi;
    final path = GetHistoryCheckInOut.startsWith('/')
        ? GetHistoryCheckInOut.substring(1)
        : GetHistoryCheckInOut;
    final url = "$base/$path";

    // 🚩 ส่ง all:true เพื่อให้ API ดึง "ทั้งหมด" ในช่วงวันที่
    // ไม่ส่ง page/perPage เลย
    final body = <String, dynamic>{
      'start_date': _ymd(startDate),
      'end_date'  : _ymd(endDate),
      'all'       : true,
      if (parentRecordId   != null) 'parent_record_id'   : parentRecordId,
      if (parentUserId     != null) 'parent_user_id'     : parentUserId,
      if (studentRecordsId != null) 'student_records_id' : studentRecordsId,
      if (studentUserId    != null) 'student_user_id'    : studentUserId,
    };

    // Header + Token
    final token = appVerification.nUxtToken;
    final headers = <String, String>{
      'Accept'      : 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    // ส่งคำขอ
    final res = await postNUxt(url: url, header: headers, body: body);

    // แปลงข้อความ (รองรับ bodyBytes)
    final text = (() {
      try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
    })();

    if (res.statusCode == 200) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) return decoded;
        throw Exception('Invalid JSON structure');
      } catch (e) {
        throw Exception('Invalid JSON from get_history_check_in_out: $e • raw=$text');
      }
    }

    if (res.statusCode == 401 || res.statusCode == 403) {
      appVerification.storage.erase();
      appVerification.removeToken();
      Get.offAll(() => const LoginPage());
      throw Exception('Unauthorized (${res.statusCode}).');
    }

    throw Exception('get_history_check_in_out failed: HTTP ${res.statusCode} • $text');
  }


  /// Fetch student missing-school history (UI ใช้หน้า "ประวัติลูกขาดเรียน")
  /// รองรับ API ใหม่: api/api_for_app/mark_student/get_student_missing_school
  Future<Map<String, dynamic>> getStudentMissingSchoolAPI({
    required DateTime startDate,
    required DateTime endDate,
    String? q,                 // ✅ เพิ่มพารามิเตอร์ q
    int? studentRecordsId, // optional: ถ้าต้องการกรองเฉพาะนักเรียน
  }) async {
    String _two(int n) => n.toString().padLeft(2, '0');
    String _ymd(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

    // --- sanitize ช่วงวัน ---
    if (endDate.isBefore(startDate)) {
      endDate = startDate;
    }

    // --- สร้าง URL ---
    final base = nuXtJsUrlApi.endsWith('/')
        ? nuXtJsUrlApi.substring(0, nuXtJsUrlApi.length - 1)
        : nuXtJsUrlApi;

    // ใช้คอนสแตนต์ใหม่ (ต้องมีตัวแปร String GetStudentMissingSchool)
    final path = GetStudentMissingSchool.startsWith('/')
        ? GetStudentMissingSchool.substring(1)
        : GetStudentMissingSchool;

    final url = "$base/$path";

    // --- Body: ไม่มี pagination ใช้แค่ช่วงวันที่ และ student_records_id (optional) ---
    final body = <String, dynamic>{
      'start_date': _ymd(startDate),     // รูปแบบ YYYY-MM-DD
      'end_date'  : _ymd(endDate),
      if (q != null && q.trim().isNotEmpty) 'q': q.trim(), // ✅ ส่ง q
      if (studentRecordsId != null && studentRecordsId > 0)
        'student_records_id': studentRecordsId,
    };

    // --- Header + Token ---
    final token = appVerification.nUxtToken;
    final headers = <String, String>{
      'Accept'      : 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    // --- ส่งคำขอ ---
    final res = await postNUxt(url: url, header: headers, body: body);

    // --- แปลงข้อความ (รองรับ bodyBytes) ---
    final text = (() {
      try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
    })();

    // --- ตรวจผลลัพธ์ ---
    if (res.statusCode == 200) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) return decoded;
        throw Exception('Invalid JSON structure');
      } catch (e) {
        throw Exception('Invalid JSON from get_student_missing_school: $e • raw=$text');
      }
    }

    if (res.statusCode == 401 || res.statusCode == 403) {
      // จัดการ token หมดอายุ / ไม่มีสิทธิ์
      appVerification.storage.erase();
      appVerification.removeToken();
      Get.offAll(() => const LoginPage());
      throw Exception('Unauthorized (${res.statusCode}).');
    }

    throw Exception('get_student_missing_school failed: HTTP ${res.statusCode} • $text');
  }


}
