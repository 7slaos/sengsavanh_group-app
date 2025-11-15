import 'dart:async';
import 'dart:convert';

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

  /// Search controller + debounce
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String searchQuery = '';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<Map<String, dynamic>> markStatusList = []; // from API
  int? selectedStatus;

  List<Map<String, dynamic>> students = []; // from API
  final Set<int> selectedIds = {}; // selected by student id (stable)

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarkStatus();
    _fetchStudents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    noteController.dispose();
    cutScoreController.dispose();
    super.dispose();
  }

  /// -------------------- API --------------------

  Future<void> _fetchMarkStatus() async {
    try {
      final data = await repo.getMarkStatusAPI(); // your API
      if (data['success'] == true && data['data'] != null) {
        setState(() {
          markStatusList = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        Get.snackbar("Error", "ไม่พบข้อมูลสถานะ");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> _fetchStudents() async {
    try {
      final data = await repo.getStudentBySubjectAPI(widget.subjectTeacherId);
      if (data['success'] == true) {
        // try multiple shapes
        final rawStudents = data['data']?['subject_teacher']?['subject']
        ?['my_class']?['students'] ??
            data['data']?['students'];

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

  /// -------------------- SEARCH --------------------

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = value.trim().toLowerCase();
      });
    });
  }

  List<Map<String, dynamic>> get filteredStudents {
    if (searchQuery.isEmpty) return students;
    return students.where((s) {
      final first = (s['firstname'] ?? '').toString().toLowerCase();
      final last = (s['lastname'] ?? '').toString().toLowerCase();
      final nick = (s['nickname'] ?? '').toString().toLowerCase();
      final code = (s['student_code'] ?? '').toString().toLowerCase();
      return first.contains(searchQuery) ||
          last.contains(searchQuery) ||
          nick.contains(searchQuery) ||
          code.contains(searchQuery);
    }).toList();
  }

  /// prefer student_records_id (backend key), fallback to id
  int _studentIdOf(Map<String, dynamic> s) {
    final id = s['student_records_id'] ?? s['id'];
    return (id is int) ? id : int.tryParse(id?.toString() ?? '') ?? -1;
  }

  /// -------------------- SUBMIT --------------------

  void _onConfirm() async {
    if (students.isEmpty || selectedIds.isEmpty) {
      Get.snackbar("Warning", "ກະລຸນາເລືອກນັກຮຽນ");
      return;
    }

    if (noteController.text.isEmpty) {
      Get.snackbar("Warning", "Please input note");
      return;
    }

    if (selectedStatus == null) {
      Get.snackbar("Warning", "Please select status");
      return;
    }

    final selectedStatusItem = markStatusList.firstWhere(
          (item) => item['id'] == selectedStatus,
      orElse: () => {},
    );
    final scoreValue = selectedStatusItem['score'] ?? 0;

    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final formattedDateTime =
        "${combinedDateTime.toIso8601String().split('.')[0].replaceFirst('T', ' ')}";

    final chosen = students
        .where((s) => selectedIds.contains(_studentIdOf(s)))
        .toList();

    if (chosen.isEmpty) {
      Get.snackbar("Warning", "No selected students found.");
      return;
    }

    final payload = {
      "schedule_items_id": widget.scheduleItemsId,
      "dated": formattedDateTime,
      "students": chosen.map((st) {
        return {
          "student_records_id": st['student_records_id'],
          "score": scoreValue,
          "note": noteController.text,
          "status": selectedStatus,
        };
      }).toList(),
    };

    try {
      final result = await repo.saveCheckStudentAPI(payload);

      if (result['success'] == true) {
        // Optional: push notification
        final idsForPush =
        chosen.map((st) => st['student_records_id']).toList();

        await Repository().post(
          url:
          '${Repository().nuXtJsUrlApi}api/Application/SuperAdminApiController/check_in_check_out_push_notification_to_users',
          body: {
            'type': 'missing_school',
            'student_record_ids': jsonEncode(idsForPush),
          },
          auth: true,
        );

        Get.defaultDialog(
          title: "Success",
          middleText: "Saved success",
          textConfirm: "OK",
          onConfirm: () {
            Get.back();
            Get.offAll(() => ListCheckStudentPage(
              subjectTeacherId: widget.subjectTeacherId,
              scheduleItemsId: widget.scheduleItemsId,
              className: widget.className,
              subjectName: widget.subjectName,
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

  /// -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fsize = size.width + size.height;

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
          // SEARCH (type-to-search)
          Padding(
            padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _onSearchChanged('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          // STUDENT LIST (filtered)
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  final sid = _studentIdOf(student);
                  final isSelectable = sid != -1;
                  final isSelected = selectedIds.contains(sid);

                  return GestureDetector(
                    onTap: isSelectable
                        ? () {
                      setState(() {
                        if (isSelected) {
                          selectedIds.remove(sid);
                        } else {
                          selectedIds.add(sid);
                        }
                      });
                    }
                        : null,
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
                            onChanged: isSelectable
                                ? (value) {
                              setState(() {
                                if (value == true) {
                                  selectedIds.add(sid);
                                } else {
                                  selectedIds.remove(sid);
                                }
                              });
                            }
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomText(
                              text:
                              "${index+1}. ${student['firstname']} ${student['lastname']} (${student['nickname'] ?? '-'})",
                              fontSize: fsize * 0.014,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if ((student['student_code'] ?? '')
                              .toString()
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "#${student['student_code']}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: fsize * 0.012,
                                ),
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

          // FOOTER INPUTS
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
                // Status
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  hint: const Text('Status'),
                  value: selectedStatus,
                  items: markStatusList.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(
                          "${item['name']} (- ${item['score'] ?? 0} Score)"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),

                const SizedBox(height: 8),

                // Note
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Date + Time (display-only)
                Row(
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabled: false,
                          ),
                          child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IgnorePointer(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Time",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabled: false,
                          ),
                          child: Text(
                            selectedTime.format(context),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Confirm
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIds.isEmpty
                          ? Colors.grey
                          : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedIds.isEmpty ? null : _onConfirm,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
