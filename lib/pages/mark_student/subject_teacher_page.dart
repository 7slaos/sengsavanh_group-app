import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/pages/mark_student/list_check_student_page.dart';
import 'package:multiple_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class SubjectTeacherPage extends StatefulWidget {
  const SubjectTeacherPage({super.key});

  @override
  State<SubjectTeacherPage> createState() => _SubjectTeacherPageState();
}

class _SubjectTeacherPageState extends State<SubjectTeacherPage> {
  final AppColor appColors = AppColor();
  final Repository repository = Repository();

  String? selectedDayKey;
  final ScrollController _dayScrollController = ScrollController();

  final List<String> dayKeys = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  List<dynamic> subjectData = []; // ✅ ใช้ Map ตรง ๆ
  bool isLoading = true;

  void _scrollToSelectedDay() {
    final idx = dayKeys.indexOf(selectedDayKey ?? '');
    if (idx != -1 && _dayScrollController.hasClients) {
      _dayScrollController.animateTo(
        idx * 90.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }


  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday;
    selectedDayKey = dayKeys[weekday - 1];

    fetchSubjects();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
  }

  Future<void> fetchSubjects() async {
    try {
      final box = GetStorage();
      String? token = box.read("token");
      print("🔑 Token from storage: $token");

      if (token == null) throw Exception("Token not found in storage");

      final data = await repository.getSubjectByTeacherAPI();
      print("📌 API response: $data");

      if (data["success"] == true && data["schedules"] != null) {
        setState(() {
          subjectData = data["schedules"];
          isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
      } else {
        setState(() => isLoading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
      }
    } catch (e) {
      print("❌ Error fetchSubjects: $e");
      setState(() => isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // ฟังก์ชันคำนวณ font size (ป้องกันตัวหนังสือใหญ่เกินจนล้น)
    double fs(double factor) =>
        (size.width * factor).clamp(10.0, 20.0).toDouble();

    String fmtTime(dynamic v) {
      final s = (v ?? "").toString();
      return s.length >= 5 ? s.substring(0, 5) : s;
    }

    return Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        backgroundColor: appColors.mainColor,
        elevation: 4,
        title: CustomText(
          text: 'subjects_for_teach'.tr,
          color: appColors.white,
          fontSize: fs(0.05),
          fontWeight: FontWeight.bold,
          maxLines: 1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.white),
          onPressed: () {
            Get.offAll(() => const TeacherDashboardPage());
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: Column(
                children: [
                  // ✅ แถวเลือกวันแนวนอน
                  SizedBox(
                    height: 45,
                    child: ListView(
                      controller: _dayScrollController,
                      scrollDirection: Axis.horizontal,
                      children: dayKeys.map((dayKey) {
                        final isSelected = dayKey == selectedDayKey;
                        return GestureDetector(
                          onTap: () => setState(() => selectedDayKey = dayKey),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.mainColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: appColors.mainColor),
                            ),
                            child: Center(
                              child: CustomText(
                                text: dayKey.tr,
                                color: isSelected
                                    ? Colors.white
                                    : appColors.mainColor,
                                fontSize: fs(0.035),
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ รายการวิชา
                  Expanded(
                    child: subjectData.isEmpty
                        ? Center(child: Text("no_information_found".tr))
                        : ListView(
                            children: subjectData.where((item) {
                              String apiDayKey =
                                  dayKeys[(item["days"] ?? 1) - 1];
                              return apiDayKey == selectedDayKey;
                            }).map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColors.grey.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ListCheckStudentPage(
                                        subjectTeacherId:
                                            item["subject_teacher_id"] ?? 0,
                                        scheduleItemsId:
                                            item["schedule_items_id"] ?? 0,
                                        className: item["class_name"] ?? "-",
                                        subjectName:
                                            item["subject_name"] ?? "-",
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ✅ ห่อ subject name ด้วย Expanded
                                      Row(
                                        children: [
                                          Icon(Icons.menu_book,
                                              size: fs(0.04),
                                              color: appColors.mainColor),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: CustomText(
                                              text: item["subject_name"] ?? "-",
                                              fontSize: fs(0.045),
                                              fontWeight: FontWeight.bold,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      // ✅ ใช้ Wrap กันล้นเวลาแสดงรายละเอียด
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 12,
                                        runSpacing: 6,
                                        children: [
                                          CustomText(
                                            text:
                                                '${'class'.tr}: ${item["class_name"] ?? "-"}',
                                            fontSize: fs(0.035),
                                            color: Colors.grey[700],
                                            maxLines: 1,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: fs(0.035),
                                                  color: appColors.mainColor),
                                              const SizedBox(width: 4),
                                              CustomText(
                                                text: dayKeys[
                                                        (item["days"] ?? 1) - 1]
                                                    .tr,
                                                fontSize: fs(0.035),
                                                color: appColors.mainColor,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.access_time,
                                                  size: fs(0.035),
                                                  color: appColors.mainColor),
                                              const SizedBox(width: 4),
                                              CustomText(
                                                text:
                                                    '${fmtTime(item["start_time"])} - ${fmtTime(item["end_time"])}',
                                                fontSize: fs(0.035),
                                                color: appColors.mainColor,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

}
