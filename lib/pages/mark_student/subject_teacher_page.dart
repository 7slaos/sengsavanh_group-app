import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/mark_student/list_check_student_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class SubjectTeacherPage extends StatefulWidget {
  const SubjectTeacherPage({super.key});

  @override
  State<SubjectTeacherPage> createState() => _SubjectTeacherPageState();
}

class _SubjectTeacherPageState extends State<SubjectTeacherPage> {
  final AppColor appColors = AppColor();
  final Repository repository = Repository();

  String? selectedDay;
  final ScrollController _dayScrollController = ScrollController();

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  List<dynamic> subjectData = []; // ✅ ใช้ Map ตรง ๆ
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday;
    selectedDay = days[weekday - 1];

    fetchSubjects();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = days.indexOf(selectedDay!);
      if (index != -1) {
        _dayScrollController.animateTo(
          index * 90,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
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
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Error fetchSubjects: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fsize = size.width + size.height;

    return Scaffold(
      backgroundColor: appColors.white,
      appBar: AppBar(
        backgroundColor: appColors.mainColor,
        elevation: 4,
        title: CustomText(
          text: 'Subjects for teach'.tr,
          color: appColors.white,
        ),
// ใน AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.white),
          onPressed: () {
            // ไปหน้า TeacherDashboardPage แบบเคลียร์ stack ทั้งหมด
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
                  SizedBox(
                    height: 45,
                    child: ListView(
                      controller: _dayScrollController,
                      scrollDirection: Axis.horizontal,
                      children: days.map((day) {
                        final isSelected = day == selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => selectedDay = day),
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
                                text: day,
                                color: isSelected
                                    ? Colors.white
                                    : appColors.mainColor,
                                fontSize: fsize * 0.013,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: subjectData.isEmpty
                        ? const Center(child: Text("ບໍ່ມີຂໍ້ມູນ"))
                        : ListView(
                            children: subjectData.where((item) {
                              String apiDay =
                                  days[(item["days"] ?? 1) - 1]; // ✅ ใช้ Map
                              return apiDay == selectedDay;
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
                                            item["subject_teacher_id"] ??
                                                0, // 👈 ส่งค่าที่มีอยู่แล้ว
                                        scheduleItemsId:
                                            item["schedule_items_id"] ??
                                                0, // 👈 ต้องส่งเพิ่มอันนี้
                                        className: item["class_name"] ??
                                            "-", // 👈 ต้องมีค่านี้
                                        subjectName: item["subject_name"] ??
                                            "-", // 👈 ต้องมีค่านี้
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.menu_book,
                                              size: fsize * 0.016,
                                              color: appColors.mainColor),
                                          const SizedBox(width: 6),
                                          CustomText(
                                            text: item["subject_name"] ?? "-",
                                            fontSize: fsize * 0.015,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          CustomText(
                                            text:
                                                'ຊັ້ນ: ${item["class_name"] ?? "-"}',
                                            fontSize: fsize * 0.013,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.calendar_today,
                                              size: fsize * 0.013,
                                              color: appColors.mainColor),
                                          const SizedBox(width: 4),
                                          CustomText(
                                            text: days[(item["days"] ?? 1) - 1],
                                            fontSize: fsize * 0.013,
                                            color: appColors.mainColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.access_time,
                                              size: fsize * 0.013,
                                              color: appColors.mainColor),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: CustomText(
                                              text:
                                                  '${(item["start_time"] ?? "").toString().substring(0, 5)} - ${(item["end_time"] ?? "").toString().substring(0, 5)}',
                                              fontSize: fsize * 0.013,
                                              color: appColors.mainColor,
                                            ),
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
}
