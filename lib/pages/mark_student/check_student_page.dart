import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/pages/mark_student/list_check_student_page.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

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
  String? startTimeMark;
  String? endTimeMark;
  bool markTimeLoaded = false;
  Timer? _countdownTimer;
  String countdownText = '';

  @override
  void initState() {
    super.initState();
    _fetchMarkTimeWindow();
    _fetchMarkStatus();
    _fetchStudents();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
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
        Get.snackbar("error".tr, "no_status_found".tr);
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
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
          Get.snackbar("notice".tr, "no_students_found".tr);
        }
      } else {
        setState(() => isLoading = false);
        Get.snackbar("error".tr, data['message'] ?? "no_students_found".tr);
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("error".tr, e.toString());
    }
  }

  Future<void> _fetchMarkTimeWindow() async {
    try {
      final data = await repo.getBranchMarkTimeAPI();
      if (data['success'] == true) {
        final payload = (data['data'] ?? {}) as Map<String, dynamic>;
        final s = (payload['start_time_mark'] ?? '').toString();
        final e = (payload['end_time_mark'] ?? '').toString();
        if (!mounted) return;
        setState(() {
          startTimeMark = s.isNotEmpty && s.toLowerCase() != 'null' ? s : null;
          endTimeMark = e.isNotEmpty && e.toLowerCase() != 'null' ? e : null;
          markTimeLoaded = true;
        });
        _startCountdownTimer();
      } else {
        markTimeLoaded = true;
        _startCountdownTimer();
      }
    } catch (_) {
      markTimeLoaded = true;
      _startCountdownTimer();
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  DateTime? _parseTimeToday(String? value) {
    if (value == null) return null;
    final text = value.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    final parts = text.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final s = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      h.clamp(0, 23),
      m.clamp(0, 59),
      s.clamp(0, 59),
    );
  }

  bool get _isWithinMarkWindow {
    final start = _parseTimeToday(startTimeMark);
    final end = _parseTimeToday(endTimeMark);
    if (start == null || end == null) return true; // no config -> allow
    final now = DateTime.now();
    if (now.isBefore(start)) return false;
    if (now.isAfter(end)) return false;
    return true;
  }

  String _formatDuration(Duration d) {
    final hh = d.inHours.remainder(100).abs().toString().padLeft(2, '0');
    final mm = d.inMinutes.remainder(60).abs().toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).abs().toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    final end = _parseTimeToday(endTimeMark);
    if (end == null) return;
    // kick once immediately
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final end = _parseTimeToday(endTimeMark);
    if (end == null) {
      if (countdownText.isNotEmpty) {
        setState(() => countdownText = '');
      }
      return;
    }
    final now = DateTime.now();
    final diff = end.difference(now);
    String nextText;
    if (diff.isNegative) {
      nextText = "${'mark_time_closed'.tr} (${_formatDuration(diff)})";
    } else {
      nextText = "${'mark_time_remaining'.tr} ${_formatDuration(diff)}";
    }
    if (mounted && nextText != countdownText) {
      setState(() => countdownText = nextText);
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
      Get.snackbar("warning".tr, "please_select_students".tr);
      return;
    }

    if (noteController.text.isEmpty) {
      Get.snackbar("warning".tr, "please_input_note".tr);
      return;
    }

    if (selectedStatus == null) {
      Get.snackbar("warning".tr, "please_select_status".tr);
      return;
    }

    if (!_isWithinMarkWindow) {
      Get.snackbar("warning".tr, "mark_time_closed".tr);
      return;
    }

    final selectedStatusItem = markStatusList.firstWhere(
          (item) => item['id'] == selectedStatus,
      orElse: () => {},
    );
    final scoreValue = selectedStatusItem['score'] ?? 0;

    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    selectedTime = TimeOfDay.fromDateTime(now);
    final combinedDateTime = now;

    final formattedDateTime =
        "${combinedDateTime.toIso8601String().split('.')[0].replaceFirst('T', ' ')}";

    final chosen = students
        .where((s) => selectedIds.contains(_studentIdOf(s)))
        .toList();

    if (chosen.isEmpty) {
      Get.snackbar("warning".tr, "no_selected_students".tr);
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
          title: "success".tr,
          middleText: "saved_success".tr,
          textConfirm: "ok".tr,
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
        Get.snackbar("error".tr, result['message'] ?? "save_failed".tr);
      }
    } catch (e) {
      Get.snackbar("error".tr, e.toString());
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
          text:
              '${'mark_students_title'.tr} - ${widget.className} (${widget.subjectName})',
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
                  hint: Text('status'.tr),
                  value: selectedStatus,
                  items: markStatusList.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(
                          "${item['name']} (- ${item['score'] ?? 0} ${'score'.tr})"),
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
                    hintText: 'note'.tr,
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
                            labelText: "date".tr,
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
                            labelText: "time".tr,
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

                if (markTimeLoaded && countdownText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      countdownText,
                      style: TextStyle(
                        color: _isWithinMarkWindow ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

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
                    child: Text('confirm'.tr),
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
