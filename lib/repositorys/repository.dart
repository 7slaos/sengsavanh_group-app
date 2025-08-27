import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pathana_school_app/pages/login_page.dart';

import '../states/appverification.dart';

export 'dart:convert';

class Repository {
  String urlApi = 'https://main.pathanaschool.net/';
  String nuXtJsUrlApi = 'https://pathanaschool.net/';
  // String urlApi = 'http://192.168.100.155:8000/';
  // String nuXtJsUrlApi = 'http://192.168.100.155:3000/';
  String getFunctionAvailableByRole = 'api/get_function_available_by_role';
  String loginUser = 'api/login_users';
  String logoutUser = 'api/logouts';
  String getProfiled = 'api/get_Profileds';
  String updateProfiled = 'api/update_Profiled_Parents';
  String parentDashboard = 'api/DashboardParentRecorde';
  String parentHomeStudentList = 'api/HomeParent_and_StudentList';
  String scoreChildren = 'api/score_children';
  String getDataListStudent = 'api/get_list_students';
  String getProfileStudentRecord = 'api/get_student_profiled';
  String updateProfileStudentRecord = 'api/update_profiled_studentrecord';
  String dashboardStudentRecorde = 'api/Dashboard_student';
  String countId = 'api/counts';
  String authNameSchool = 'api/AuthUserName';
  String dashboardTeacherRecorde = 'api/Dashboard_teachers';
  String teacherRecordePofiled = 'api/get_TeacherRecorde_Profiled';
  String updateTeacherRecorde = 'api/update_profiled_teacherrecord';
  // String logoutTeacher = 'api/logout_teacher';
  String getMyClasse = 'api/getMyClass';
  String getSubjects = 'api/getSubject';
  String studentScore = 'api/student_score';
  String saveScoreStudent = 'api/SaveScoreStudent';
  String scoreStudent = 'api/score_list_student';
  String totalScore = 'api/total_score';
  String followStudents = 'api/follow_student_records';
  String followStudentDetail = 'api/follow_student_rercod_details';
  String deleteFollowStudents = 'api/deleteFollowStudents';
  String updateFollowStudents = 'api/updateFollowStudents';
  // String getStudentDropwon = 'api/get_student_records';

  //gdev
  String updatePayment = 'api/updatePayment';
  String saveDeviceToken = 'api/store_s_chool_app_user';
  String callStudents = 'api/call_students';
  String tearchconfirmcallStudent = 'api/teach_confirm_send_student';
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
  AppVerification appVerification = Get.put(AppVerification());
  Future<http.Response> get(
      {required String url, Map<String, String>? header, bool? auth}) async {
    try {
      var res = await http
          .get(Uri.parse(url),
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
      var res = await http
          .post(Uri.parse(url),
              body: jsonEncode(body),
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
Map<String, dynamic>? body,   // ✅ เปลี่ยนตรงนี้
      bool? auth}) async {
    try {
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

Future<Map<String, dynamic>> getStudentBySubjectAPI(int subjectTeacherId) async {
  final res = await getNUxt(
    url: "$nuXtJsUrlApi$GetStudentBySubject?subject_teacher_id=$subjectTeacherId",
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
    try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
  })();

  if (res.statusCode == 200) {
    return jsonDecode(bodyText) as Map<String, dynamic>;
  }

  // simple error
  throw Exception('getCheckMissingSchools failed: HTTP ${res.statusCode} → $bodyText');
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
    try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
  })();

  if (res.statusCode == 200) {
    return jsonDecode(text) as Map<String, dynamic>;
  }
  throw Exception("❌ editCheckMissingStudentAPI failed: HTTP ${res.statusCode} → $text");
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
      try { return utf8.decode(res.bodyBytes); } catch (_) { return res.body; }
    })();
    throw Exception("Failed to delete: HTTP ${res.statusCode} → $text");
  }
}

}
