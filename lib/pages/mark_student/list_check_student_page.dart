import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/mark_student/subject_teacher_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

import 'check_student_page.dart';

class ListCheckStudentPage extends StatefulWidget {
  final int subjectTeacherId;
  final int scheduleItemsId;
  final String className;
  final String subjectName;

  const ListCheckStudentPage({
    super.key,
    required this.subjectTeacherId,
    required this.scheduleItemsId,
    required this.className,
    required this.subjectName,
  });

  @override
  State<ListCheckStudentPage> createState() => _ListCheckStudentPageState();
}

class _ListCheckStudentPageState extends State<ListCheckStudentPage> {
  final AppColor appColors = AppColor();
  final Repository repo = Repository();

  // ---- date range state (default = today → today)
  late DateTime _startDate;
  late DateTime _endDate;

  // data + loading states
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
    _load(); // initial fetch
  }

  String _fmtYMD(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // keep range valid
      setState(() {
        _startDate = DateTime(picked.year, picked.month, picked.day);
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
      });
      _load();
    }
  }

  Future<void> _pickEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = DateTime(picked.year, picked.month, picked.day);
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      });
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Build the URL directly (uses new API with start_date & end_date)
      final base = repo.nuXtJsUrlApi.endsWith('/')
          ? repo.nuXtJsUrlApi.substring(0, repo.nuXtJsUrlApi.length - 1)
          : repo.nuXtJsUrlApi;
      final path = repo.GetCheckMissingSchools.startsWith('/')
          ? repo.GetCheckMissingSchools.substring(1)
          : repo.GetCheckMissingSchools;

      final uri = Uri.parse('$base/$path').replace(queryParameters: {
        'schedule_items_id': '${widget.scheduleItemsId}',
        'start_date': _fmtYMD(_startDate),
        'end_date': _fmtYMD(_endDate),
      });

      final res = await repo.getNUxt(
        url: uri.toString(),
        header: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${repo.appVerification.nUxtToken}',
        },
      );

      final text = (() {
        try {
          return utf8.decode(res.bodyBytes);
        } catch (_) {
          return res.body;
        }
      })();

      if (res.statusCode == 200) {
        final map = jsonDecode(text) as Map<String, dynamic>;
        final list = (map['items'] ?? []) as List;
        setState(() {
          _items = list.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'HTTP ${res.statusCode}: $text';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<bool?> _showEditForm(Map<String, dynamic> student) async {
    final scoreController =
        TextEditingController(text: student['score']?.toString() ?? '');
    final noteController =
        TextEditingController(text: student['note']?.toString() ?? '');

    // parse DB datetime "YYYY-MM-DD HH:mm:ss"
    DateTime? _parseDbDT(String? s) {
      if (s == null || s.isEmpty) return null;
      try {
        final fixed = s.contains('T') ? s : s.replaceFirst(' ', 'T');
        return DateTime.parse(fixed);
      } catch (_) {
        return null;
      }
    }

    final existingDT = _parseDbDT(student['dated']?.toString());
    DateTime selectedDate = existingDT ?? DateTime.now();
    TimeOfDay selectedTime = existingDT != null
        ? TimeOfDay(hour: existingDT.hour, minute: existingDT.minute)
        : TimeOfDay.now();

    int? statusValue = (student['status'] is int)
        ? student['status'] as int
        : int.tryParse("${student['status'] ?? ''}") ?? 1;

    String _formatDate(DateTime d) =>
        "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
    String _formatTime(TimeOfDay t) =>
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isSaving = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> _save() async {
              final id = student['id'];
              if (id == null) {
                Get.snackbar("Error", "Missing record id",
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              final rawScore = scoreController.text.trim();
              final int? score =
                  rawScore.isEmpty ? null : int.tryParse(rawScore);
              if (rawScore.isNotEmpty && score == null) {
                Get.snackbar("Warning", "Score should be a number",
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              if (statusValue == null || statusValue == 0) {
                Get.snackbar("Warning", "Please select status",
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              final dated =
                  "${_formatDate(selectedDate)} ${_formatTime(selectedTime)}:00";

              try {
                setSheetState(() => isSaving = true);

                final res = await repo.editCheckMissingStudentAPI(
                  id: id is int ? id : int.tryParse(id.toString()) ?? -1,
                  score: score,
                  status: statusValue,
                  note: noteController.text.trim().isEmpty
                      ? null
                      : noteController.text.trim(),
                  dated: dated,
                );

                if (res['success'] == true) {
                  Get.back(result: true);
                  Get.snackbar("Success", "Updated successfully",
                      snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
                } else {
                  Get.snackbar(
                    "Error",
                    res['message']?.toString() ?? "Update failed",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              } catch (e) {
                Get.snackbar("Error", e.toString(),
                    snackPosition: SnackPosition.BOTTOM);
              } finally {
                setSheetState(() => isSaving = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      "ແກ້ໄຂຂໍ້ມູນ: ${student['firstname']} ${student['lastname']}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Status + Score
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<int>(
                            value: statusValue,
                            decoration: const InputDecoration(
                              labelText: "ສະຖານະ",
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 1, child: Text("ຂາດໝົດມື້")),
                              DropdownMenuItem(value: 2, child: Text("ມາຊ້າ")),
                            ],
                            onChanged: (v) =>
                                setSheetState(() => statusValue = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: scoreController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "ຄະແນນ",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date + Time
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
                                setSheetState(() => selectedDate = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: "ວັນທີ",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                  "${_fmtYMD(selectedDate)}"), // user sees Y-M-D
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null) {
                                setSheetState(() => selectedTime = picked);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: "ເວລາ",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                  "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: "ໝາຍເຫດ",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white, // ສີຂໍ້ຄວາມ
                          padding: const EdgeInsets.symmetric(vertical: 14), // ກຳນົດຄວາມສູງ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // ໂຄ້ງມຸມ
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("ແກ້ໄຂ"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

Future<void> _confirmDelete(Map<String, dynamic> row) async {
  // get numeric id safely
  final int? id = row['id'] is int
      ? row['id'] as int
      : int.tryParse("${row['id'] ?? ''}");

  if (id == null) {
    Get.snackbar("Error", "Record id not found", snackPosition: SnackPosition.BOTTOM);
    return;
  }

  // confirm dialog
  final bool? ok = await Get.defaultDialog<bool?>(
    title: "Confirm delete",
    middleText:
        "${row['firstname'] ?? ''} ${row['lastname'] ?? ''}",
    textCancel: "Cancel",
    textConfirm: "Delete",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () => Get.back(result: true),
    onCancel: () => Get.back(result: false),
  );

  if (ok != true) return;

  try {
    final resp = await repo.deleteCheckMissingAPI(id: id);
    if (resp['success'] == true) {
      Get.snackbar("Deleted", "Delete success", snackPosition: SnackPosition.BOTTOM);
      _load(); // refresh list
    } else {
      Get.snackbar("Error", resp['message']?.toString() ?? "Delete failed",
          snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}


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
          text: 'Students - ${widget.className} (${widget.subjectName})',
          color: appColors.white,
        ),
// ใน AppBar
leading: IconButton(
  icon: Icon(Icons.arrow_back, color: appColors.white),
  onPressed: () {
    // ไปหน้า SubjectTeacherPage แบบเคลียร์ stack ทั้งหมด
    Get.offAll(() => const SubjectTeacherPage());
  },
),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {
              Get.to(
                () => CheckStudentPage(
                  subjectTeacherId: widget.subjectTeacherId,
                  scheduleItemsId: widget.scheduleItemsId,
                  className: widget.className,
                  subjectName: widget.subjectName,
                ),
                transition: Transition.rightToLeft,
              )?.then((_) => _load());
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start & End Date selectors
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStart,
                    child: _dateBox(
                      label:
                          "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                      icon: Icons.date_range,
                      color: appColors.mainColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _pickEnd,
                    child: _dateBox(
                      label:
                          "${_endDate.day}/${_endDate.month}/${_endDate.year}",
                      icon: Icons.event,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data area
            if (_loading)
              const Expanded(
                  child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              Expanded(child: Center(child: Text('Error: $_error')))
            else if (_items.isEmpty)
              const Expanded(child: Center(child: Text('No data')))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final student = _items[index];
                      return GestureDetector(
                        onTap: () async {
                          final updated = await _showEditForm(student);
                          if (updated == true) _load();
                        },
                        child: Container(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    "${student['firstname']} ${student['lastname']} (${student['nickname'] ?? ''})",
                                fontSize: fsize * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.score,
                                      size: fsize * 0.014,
                                      color: appColors.mainColor),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text:
                                        "${student['score']?.toString() ?? '-'} ຄະແນນ",
                                    fontSize: fsize * 0.013,
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.sticky_note_2,
                                      size: fsize * 0.014,
                                      color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: CustomText(
                                      text: student['note']?.toString() ?? '',
                                      fontSize: fsize * 0.013,
                                      color: Colors.grey[700],
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.access_time,
                                      size: fsize * 0.014, color: Colors.green),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text:
                                        (student['time']?.toString() ?? '').toString(),
                                    fontSize: fsize * 0.013,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        size: fsize * 0.018, color: Colors.red),
                                    onPressed: () => _confirmDelete(student),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(
      {required String label, required IconData icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: appColors.white,
        border: Border.all(color: color ?? appColors.mainColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
