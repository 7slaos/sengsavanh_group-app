import 'dart:math' show sin, cos, atan2, sqrt, pi;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/pages/camera_scan_page.dart';
import 'package:multiple_school_app/states/checkin-out-student/check_in_out_student_state.dart';
import 'package:multiple_school_app/states/profile_state.dart';
import 'package:multiple_school_app/states/profile_student_state.dart';
import 'package:multiple_school_app/states/profile_teacher_state.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

import '../../widgets/bottom_bill_bar.dart';

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({
    super.key,
    required this.lat,
    required this.lng,
    required this.type,   // 't' = teacher, else student
    required this.status, // 'check_in' | 'check_out'
    this.id,
  });

  final String lat;
  final String lng;
  final String type;
  final String status;
  final String? id;

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  final AppColor appColor = AppColor();
  late final Color kRed;

  // States
  final ProfileState profileState = Get.put(ProfileState());
  final ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  final CheckInOutStudentState checkInOutStudentState = Get.put(CheckInOutStudentState());

  bool loading = true;

  String formatTimeNow({bool seconds = true}) {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final hh = two(now.hour);
    final mm = two(now.minute);
    final ss = two(now.second);
    return seconds ? '$hh:$mm:$ss' : '$hh:$mm';
  }

  final day = DateTime.now().day.toString();
  final month = DateTime.now().month.toString();
  final year = DateTime.now().year.toString();

  final _laoMonths = const [
    '', // pad index 0
    'ມັງກອນ', 'ກຸມພາ', 'ມີນາ', 'ເມສາ', 'ພຶດສະພາ', 'ມິຖຸນາ',
    'ກໍລະກົດ', 'ສິງຫາ', 'ກັນຍາ', 'ຕຸລາ', 'ພະຈິກ', 'ທັນວາ',
  ];

  String laoMonthName(int m) => _laoMonths[m];

  @override
  void initState() {
    super.initState();
    kRed = appColor.mainColor;
    _init();
  }

  Future<void> _init() async {
    // fetch setting times
    checkInOutStudentState.getSettingCheckInOutTimes(type: widget.type);
    // simulate small wait for initial UI (replace with real awaits if needed)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final isTablet = w >= 600;
      final scale = (w / 390).clamp(0.9, 1.25).toDouble();

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kRed,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 16,
          title: Text(
            "${'scan'.tr} ${widget.status == 'check_in' ? 'Check-In' : 'Check-Out'}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          actions: [
            GetBuilder<ProfileStudentState>(builder: (getPro) {
              return IconButton(
                onPressed: () {
                  Get.to(
                        () => CameraScanPage(
                      type: widget.type,
                      student_records_id: getPro.dataModels?.studentRecordsId,
                      id: widget.id,
                    ),
                    transition: Transition.fadeIn,
                  );
                },
                icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
                tooltip: 'scan'.tr,
              );
            }),
          ],
        ),
        body: GetBuilder<CheckInOutStudentState>(builder: (checkIn) {
          return GetBuilder<ProfileState>(builder: (getAdmin) {
            return GetBuilder<ProfileTeacherState>(builder: (tController) {
              // ---- Resolve teacher info once, outside of the list/UI usage ----
              String teacherFullName = '';
              String? teacherCode;

              if (tController.teacherModels != null) {
                final t = tController.teacherModels;
                teacherFullName = '${t?.firstname ?? ""} ${t?.lastname ?? ""}'.trim();
                teacherCode = t?.code;
              } else {
                final a = getAdmin.profiledModels;
                teacherFullName = '${a?.firstname ?? ""} ${a?.lastname ?? ""}'.trim();
                teacherCode = a?.code;
              }

              return GetBuilder<ProfileStudentState>(builder: (sController) {
                final student = sController.dataModels;
                final studentFullName =
                '${student?.firstname ?? ""} ${student?.lastname ?? ""}'.trim();

                return Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.only(bottom: (isTablet ? 120 : 104) * scale),
                      children: [
                        // Location panel
                        _LocationPanel(
                          scale: scale,
                          title: 'your_current_position',
                          lat: widget.lat,
                          lng: widget.lng,
                        ),
                        SizedBox(height: 14 * scale),

                        if (loading)
                          Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: appColor.mainColor,
                              size: 70,
                            ),
                          ),

                        if (!loading) ...[
                          _ResultCard(
                            scale: scale,
                            day: day,
                            month: laoMonthName(int.parse(month)),
                            year: year,
                            studentName: (widget.type == 'a' || widget.type == 't')
                                ? (teacherFullName.isEmpty ? '—' : teacherFullName)
                                : (studentFullName.isEmpty ? '—' : studentFullName),
                            teacherId:(widget.type == 'a' || widget.type == 't') ? (teacherCode ?? '') : null,
                            studentId: (widget.type == 'a' || widget.type == 't') ? null : (student?.code ?? ''),
                            time: formatTimeNow(seconds: true),
                          ),

                          if (checkIn.dataList.isNotEmpty) ...[
                            for (var i = 0; i < checkIn.dataList.length; i++)
                              _ResultCard(
                                scale: scale,
                                day: day,
                                month: laoMonthName(int.parse(month)),
                                year: year,
                                studentName:
                                '${checkIn.dataList[i].firstname ?? ""} ${checkIn.dataList[i].lastname ?? ""}',
                                studentId: checkIn.dataList[i].phone ?? "",
                                time: formatTimeNow(seconds: true),
                              ),
                          ],
                        ],
                      ],
                    ),

                    // Floating save button (right side)
                    if (!loading && checkInOutStudentState.checkHosLiDay == false)
                      Positioned(
                        right: 20 * scale,
                        bottom: (isTablet ? 108 : 92) * scale,
                        child: _SmallRoundBtn(
                          color: kRed,
                          icon: Icons.save,
                          onTap: () {
                            checkInOutStudentState.confirmCheckInOut(
                              context: context,
                              type: widget.type,
                              id: widget.id,
                              student_records_id: student?.id.toString() ?? '',
                            );
                          },
                        ),
                      ),

                    // Optional note when not allowed
                    if (checkInOutStudentState.checkHosLiDay == true)
                      Positioned(
                        right: 75 * scale,
                        bottom: (isTablet ? 108 : 92) * scale,
                        child: CustomText(
                          text: checkInOutStudentState.note,
                          color: appColor.red,
                          fontSize: fixSize(0.016, context),
                        ),
                      ),

                    // Bottom pill bar with ringed buttons
                    BottomPillBar(
                      scale: scale,
                      isTablet: isTablet,
                      teal: kRed,
                      type: widget.type,
                    ),
                  ],
                );
              });
            });
          });
        }),
      );
    });
  }

  /// Haversine distance in KM (optional helper)
  double haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0088;
    double toRad(double deg) => deg * pi / 180.0;

    final dLat = toRad(lat2 - lat1);
    final dLng = toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRad(lat1)) * cos(toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }
}

// ---------------- Location panel ----------------
class _LocationPanel extends StatelessWidget {
  const _LocationPanel({
    required this.scale,
    required this.title,
    this.lat,
    this.lng,
  });

  final double scale;
  final String title;
  final String? lat;
  final String? lng;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 12 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr,
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8 * scale),
            _kv('Latitude:', lat ?? '-'),
            SizedBox(height: 4 * scale),
            _kv('Longitude:', lng ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Row(
    children: [
      Text(
        k,
        style: TextStyle(
          fontSize: 13 * scale,
          color: Colors.black.withOpacity(.7),
        ),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          v,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13 * scale, color: Colors.black87),
        ),
      ),
    ],
  );
}

// ---------------- Result card ----------------
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.scale,
    required this.day,
    required this.month,
    required this.year,
    required this.studentName,
    this.studentId,
    this.teacherId,
    required this.time,
  });

  final double scale;
  final String day;
  final String month;
  final String year;
  final String studentName;
  final String? studentId;
  final String? teacherId;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * scale),
      child: Material(
        elevation: 4,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 10 * scale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date block
              SizedBox(
                width: 72 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 28 * scale,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(month, style: TextStyle(fontSize: 12 * scale)),
                            Text(
                              year,
                              style: TextStyle(
                                fontSize: 12 * scale,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // info block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name line
                    Text(
                      studentName.isEmpty ? '—' : studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // id line (teacher or student)
                    Text(
                      (teacherId != null && teacherId!.isNotEmpty)
                          ? 'ລະຫັດອາຈານ: $teacherId'
                          : 'ລະຫັດນັກຮຽນ: ${studentId ?? ""}',
                      style: TextStyle(fontSize: 13 * scale, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallRoundBtn extends StatelessWidget {
  const _SmallRoundBtn({
    required this.color,
    required this.icon,
    this.onTap,
  });

  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(Icons.save, color: Colors.white), // icon param handled by parent
        ),
      ),
    );
  }
}
