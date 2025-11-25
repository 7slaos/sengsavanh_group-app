import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/pages/teacher_recordes/check_in_map_page.dart';
import 'package:multiple_school_app/widgets/bottom_bill_bar.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

// Your controller & model
import '../../states/checkin-out-student/check_in_out_student_state.dart';
import '../../widgets/button_widget.dart';

class CheckInCheckOutPage extends StatefulWidget {
  const CheckInCheckOutPage({super.key, required this.type});
  final String type; // 's' | 't'
  static const _green = Color(0xFF2EBD59);

  @override
  State<CheckInCheckOutPage> createState() => _CheckInCheckOutPageState();
}

class _CheckInCheckOutPageState extends State<CheckInCheckOutPage> {
  final AppColor appColor = AppColor();
  late final CheckInOutStudentState controller;

  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final searchController = TextEditingController();

  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    // Put controller once per page instance
    controller = Get.put(CheckInOutStudentState(), tag: 'checkin-page', permanent: false);

    // Defer data load until after first frame to avoid "markNeedsBuild during build"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_bootstrapped) {
        _bootstrapped = true;
        controller.fetchData(type: widget.type);
      }
    });
  }


  Future<void> _selectDate(BuildContext context, String type) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set your desired range
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      if (type == 'start') {
        startDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      } else {
        endDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      }
    }
  }


  void searchBottomDialog() {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (context) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              height: size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomText(
                      text: 'start_date',
                      fontSize: fixSize(0.012, context),
                    ),
                    TextField(
                      controller: startDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'd/m/Y',
                        hintStyle: TextStyle(
                          color: appColor.grey,
                          fontSize: fixSize(0.012, context),
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () {
                              _selectDate(context, 'start');
                            }),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomText(
                      text: 'end_date',
                      fontSize: fixSize(0.012, context),
                    ),
                    TextField(
                      controller: endDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'd/m/Y',
                        hintStyle: TextStyle(
                          color: appColor.grey,
                          fontSize: fixSize(0.012, context),
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () {
                              _selectDate(context, 'end');
                            }),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Expanded(child: Container()),
                    ButtonWidget(
                        height: size.height * 0.06,
                        borderRadius: 10,
                        backgroundColor: appColor.mainColor,
                        onPressed: () async {
                          if (startDate.text != '' && endDate.text != '') {
                            String start = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(startDate.text));
                            String end = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(endDate.text));
                            controller.applyDateFilter(start, end, widget.type);
                          }
                          Get.back();
                        },
                        fontSize: fixSize(0.014, context),
                        text: 'search'),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Get.back();
              },
              child: CircleAvatar(
                backgroundColor: appColor.mainColor,
                child: Icon(
                  Icons.close,
                  color: appColor.white,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    startDate.dispose();
    endDate.dispose();
    searchController.dispose();
    // Optionally dispose controller if it is page-scoped
    if (Get.isRegistered<CheckInOutStudentState>(tag: 'checkin-page')) {
      Get.delete<CheckInOutStudentState>(tag: 'checkin-page', force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final isTablet = w >= 600;
      final scale = (w / 390).clamp(0.9, 1.3).toDouble();

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor.mainColor,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CustomText(
              text: 'scan-in-out',
              fontWeight: FontWeight.w700,
              color: appColor.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: appColor.white),
              onPressed: () {
                setState(() {
                  startDate.text = '';
                  endDate.text = '';
                });
                controller.applyDateFilter('', '', widget.type);
              },
              tooltip: 'Refresh',
            ),
            IconButton(
              icon: Icon(Icons.calendar_month, color: appColor.white),
              onPressed: () => {

                searchBottomDialog()
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // ===== Reactive body (read-only in builder) =====
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final err = controller.errorMessage.value;
              if (err.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: err, color: appColor.black),
                      SizedBox(height: fixSize(0.02, context)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.mainColor,
                        ),
                        onPressed: () => controller.refreshData(),
                        child: CustomText(text: 'Refresh'.tr, color: appColor.white),
                      ),
                    ],
                  ),
                );
              }

              final list = controller.dataList; // RxList<StudentCheckInOut>
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: fixSize(0.05, context), color: appColor.grey),
                      SizedBox(height: fixSize(0.01, context)),
                      CustomText(
                        text: 'not_found_data'.tr,
                        fontSize: fixSize(0.012, context),
                        color: appColor.grey,
                      ),
                    ],
                  ),
                );
              }

              final hasMore = controller.isMoreLoading.value;
              final count = list.length + (hasMore ? 1 : 0);

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: (isTablet ? 150 : 120) * scale),
                controller: controller.scrollController,
                itemCount: count,
                separatorBuilder: (_, __) => SizedBox(height: fixSize(0.005, context)),
                itemBuilder: (context, index) {
                  // loader row at end
                  if (index >= list.length) {
                    return Padding(
                      padding: EdgeInsets.all(fixSize(0.02, context)),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final StudentCheckInOut s = list[index];
                  final work = _fromModel(s);

                  return InkWell(
                    onTap: () {
                      if(s.status == 1) {
                        Get.to(
                              () =>
                              CheckInMapPage(
                                type: widget.type,
                                status: 'check_out',
                                id: s.id.toString(),
                              ),
                          transition: Transition.fadeIn,
                        );
                      }
                    },
                    child: _WorkTimeRow(scale: scale, model: work),
                  );
                },
              );
            }),

            // Bottom actions (non-reactive UI wrapper)
            BottomPillBar(
              scale: scale,
              isTablet: isTablet,
              teal: appColor.mainColor,
              type: widget.type,
              rightIcon: Icons.location_on,
              rightTap: (){
                Get.to(() => CheckInMapPage(type: widget.type,status: 'check_in'), transition: Transition.fadeIn);
              },
            ),
          ],
        ),
      );
    });
  }
}

// ---------- Row item ----------
class _WorkTimeRow extends StatelessWidget {
  const _WorkTimeRow({required this.scale, required this.model});

  final double scale;
  final WorkTime model;

  @override
  Widget build(BuildContext context) {
    final date = model.date;
    final day = date.day.toString();
    final mon = _laoMonthShort(date.month);
    final year = date.year.toString();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 12 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Date block
              SizedBox(
                width: 68 * scale,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26 * scale,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 6 * scale),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(mon, style: TextStyle(fontSize: 12 * scale, color: Colors.black87)),
                        Text(year, style: TextStyle(fontSize: 12 * scale, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),

              // check-in
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_downward_rounded, size: 18, color: CheckInCheckOutPage._green),
                    const SizedBox(width: 6),
                    Text(
                      model.checkIn ?? '-',
                      style: TextStyle(fontSize: 16 * scale, color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // check-out
              SizedBox(
                width: 94 * scale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(model.checkOut==null)
                      Icon(Icons.logout, size: fixSize(0.02, context),),
                    if(model.checkOut !=null) ...[
                    const Icon(Icons.arrow_upward_rounded, size: 18, color: CheckInCheckOutPage._green),
                    const SizedBox(width: 6),
                    Text(
                      model.checkOut ?? '-',
                      style: TextStyle(fontSize: 16 * scale, color: Colors.black87, fontWeight: FontWeight.w600),
                    )],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- UI view model ----------
class WorkTime {
  final DateTime date;
  final String? checkIn;   // "HH:mm"
  final String? checkOut;  // "HH:mm"
  final String? fullName;  // 'ສົມພອນ ສຳເພົານົນ (ນ້ອຍ)'
  final String? phone;

  const WorkTime({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.fullName,
    this.phone,
  });
}

// ---------- Helpers (parsing & formatting) ----------
String _laoMonthShort(int m) {
  const lo = ['', 'ມ.ກ.', 'ກ.ພ.', 'ມ.ນ.', 'ມ.ສ.', 'ພ.ພ.', 'ມິ.ຖ.', 'ກ.ລ.', 'ສ.ຫ.', 'ກ.ຍ.', 'ຕ.ລ.', 'ພ.ຈ.', 'ທ.ວ.'];
  return lo[m];
}

/// Parse ISO or "yyyy-MM-dd HH:mm:ss" → local DateTime
DateTime? _parseToLocal(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  final src = s.contains('T') ? s.trim() : s.trim().replaceFirst(' ', 'T');
  try {
    return DateTime.parse(src).toLocal(); // handles ...Z too
  } catch (_) {
    try {
      return DateTime.parse(src.replaceAll('Z', '')).toLocal();
    } catch (_) {
      return null;
    }
  }
}

/// Format to HH:mm
String? _fmtHm(DateTime? d) {
  if (d == null) return null;
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Convert your typed model → WorkTime (pure; no state mutations)
WorkTime _fromModel(StudentCheckInOut s) {
  final cin  = _parseToLocal(s.checkinDate);
  final cout = _parseToLocal(s.checkoutDate);

  final baseDate = cin ?? cout ?? DateTime.now();

  final first = (s.firstname).trim();
  final last  = (s.lastname).trim();
  final nick  = (s.nickname ?? '').trim();
  String? name = [first, last].where((e) => e.isNotEmpty).join(' ');
  if (nick.isNotEmpty) name = '$name ($nick)';
  if (name != null && name.trim().isEmpty) name = null;

  return WorkTime(
    date: baseDate,
    checkIn: _fmtHm(cin),      // "07:11"
    checkOut: _fmtHm(cout),    // "16:01"
    fullName: name,
    phone: (s.phone ?? '').trim().isEmpty ? null : s.phone!.trim(),
  );
}
