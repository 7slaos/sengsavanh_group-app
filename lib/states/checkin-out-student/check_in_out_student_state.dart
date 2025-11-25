import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/pages/adminschool/admin_school_dashboard.dart';
import 'package:multiple_school_app/pages/student_records/dashboard_page.dart';
import 'package:multiple_school_app/pages/teacher_recordes/dashboard_page.dart';
import '../../custom/app_color.dart';
import '../../repositorys/repository.dart';
import '../../widgets/custom_dialog.dart';

class StudentCheckInOut {
  final int id;
  final String firstname;
  final String lastname;
  final String? nickname;
  final String? firstnameEn;
  final String? lastnameEn;
  final String? phone;
  final String? myClass;
  final String? checkinDate;
  final String? checkoutDate;
  final int? myClassId;
  final int? status;
  final int? returnHome;

  StudentCheckInOut(
      {required this.id,
      required this.firstname,
      required this.lastname,
      this.nickname,
      this.firstnameEn,
      this.lastnameEn,
      this.phone,
      this.myClass,
      this.checkinDate,
      this.checkoutDate,
      this.myClassId,
      this.status,
      this.returnHome});

  factory StudentCheckInOut.fromMap(Map<String, dynamic> map) {
    return StudentCheckInOut(
      id: map['id'] as int? ?? 0,
      firstname: map['firstname'] as String? ?? '',
      lastname: map['lastname'] as String? ?? '',
      nickname: map['nickname'] as String?,
      firstnameEn: map['firstname_en'] as String?,
      lastnameEn: map['lastname_en'] as String?,
      phone: map['phone'] as String?,
      myClass: map['my_class'] as String?,
      myClassId: map['my_class_id'] as int?,
      status: map['status'] as int?,
      returnHome: map['return_home'] as int?,
      checkinDate: map['checkin_date'] as String?,
      checkoutDate: map['checkout_date'] as String?,
    );
  }
}

class CheckInOutStudentState extends GetxController {
  Repository repository = Repository();
  final scrollController = ScrollController();
  final _searchDebouncer = Debouncer(delay: Duration(milliseconds: 500));
  // States
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var errorMessage = ''.obs;
  var dataList = <StudentCheckInOut>[].obs;
  var page = 1.obs;
  var lastPage = 1.obs;
  final int limit = 20;
  // Filters
  var startDate = ''.obs;
  var endDate = ''.obs;
  var searchQuery = ''.obs;
  var selectedClassId = Rx<int?>(null);

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (_shouldLoadMore) {
        loadMoreData();
      }
    });
  }

  bool get _shouldLoadMore {
    return scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isMoreLoading.value &&
        page.value < lastPage.value;
  }

  Future<void> loadMoreData() async {
    if (page.value >= lastPage.value) return;
    page.value += 1;
    await fetchData(loadMore: true);
  }

  Future<void> fetchData({bool loadMore = false, String ? type}) async {
    if (loadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
      page.value = 1;
      dataList.clear();
      errorMessage.value = '';
    }

    try {
      final res = await repository.postNUxt(
        url: '${repository.nuXtJsUrlApi}api/Application/checkin-out-student',
        auth: true,
        body: {
          'page': page.value.toString(),
          'limit': limit.toString(),
          'start_date': startDate.value.isEmpty ? '' : startDate.value,
          'end_date': endDate.value.isEmpty ? '' : endDate.value,
          'class_id': selectedClassId.value?.toString() ?? '',
          'search': searchQuery.value.isEmpty ? '' : searchQuery.value,
          'type': type ?? ''
        },
      );

      // if (res.statusCode != 200) {
      //   throw Exception('Failed to load data: ${res.statusCode}');
      // }

      final response = jsonDecode(utf8.decode(res.bodyBytes));
      // print(type);
      // print(response);

      if (response['success'] == true) {
        lastPage.value = response['meta']['last_page'] ?? 1;

        final newData = (response['data'] as List)
            .map((item) => StudentCheckInOut.fromMap(item))
            .toList();

        if (loadMore) {
          dataList.addAll(newData);
        } else {
          dataList.assignAll(newData);
        }
      }
      // else {
      //   throw Exception(response['message'] ?? 'Failed to load data');
      // }
    } catch (e) {
      errorMessage.value = e.toString();
      if (!loadMore) {
        dataList.clear();
      }
      debugPrint('Error fetching student data: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  void applyDateFilter(String start, String end, String type) {
    startDate.value = start;
    endDate.value = end;
    fetchData(type: type);
  }

  void searchStudents(String query) {
    _searchDebouncer.run(() {
      searchQuery.value = query;
      fetchData();
    });
  }

  void filterByClass(int? classId) {
    selectedClassId.value = classId;
    fetchData();
  }

  void clearFilters() {
    startDate.value = '';
    endDate.value = '';
    searchQuery.value = '';
    selectedClassId.value = null;
    fetchData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    _searchDebouncer.dispose();
    super.onClose();
  }

  final player = AudioPlayer();
  void playSound() async {
    await player.play(AssetSource('sounds/error.mp3'));
  }

  void playSuccessSound() async {
    await player.play(AssetSource('sounds/success.mp3'));
  }

  sendNotificationToParent({required String id, required type}) async{
   await repository.post(url: '${repository.nuXtJsUrlApi}api/Application/SuperAdminApiController/check_in_check_out_push_notification_to_users', body: {
      'id': id,
      'type': type
    }, auth: true);
  }

  Map<String, dynamic> settingTimeData = {};
  bool canCheckIn = true;
  bool checkHosLiDay=  false;
  String note = '';
  Future<void> getSettingCheckInOutTimes({
    required String type,
  }) async {
    try {
      settingTimeData = {};
      checkHosLiDay =  false;
      canCheckIn = false;
      note = 'ບໍ່ມີການຕັ້ງຄ່າເວລາ';
      update();
      if(type == 'a'){
        type = 't';
      }
      final res = await repository.postNUxt(
        url: "${repository.nuXtJsUrlApi}api/Application/checkin-out-student/get_check_in_out_setting_time",
        body: {
          'day': DateTime.now().weekday.toString(),
          'type': type,
        },
        auth: true,
      );
      final Map<String, dynamic> response =
      jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      if (res.statusCode == 200 && response['success'] == true) {
        final data = (response['data'] ?? {}) as Map<String, dynamic>;
        settingTimeData = Map<String, dynamic>.from(data);
      } else if(res.statusCode == 422){
        checkHosLiDay  = true;
        note = response['message'].toString();
        settingTimeData = {};
      }
    } catch (e, s) {
      settingTimeData = {};
    } finally {
      update();
    }
    if(settingTimeData.length > 0) {
      checkTimeCanCheckInOut(type: type);
    }
  }

  int _toSeconds(String t) {
    final p = t.split(':');
    final h = int.parse(p[0]);
    final m = p.length > 1 ? int.parse(p[1]) : 0;
    final s = p.length > 2 ? int.parse(p[2]) : 0;
    return h * 3600 + m * 60 + s;
  }

  void checkTimeCanCheckInOut({bool checkOut = false, required String type}) {
    canCheckIn = true;
    note = '';
    if (settingTimeData.isEmpty) {
      canCheckIn = false;
      note = 'ບໍ່ມີການຕັ້ງຄ່າເວລາ';
      update();
      return;
    }
    final now = DateTime.now();
    final nowSec = now.hour * 3600 + now.minute * 60 + now.second;
    final startSec = _toSeconds(settingTimeData['start_time'] ?? '00:00:00');
    final lateSec  = _toSeconds(settingTimeData['late_time']  ?? settingTimeData['start_time'] ?? '00:00:00');
    final missSec  = _toSeconds(settingTimeData['miss_time']  ?? '23:59:59');
    final middleSec  = _toSeconds(settingTimeData['middle_time']  ?? '23:59:59');
    final backSec  = _toSeconds(settingTimeData['back_time']  ?? '23:59:59');
    if(checkOut == true){
     // if (nowSec > backSec) {
        canCheckIn = true;
        note = '';
     //}
     // else{
     //   canCheckIn = false;
     //   note = 'ຍັງບໍ່ຮອດເວລາ Check-Out';
     // }
     update();
     return;
  }

    if (nowSec < startSec) {
      canCheckIn = false;
      note = 'ຍັງບໍ່ເຖິງເວລາ Check-In';
    } else if (nowSec <= lateSec) {
      canCheckIn = true;
      note = 'ປົກກະຕິ';
    } else if (nowSec <= missSec) {
      canCheckIn = true;
      note = 'ມາຊ້າ';
    } else if (nowSec <= middleSec) {
      canCheckIn = true;
      note = 'ຂາດເຄິ່ງມື້';
    }
    else if (nowSec < backSec) {
      canCheckIn = true;
      note = 'ຂາດໝົດມື້';
    } else {
      canCheckIn = false;
      note = 'ປິດການເຊັກອິນ';
    }

    update();
  }


  Future<void> confirmCheckInOut(
      {
        required BuildContext context,
        String? student_records_id,
        String? id,
      required String type}) async {
    try {
      if(canCheckIn == false && id == null){
        playSound();
        CustomDialogs().showToastWithIcon(
            context: context,
            backgroundColor: AppColor().red.withOpacity(0.8),
            message: note,
            icon: Icons.close);
        return;
      }
      if(id !='' && id!=null){
        checkTimeCanCheckInOut(checkOut: true, type: type);
        if(canCheckIn == false){
          playSound();
          CustomDialogs().showToastWithIcon(
              context: context,
              backgroundColor: AppColor().red.withOpacity(0.8),
              message: note,
              icon: Icons.close);
           return;
        }
      }
      CustomDialogs().dialogLoading();
      final res = await repository.postNUxt(
        url:
            '${repository.nuXtJsUrlApi}api/Application/checkin-out-student/check_in',
        auth: true,
        body: {
          'type': type,
          'note': note,
          'id': id ?? ''
        },
      );
      Get.back();
      final response = jsonDecode(utf8.decode(res.bodyBytes));
      // print('222222222');
      // print(response);
      if (response['success'] == true && res.statusCode == 200) {
        playSuccessSound();
        CustomDialogs().showToastWithIcon(
            context: context,
            backgroundColor: AppColor().green.withOpacity(0.8),
            message: id !=null ? 'Check-Out ${"success".tr}' : 'Check-In ${"success".tr}',
            icon: Icons.check);
        if(type == 't'){
           Get.off(() => TeacherDashboardPage(), transition: Transition.fadeIn);
        }
        else if(type == 'a'){
          Get.off(() => AdminSchoolDashboard(), transition: Transition.fadeIn);
        }
        else if(type == 's' && student_records_id !=null){
          await sendNotificationToParent(id: student_records_id, type: response['action']);
          Get.off(() => DashboardPage(), transition: Transition.fadeIn);
        }
      } else if (res.statusCode == 422) {
        playSound();
        CustomDialogs().showToastWithIcon(
            context: context,
            backgroundColor: AppColor().red.withOpacity(0.8),
            message: response['message'],
            icon: Icons.close);
      } else {
        playSound();
        CustomDialogs().showToastWithIcon(
            context: context,
            backgroundColor: AppColor().red.withOpacity(0.8),
            message: response['message'],
            icon: Icons.close);
      }
    } catch (e) {
      debugPrint('Error fetching student data: $e');
    }
  }
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
