import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class HistoryMissingSchoolPage extends StatefulWidget {
  const HistoryMissingSchoolPage({super.key});

  @override
  State<HistoryMissingSchoolPage> createState() =>
      _HistoryMissingSchoolPageState();
}

class _HistoryMissingSchoolPageState extends State<HistoryMissingSchoolPage> {
  final AppColor appColor = AppColor();

  // ---- Date range (default today) ----
  late DateTime _startDate;
  late DateTime _endDate;

  // ---- Loading & data ----
  bool _loading = false;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistory();
    });
  }

  // ---------------- helpers ----------------
  String _two(int n) => n.toString().padLeft(2, '0');
  String _dmy(DateTime d) => '${_two(d.day)}-${_two(d.month)}-${d.year}';
  String _ymd(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

  List<Map<String, dynamic>> _safeListMap(dynamic v) {
    if (v is List) {
      return v.map<Map<String, dynamic>>((e) {
        if (e is Map<String, dynamic>) return e;
        if (e is Map) return Map<String, dynamic>.from(e);
        return <String, dynamic>{};
      }).toList();
    }
    return const [];
  }

  String _onlyTime(dynamic raw) {
    if (raw == null) return '-';
    if (raw is String) {
      if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(raw)) return raw; // HH:mm:ss
      final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})')
          .firstMatch(raw);
      if (m != null) return '${m.group(4)}:${m.group(5)}:${m.group(6)}';
    }
    return raw.toString();
  }

  String _dateDMYFromItem(Map<String, dynamic> item) {
    final dayVte = item['day_vte'];
    if (dayVte is String && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dayVte)) {
      final p = dayVte.split('-'); // YYYY-MM-DD
      return '${p[2]}-${p[1]}-${p[0]}';
    }
    final ci = item['checkin_date'];
    if (ci is String && ci.length >= 10) {
      final y = ci.substring(0, 4),
          m = ci.substring(5, 7),
          d = ci.substring(8, 10);
      return '$d-$m-$y';
    }
    return _dmy(_startDate);
  }

  String _safeStr(dynamic v, {String fallback = '-'}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final init = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: appColor.mainColor,
            onPrimary: appColor.white,
            onSurface: appColor.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(picked.year, picked.month, picked.day);
          if (_startDate.isAfter(_endDate)) _endDate = _startDate;
        } else {
          _endDate = DateTime(picked.year, picked.month, picked.day);
          if (_endDate.isBefore(_startDate)) _startDate = _endDate;
        }
      });
      _fetchHistory();
    }
  }

  // ---------------- API ----------------
  Future<void> _fetchHistory() async {
    setState(() => _loading = true);
    try {
      final repo = Repository();
      final token = repo.appVerification.nUxtToken;
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token not found, please login again',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        setState(() => _loading = false);
        return;
      }

      // ✅ เรียกแบบ “ดึงทั้งหมด” ตามช่วงวันที่ (ไม่ส่ง page/perPage)
      final map = await repo.getHistoryCheckInOutAPI(
        startDate: _startDate,
        endDate: _endDate,
        // ไม่ต้องส่ง studentRecordsId ถ้าต้องการข้อมูลลูกทั้งหมดของผู้ปกครอง
      );

      if (map['success'] == true) {
        final list = _safeListMap(map['data_list']);
        // (ถ้าอยากเช็คความยาว ให้ print ได้)
        // print('data_list length = ${list.length}');
        setState(() => _history = list);
      } else {
        final msg = map['message'] ?? 'Fetch failed';
        Get.snackbar('Error', msg.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'check_in_check_out'),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.01),

          // date filters only
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Start: ${_dmy(_startDate)}'),
                    onPressed: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text('End:   ${_dmy(_endDate)}'),
                    onPressed: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
          ),

          // list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: CustomText(
                          text: 'No history in selected range',
                          color: appColor.grey,
                        ),
                      )
                    : RefreshIndicator(
                        color: appColor.mainColor,
                        onRefresh: () async => _fetchHistory(),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                          itemCount: _history.length,
                          itemBuilder: (_, i) {
                            final row = _history[i];

                            // ===== เตรียมข้อมูล =====
                            final first =
                                _safeStr(row['firstname'], fallback: '');
                            final last =
                                _safeStr(row['lastname'], fallback: '');
                            final nick =
                                _safeStr(row['nickname'], fallback: '');
                            final cls =
                                _safeStr(row['class_name'], fallback: '-');

                            final code = _safeStr(
                                row['admission_number'] ?? row['code'],
                                fallback: '');
                            final nameLine = (first.isEmpty && last.isEmpty)
                                ? '-'
                                : '$first $last${nick.isEmpty ? '' : ' ($nick)'}';

                            final dateDMY = _dateDMYFromItem(row);
                            final inTime = _onlyTime(
                                row['checkin_time'] ?? row['checkin_date']);
                            final outTime = _onlyTime(
                                row['checkout_time'] ?? row['checkout_date']);
                            final note = _safeStr(row['note'], fallback: '');
                            final status =
                                row['status']; // 1 waiting, 2 success

                            // สี badge ตามสถานะ
                            final badgeColor = (status == 2)
                                ? Colors.green.withOpacity(.12)
                                : Colors.orange.withOpacity(.12);
                            final badgeTextColor =
                                (status == 2) ? Colors.green : Colors.orange;
                            final statusText =
                                (status == 2) ? 'success' : 'waiting';

                            // รูป (รองรับทั้ง avatarUrl และ imageStudent)
                            final rawImg = _safeStr(
                                row['avatarUrl'] ?? row['imageStudent'],
                                fallback: '');
                            final imgUrl = rawImg.isEmpty
                                ? ''
                                : rawImg.startsWith('http')
                                    ? rawImg
                                    : '${Repository().nuXtJsUrlApi}$rawImg';

                            // ขนาดตัวอักษรแบบเดียวกับหน้าบน
                            double fSize(double r) => fixSize(r, context);

                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fSize(0.005)),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: appColor.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: fixSize(0.0025, context),
                                          offset: const Offset(0, 1),
                                          color: appColor.grey,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(fSize(0.01)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // ===== รูปเหมือนการ์ดด้านบน =====
                                        Container(
                                          width: size.width * 0.25,
                                          height: size.width * 0.25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3,
                                                color: appColor.mainColor),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.zero,
                                            child: imgUrl.isEmpty
                                                ? Image.asset(
                                                    'assets/images/logo.png',
                                                    fit: BoxFit.cover)
                                                : CachedNetworkImage(
                                                    imageUrl: imgUrl,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: appColor
                                                                  .white),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            'assets/images/logo.png',
                                                            fit: BoxFit.cover),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),

                                        // ===== ข้อมูลด้านขวา =====
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // รหัสนักเรียน
                                              // CustomText(
                                              //   text: '${'label_code'.tr}: ${code.isEmpty ? 'XXXXXX' : code}',
                                              //   color: appColor.mainColor,
                                              //   fontSize: fSize(0.0145),
                                              // ),

                                              // ชื่อ-สกุล (+ชื่อเล่น)
                                              SizedBox(
                                                width: size.width * 0.65,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: CustomText(
                                                        text: nameLine,
                                                        color:
                                                            appColor.mainColor,
                                                        fontSize: fSize(0.0145),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // ✅ แทนที่ "วันเกิด" → เวลาเข้า/ออก
                                              CustomText(
                                                text:
                                                    '${'class_room'.tr}: ${cls == '-' ? '' : cls} ${cls == '-' ? '' : '• '} $dateDMY',
                                                fontSize: fSize(0.0145),
                                                color: appColor.black
                                                    .withOpacity(0.5),
                                              ),
                                              // แสดงสอง pill เล็กๆ ให้ดูชัด
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  _pill(
                                                      'IN',
                                                      (inTime == 'null' ||
                                                              inTime.isEmpty)
                                                          ? '-'
                                                          : inTime),
                                                  const SizedBox(width: 8),
                                                  _pill(
                                                      'OUT',
                                                      (outTime == 'null' ||
                                                              outTime.isEmpty)
                                                          ? '-'
                                                          : outTime),
                                                ],
                                              ),

                                              // ชั้นเรียน + วันที่
                                              const SizedBox(height: 2),

                                              if (note.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  note,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                       
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // วงกลมเลขลำดับมุมขวาบน เหมือนการ์ดบนนั้น
                                CircleAvatar(
                                  backgroundColor: appColor.mainColor,
                                  child: CustomText(
                                    text: '${i + 1}',
                                    color: appColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
