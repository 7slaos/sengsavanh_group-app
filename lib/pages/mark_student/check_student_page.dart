import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/mark_student/list_check_student_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class CheckStudentPage extends StatefulWidget {
  final int subjectTeacherId;
  final int scheduleItemsId;
  final String className;
  final String subjectName;
  const CheckStudentPage({
    super.key,
    required this.subjectTeacherId,
    required this.scheduleItemsId,
    required this.className,
    required this.subjectName,
  });

  @override
  State<CheckStudentPage> createState() => _CheckStudentPageState();
}

class _CheckStudentPageState extends State<CheckStudentPage> {
  final AppColor appColors = AppColor();
  final Repository repo = Repository();

  final TextEditingController cutScoreController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  int? selectedStatus;
  List<Map<String, dynamic>> students = [];
  final Set<int> selectedIndexes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  /// ดึงรายชื่อนักเรียนจาก API
  Future<void> _fetchStudents() async {
    try {
      final data = await repo.getStudentBySubjectAPI(widget.subjectTeacherId);

      print("📥 API Response: $data"); // ✅ debug ดูโครงสร้างจริงที่ได้

      if (data['success'] == true) {
        // ลองเข้าถึง students หลายแบบเพื่อความชัวร์
        final rawStudents = data['data']?['subject_teacher']?['subject']
                ?['my_class']?['students'] ??
            data['data']?['students']; // ✅ fallback ถ้าโครงสร้างต่าง

        if (rawStudents != null && rawStudents is List) {
          setState(() {
            students = List<Map<String, dynamic>>.from(rawStudents);
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          Get.snackbar("Notice", "API ไม่พบรายชื่อนักเรียน");
        }
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", data['message'] ?? "Failed to load students");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", e.toString());
    }
  }

  /// เมื่อกดปุ่มยืนยัน
  void _onConfirm() async {
    if (students.isEmpty || selectedIndexes.isEmpty) {
      Get.snackbar("Warning", "ກະລຸນາເລືອກນັກຮຽນ");
      return;
    }

    // ✅ Validate score
    if (cutScoreController.text.isEmpty) {
      Get.snackbar("Warning", "Please input score");
      return;
    }
    final scoreValue = int.tryParse(cutScoreController.text);
    if (scoreValue == null) {
      Get.snackbar("Warning", "Score should be number");
      return;
    }

    // ✅ Validate note
    if (noteController.text.isEmpty) {
      Get.snackbar("Warning", "Please input note");
      return;
    }

    // ✅ Validate status
    if (selectedStatus == null) {
      Get.snackbar("Warning", "Please select status");
      return;
    }

    // ✅ รวมวันที่ + เวลา เป็น DateTime เดียว
    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final formattedDateTime =
        "${combinedDateTime.toIso8601String().split('.')[0].replaceFirst('T', ' ')}";

    final payload = {
      "schedule_items_id": widget.scheduleItemsId,
      "dated": formattedDateTime,
      "students": selectedIndexes.map((i) {
        final st = students[i];
        return {
          "student_records_id": st['student_records_id'],
          "score": scoreValue,
          "note": noteController.text,
          "status": selectedStatus,
        };
      }).toList(),
    };

    print("📤 ส่งข้อมูล: $payload");

    try {
      final result = await repo.saveCheckStudentAPI(payload);

      if (result['success'] == true) {
       var res =  await Repository().post(
          url: '${Repository().urlApi}api/check_in_check_out_push_notification_to_users',
          body: {
            'type': 'missing_school',
            'student_record_ids': jsonEncode(
              selectedIndexes.map((i) {
                final st = students[i];
                return st['student_records_id']; // ส่งค่า id ตรงๆ
              }).toList(),
            ),
          },
          auth: true,
        );
        //
        // print('333333');
        // print(res.body);
        Get.defaultDialog(
          title: "Success",
          middleText: "Saved success",
          textConfirm: "OK",
          onConfirm: () {
            Get.back();
            Get.offAll(() => ListCheckStudentPage(
                  subjectTeacherId: widget.subjectTeacherId,
                  scheduleItemsId: widget.scheduleItemsId,
                  className: widget.className, // 👈 เพิ่มตรงนี้
                  subjectName: widget.subjectName, // 👈 เพิ่มตรงนี้
                ));
          },
        );
      } else {
        Get.snackbar("Error", result['message'] ?? "ບັນທຶກບໍ່ສຳເລັດ");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
          text: 'Mark Students - ${widget.className} (${widget.subjectName})',
          color: appColors.white,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: appColors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔹 รายชื่อนักเรียน
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final isSelected = selectedIndexes.contains(index);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIndexes.remove(index);
                              } else {
                                selectedIndexes.add(index);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.mainColor.withOpacity(0.1)
                                  : appColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.grey.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  activeColor: appColors.mainColor,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedIndexes.add(index);
                                      } else {
                                        selectedIndexes.remove(index);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomText(
                                    text:
                                        "${student['firstname']} ${student['lastname']} (${student['nickname'] ?? '-'})",
                                    fontSize: fsize * 0.014,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 🔹 Input ด้านล่าง
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: appColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: appColors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Row 1: Score + Note
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: cutScoreController,
                              decoration: InputDecoration(
                                hintText: 'Score',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: noteController,
                              decoration: InputDecoration(
                                hintText: 'Note',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Row 2: Date + Time
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => selectedDate = picked);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Date",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (picked != null) {
                                  setState(() => selectedTime = picked);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Time",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(selectedTime.format(context)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Row 3: Status + Confirm
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              hint: const Text('Status'),
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('All days'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Come late'),
                                ),
                              ],
                              onChanged: (value) {
                                selectedStatus = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedIndexes.isEmpty
                                  ? Colors.grey
                                  : Colors.blue, // ถ้าไม่มีเลือก = 灰色
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: selectedIndexes.isEmpty
                                ? null
                                : _onConfirm, // ❌ disable ถ้าไม่เลือก
                            child: const Text('Confirm'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
