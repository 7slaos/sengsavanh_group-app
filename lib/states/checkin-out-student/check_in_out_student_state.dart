import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var index = 0.obs;
  setIndex(int i, String type) {
    index.value = i;
    fetchData(type: type);
  }

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
  @override
  void onInit() {
    super.onInit();
    fetchData();
    _setupScrollListener();
  }

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
    String status = '1';
    if (index.value == 1) {
      status = '2';
    }
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
          'status': status,
          'type': type ?? ''
        },
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to load data: ${res.statusCode}');
      }

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
      } else {
        throw Exception(response['message'] ?? 'Failed to load data');
      }
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

  void applyDateFilter(String start, String end) {
    startDate.value = start;
    endDate.value = end;
    fetchData();
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
   await repository.post(url: '${repository.urlApi}api/check_in_check_out_push_notification_to_users', body: {
      'id': id,
      'type': type
    }, auth: true);
   // print('test sen notifications');
   // print(res.body);
  }

  Future<void> confirmRequestGoHome(
      {required BuildContext context,
      String? student_records_id,
      String? checkin_teacher_records_id,
      String? person_go_with_id,
      required String type,
      required String lat,
      required String lng}) async {
    try {
      CustomDialogs().dialogLoading();
      final res = await repository.postNUxt(
        url:
            '${repository.nuXtJsUrlApi}api/Application/checkin-out-student/request_go_home',
        auth: true,
        body: {
          'student_records_id': student_records_id ?? '',
          'person_go_with_id': person_go_with_id ?? '',
          'type': type,
          'checkin_teacher_records_id': checkin_teacher_records_id ?? '',
          'lat': lat,
          'lng': lng
        },
      );
      Get.back();
      final response = jsonDecode(utf8.decode(res.bodyBytes));
      // print(student_records_id);
      // print(type);
      // print(response);
      if (response['success'] == true && res.statusCode == 200) {
        playSuccessSound();
        CustomDialogs().showToastWithIcon(
            context: context,
            backgroundColor: AppColor().green.withOpacity(0.8),
            message: 'success',
            icon: Icons.check);
        if(type == 'owner_teacher') {
          checkCurrentCheckIn(checkin_teacher_records_id: checkin_teacher_records_id);
        }else if(student_records_id !=null){
          await sendNotificationToParent(id: student_records_id, type: response['action']);
          checkCurrentCheckIn(student_records_id: student_records_id);
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
  bool checkIn = false;
  Future<void> checkCurrentCheckIn(
      {
        String? student_records_id,
        String? checkin_teacher_records_id}) async {
    try {
      checkIn = false;
      final res = await repository.postNUxt(
        url:
        '${repository.nuXtJsUrlApi}api/Application/checkin-out-student/check-current-check-in',
        auth: true,
        body: {
          'student_records_id': student_records_id ?? '',
          'checkin_teacher_records_id': checkin_teacher_records_id ?? '',
        },
      );
      final response = jsonDecode(utf8.decode(res.bodyBytes));
      if (response['success'] == true) {
        checkIn =true;
      }
      update();
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
