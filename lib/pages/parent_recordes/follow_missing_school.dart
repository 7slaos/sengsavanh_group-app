import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:intl/intl.dart';

class FollowMissingSchool extends StatefulWidget {
  const FollowMissingSchool({super.key});

  @override
  State<FollowMissingSchool> createState() => _FollowMissingSchoolState();
}

class _FollowMissingSchoolState extends State<FollowMissingSchool> {
  final AppColor appColor = AppColor();
  final repo = Repository();

  // ========== UI & State ==========
  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController endDateCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  bool isLoading = false;
  String? errorText;

  // รายการประวัติ (ตัดคะแนนรายวิชา)
  List<Map<String, dynamic>> items = [];

  // คะแนนสรุปรวมจาก API
  int totalScore = 0;   // ຄະແນນຄຸນສົມບັດທັງໝົດ
  int cutScore = 0;     // ຄະແນນຖືກຕັດ
  int remainScore = 0;  // ຄະແນນຄົງເຫຼືອ

  // debounce สำหรับ search
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = DateTime(today.year, today.month, today.day);
    endDate = DateTime(today.year, today.month, today.day);
    startDateCtrl.text = _fmt(startDate!);
    endDateCtrl.text = _fmt(endDate!);

    // โหลดครั้งแรก
    _fetchData();

    // เฝ้าฟังการพิมพ์ในกล่องค้นหา แล้วยิง _fetchData แบบ debounce
    searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (mounted) _fetchData();
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _fmt(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

  String formatDateTime(String? input) {
    if (input == null || input.isEmpty) return '-';
    try {
      final dt = DateTime.parse(input);
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return input;
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? (startDate ?? now) : (endDate ?? now);
    final first = DateTime(now.year - 3, 1, 1);
    final last = DateTime(now.year + 3, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: isStart ? 'ເລືອກວັນທີ່ເລີ່ມ' : 'ເລືອກວັນທີ່ສິ້ນສຸດ',
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          startDateCtrl.text = _fmt(picked);
          if (endDate == null || endDate!.isBefore(startDate!)) {
            endDate = picked;
            endDateCtrl.text = _fmt(picked);
          }
        } else {
          endDate = picked;
          endDateCtrl.text = _fmt(picked);
          if (startDate != null && endDate!.isBefore(startDate!)) {
            startDate = endDate;
            startDateCtrl.text = _fmt(startDate!);
          }
        }
      });
      _fetchData(); // โหลดใหม่เมื่อเปลี่ยนวัน
    }
  }

  // ===== โหลดข้อมูลตัดคะแนน + คะแนนสรุปจาก API =====
 Future<void> _fetchData() async {
  if (startDate == null || endDate == null) return;

  setState(() {
    isLoading = true;
    errorText = null;
  });

  try {
    final q = searchCtrl.text.trim();

    final resp = await repo.getStudentMissingSchoolAPI( // หรือ getStudentMissingSchoolAPI ถ้าคุณใช้เมธอดเดิม
      startDate: startDate!,
      endDate: endDate!,
      q: q,
    );

    if (resp['success'] == true) {
      // ----- 1) แปลง data_list -----
      final dl = resp['data_list'];
      List<Map<String, dynamic>> out = [];
      if (dl is List) {
        out = dl.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return e;
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      }

      // ----- 2) totalScore จาก academy_year.score -----
      int academyScore = 0;
      final meta = resp['meta'];
      if (meta is Map) {
        final activeAY = meta['active_academy_year'];
        if (activeAY is Map) {
          final s = activeAY['score'];
          if (s is int) academyScore = s;
          if (s is String) academyScore = int.tryParse(s) ?? 0;
        }
      }

      // ----- 3) cutScore = SUM(score) จาก data_list -----
      int sumCut = 0;
      for (final row in out) {
        final v = row['score'];
        if (v is int) sumCut += v;
        if (v is String) sumCut += int.tryParse(v) ?? 0;
      }

      // ----- 4) remainScore -----
      final remain = (academyScore - sumCut);
      final remainSafe = remain < 0 ? 0 : remain;

      setState(() {
        items = out;
        totalScore = academyScore; // จาก academy_year
        cutScore = sumCut;         // รวมที่ถูกตัด
        remainScore = remainSafe;  // เหลือ
      });
    } else {
      setState(() {
        errorText = (resp['message'] ?? 'Error').toString();
        items = [];
        totalScore = 0;
        cutScore = 0;
        remainScore = 0;
      });
    }
  } catch (e) {
    setState(() {
      errorText = e.toString();
      items = [];
      totalScore = 0;
      cutScore = 0;
      remainScore = 0;
    });
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  int get sumTotalFromList {
    // fallback เผื่ออยากเทียบกับ sum ในหน้าจอ
    return items.fold<int>(0, (prev, e) {
      final v = e['score'];
      if (v is int) return prev + v;
      if (v is String) return prev + (int.tryParse(v) ?? 0);
      return prev;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fSize = size.width + size.height;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'missing_school'),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.005),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.01),

            // === แถวบน: Start / End Date ===
            Row(
              children: [
                Expanded(
                  child: _DateBox(
                    label: 'ວັນທີເລີ່ມ',
                    controller: startDateCtrl,
                    onTap: () => _pickDate(isStart: true),
                    appColor: appColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DateBox(
                    label: 'ວັນທີສິ້ນສຸດ',
                    controller: endDateCtrl,
                    onTap: () => _pickDate(isStart: false),
                    appColor: appColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.01),

            // === Search Box แทน Dropdown นักเรียน ===
            TextField(
              controller: searchCtrl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'ຄົ້ນຫານັກຮຽນ (ຊື່, ນາມສະກຸນ, ຊື່ຫຼິ້ນ, ID)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: (searchCtrl.text.isEmpty)
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchCtrl.clear();
                          _fetchData();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _fetchData(),
            ),

            SizedBox(height: size.height * 0.01),

            // === Loader/Error ===
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
            if (!isLoading && errorText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomText(text: errorText!, color: Colors.red),
              ),

            // === รายการประวัติถูกตัดคะแนน ===
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _fetchData(),
                child: items.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 80),
                          Center(child: CustomText(text: 'ບໍ່ພົບຂໍ້ມູນ')),
                        ],
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final item = items[i];
                          final firstname = (item['firstname'] ?? '').toString();
                          final lastname = (item['lastname'] ?? '').toString();
                          final nickname = (item['nickname'] ?? '-').toString();
                          final code = (item['user_code'] ?? item['code'] ?? '').toString();
                          final dated = (item['dated'] ?? '').toString();
                          final subject = (item['subject_name'] ?? '-').toString();
                          final scoreAny = item['score'];
                          final note = (item['note'] ?? '').toString();
                          final className = (item['class_name'] ?? '-').toString();

                          final scoreText = (scoreAny is int)
                              ? scoreAny.toString()
                              : (scoreAny is String ? scoreAny : '');

                          return Container(
                            padding: EdgeInsets.all(fSize * 0.01),
                            decoration: BoxDecoration(
                              color: appColor.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: fixSize(0.0025, context),
                                  offset: const Offset(0, 1),
                                  color: appColor.grey,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(fSize * 0.01),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ວິຊາ + ວັນເວລາ
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: 'ວິຊາ: $subject',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: appColor.mainColor,
                                      ),
                                    ),
                                    CustomText(
                                      text: 'ວັນເວລາ: ${formatDateTime(dated)}',
                                      fontSize: 16,
                                      color: appColor.grey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // ຊື່ + code + ຫ້ອງ
                                CustomText(
                                  text: '$firstname $lastname ($nickname)  •  ID: $code',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  text: 'ຫ້ອງ: $className',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                const SizedBox(height: 4),

                                // ຄະແນນຖືກຕັດ
                                CustomText(
                                  text: 'ຕັດຄະແນນ: - $scoreText',
                                  fontSize: 16,
                                  color: appColor.red.withOpacity(0.9),
                                ),

                                // ໝາຍເຫດ
                                if (note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: CustomText(
                                      text: 'ເຫດຜົນ: $note',
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      // === ສະຫຼຸບຄະແນນຄຸນສົມບັດ ===
     // === ສະຫຼຸບຄະແນນຄຸນສົມບັດ ===
bottomNavigationBar: Container(
  padding: const EdgeInsets.all(12),
  decoration: const BoxDecoration(
    border: Border(top: BorderSide(width: 2, color: Colors.black45)),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      // จาก academy_year.score
      CustomText(
        text: 'ຄະແນນຄຸນສົມບັດທັງໝົດ: $totalScore',
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      const SizedBox(height: 4),

      // รวมจาก data_list
      CustomText(
        text: 'ລວມຄະແນນຖືກຕັດ: -$cutScore',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: appColor.red,
      ),
      const SizedBox(height: 4),

      // เหลือ = total - cut (ไม่ติดลบ)
      CustomText(
        text: 'ຄະແນນຄຸນສົມບັດຄົງເຫຼືອ: $remainScore',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: appColor.mainColor,
      ),
    ],
  ),
),

    );
  }
}

// ===== Widget กล่องเลือกวันที่ =====
class _DateBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final AppColor appColor;

  const _DateBox({
    required this.label,
    required this.controller,
    required this.onTap,
    required this.appColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(8, 169, 169, 169).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.event, color: appColor.mainColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.text.isEmpty ? label : controller.text,
                style: TextStyle(
                  color: controller.text.isEmpty ? appColor.grey : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}