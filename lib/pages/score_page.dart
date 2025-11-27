// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/pages/detail_score_page.dart';
import 'package:multiple_school_app/models/subject_teacher_student_model.dart';
import 'package:multiple_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:multiple_school_app/states/about_score_state.dart';
import 'package:multiple_school_app/states/date_picker_state.dart';
import 'package:multiple_school_app/states/history_payment_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final LocaleState localeState = Get.put(LocaleState());
  final PaymentState paymentState = Get.put(PaymentState());
  final DatePickerState datePickerState = Get.put(DatePickerState());
  final AboutScoreState scoreState = Get.put(AboutScoreState());
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());

  int indexCategory = 0;
  int classId = 0;
  String monthly = '${DateTime.now().month}/${DateTime.now().year}';
  String selectedClassName = '';
  int tabIndex = 0; // 0: ຕາຕະລາງກວດກາ, 1: ຕາຕະລາງສອບເສັງ

  @override
  void initState() {
    super.initState();
    datePickerState.setCurrentMonth();
    if (historyPaymentState.selectedMonth2.isEmpty ||
        historyPaymentState.selectedYear1.isEmpty) {
      historyPaymentState.setCurrentMonth();
    }
    _loadSubjectsForTab(tabIndex);
  }

  int _scheduleTypeForTab(int index) {
    // API accepts schedule types 2 or 3; map tabs to those values.
    return index == 0 ? 2 : 3;
  }

  Future<void> _loadSubjectsForTab(int index) async {
    final type = _scheduleTypeForTab(index);
    scoreState.resetTeacherSubjects();
    await scoreState.fetchTeacherSubjects(type);
    await _prefetchStudentsForActiveMonth();
  }

  Future<void> _prefetchStudentsForActiveMonth() async {
    final monthStr = historyPaymentState.selectedMonth2.isNotEmpty
        ? historyPaymentState.selectedMonth2
        : DateTime.now().month.toString().padLeft(2, '0');
    final yearStr = historyPaymentState.selectedYear1.isNotEmpty
        ? historyPaymentState.selectedYear1
        : DateTime.now().year.toString();
    final month = int.tryParse(monthStr) ?? DateTime.now().month;
    final year = int.tryParse(yearStr) ?? DateTime.now().year;
    final currentSubjects = scoreState.teacherSubjects;
    for (final subj in currentSubjects) {
      await scoreState.fetchSubjectTeacherStudents(
        subjectTeacherId: subj.subjectTeacherId,
        scheduleId: subj.scheduleId,
        year: year,
        month: month,
        force: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;
    final double fSize = size.width + size.height;
    final AppColor appColor = AppColor();
    final Random random = Random();

    // Generate a random color
    Color getRandomColor() {
      return Color.fromARGB(
        255, // Full opacity
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: InkWell(
          onTap: () {
            // Ensure back always lands on teacher dashboard
            if (Get.previousRoute.isNotEmpty && Get.previousRoute != '/') {
              Get.back();
            } else {
              Get.offAll(() => const TeacherDashboardPage());
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: appColor.white,
          ),
        ),
        centerTitle: true,
        orientation: orientation,
        height: size.height,
        color: appColor.white,
        titleSize: fSize * 0.02,
        title: "score",
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<AboutScoreState>(
              builder: (state) {
                final currentMonthStr = DateTime.now().month.toString().padLeft(2, '0');
                final currentYearStr = DateTime.now().year.toString();
                final monthOptions = historyPaymentState.monthList.isNotEmpty
                    ? historyPaymentState.monthList
                    : List.generate(12, (i) => '${i + 1}'.padLeft(2, '0'));
                final yearOptions = historyPaymentState.yearList.isNotEmpty
                    ? historyPaymentState.yearList
                    : [currentYearStr];
                final activeMonth = historyPaymentState.selectedMonth2.isNotEmpty
                    ? historyPaymentState.selectedMonth2
                    : (monthOptions.contains(currentMonthStr)
                        ? currentMonthStr
                        : monthOptions.first);
                final activeYear = historyPaymentState.selectedYear1.isNotEmpty
                    ? historyPaymentState.selectedYear1
                    : (yearOptions.contains(currentYearStr)
                        ? currentYearStr
                        : yearOptions.first);
                final activeMonthInt = int.tryParse(activeMonth) ?? DateTime.now().month;
                final activeYearInt = int.tryParse(activeYear) ?? DateTime.now().year;
                monthly = '$activeMonth/$activeYear';

                if (state.loadingTeacherSubjects) {
                  return CircleLoad(); // Loading widget
                }
                final desiredType = _scheduleTypeForTab(tabIndex);
                final subjects =
                    state.teacherSubjects.where((s) => s.scheduleType == desiredType).toList();
                return RefreshIndicator(
                  onRefresh: () async {
                    historyPaymentState.clearData();
                    historyPaymentState.setCurrentMonth();
                    await _loadSubjectsForTab(tabIndex);
                  },
                  child: ListView.builder(
                    itemCount: subjects.length + 2,
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.1,
                      top: 0,
                    ),
                    itemBuilder: (context, subjectIndex) {
                      if (subjectIndex == 0) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: fSize * 0.008,
                                vertical: fSize * 0.006,
                              ),
                            decoration: BoxDecoration(
                              color: appColor.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: appColor.grey.withOpacity(0.14),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value:
                                        yearOptions.contains(activeYear) ? activeYear : yearOptions.first,
                                    underline: const SizedBox.shrink(),
                                    items: yearOptions
                                        .map(
                                          (y) => DropdownMenuItem(
                                            value: y,
                                            child: CustomText(
                                              text: 'ປີ $y',
                                              fontSize: fSize * 0.013,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (selectedYear) async {
                                      if (selectedYear == null) return;
                                      await historyPaymentState.updateYear(selectedYear);
                                      final newYear = selectedYear;
                                      final newMonth =
                                          historyPaymentState.selectedMonth2.isNotEmpty
                                              ? historyPaymentState.selectedMonth2
                                              : currentMonthStr;
                                    setState(() {
                                      monthly = '$newMonth/$newYear';
                                    });
                                    scoreState.clearSubjectTeacherStudentsCache();
                                      await _loadSubjectsForTab(tabIndex);
                                  },
                                ),
                                ),
                                SizedBox(width: fSize * 0.01),
                                Expanded(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value:
                                        monthOptions.contains(activeMonth) ? activeMonth : monthOptions.first,
                                    underline: const SizedBox.shrink(),
                                    items: monthOptions
                                        .map(
                                          (m) => DropdownMenuItem(
                                            value: m,
                                            child: CustomText(
                                              text: 'ເດືອນ $m',
                                              fontSize: fSize * 0.013,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (selectedMonth) async {
                                      if (selectedMonth == null) return;
                                      await historyPaymentState.updateMonth(selectedMonth);
                                      final newMonth = selectedMonth;
                                      final newYear = historyPaymentState.selectedYear1.isNotEmpty
                                          ? historyPaymentState.selectedYear1
                                          : currentYearStr;
                                    setState(() {
                                      monthly = '$newMonth/$newYear';
                                    });
                                    scoreState.clearSubjectTeacherStudentsCache();
                                      await _loadSubjectsForTab(tabIndex);
                                  },
                                ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (subjectIndex == 1) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColor.grey.withOpacity(0.16),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() => tabIndex = 0);
                                            await _loadSubjectsForTab(0);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 120),
                                            padding: EdgeInsets.symmetric(
                                              vertical: fSize * 0.0075,
                                            ),
                                            decoration: BoxDecoration(
                                              color: tabIndex == 0
                                                  ? appColor.mainColor.withOpacity(0.12)
                                                  : appColor.white,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: CustomText(
                                              text: 'ຕາຕະລາງກວດກາ',
                                              fontSize: fSize * 0.0135,
                                              fontWeight:
                                                  tabIndex == 0 ? FontWeight.w700 : null,
                                              color: tabIndex == 0
                                                  ? appColor.mainColor
                                                  : appColor.black.withOpacity(0.65),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() => tabIndex = 1);
                                            await _loadSubjectsForTab(1);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 120),
                                            padding: EdgeInsets.symmetric(
                                              vertical: fSize * 0.0075,
                                            ),
                                            decoration: BoxDecoration(
                                              color: tabIndex == 1
                                                  ? appColor.mainColor.withOpacity(0.12)
                                                  : appColor.white,
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: CustomText(
                                              text: 'ຕາຕະລາງສອບເສັງ',
                                              fontSize: fSize * 0.0135,
                                              fontWeight:
                                                  tabIndex == 1 ? FontWeight.w700 : null,
                                              color: tabIndex == 1
                                                  ? appColor.mainColor
                                                  : appColor.black.withOpacity(0.65),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (subjects.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(fSize * 0.01),
                                  decoration: BoxDecoration(
                                    color: appColor.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: appColor.grey.withOpacity(0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CustomText(
                                    text: 'ບໍ່ພົບວິຊາສຳລັບຕາຕະລາງນີ້',
                                    fontSize: fSize * 0.0135,
                                    color: appColor.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      final subject = subjects[subjectIndex - 2];
                      final subjectData =
                          state.subjectTeacherStudents[subject.subjectTeacherId];
                      final subjectLoading =
                          state.loadingSubjectTeacherStudents[subject.subjectTeacherId] ?? false;
                      if (subjectData == null && !subjectLoading) {
                        scoreState.fetchSubjectTeacherStudents(
                          subjectTeacherId: subject.subjectTeacherId,
                          scheduleId: subject.scheduleId,
                          year: activeYearInt,
                          month: activeMonthInt,
                          force: true,
                        );
                      }
                      final students = subjectData?.students ?? <SubjectTeacherStudent>[];
                      final subjectTotal = students.length;
                      final subjectScored =
                          students.where((s) => (s.hasScore || s.score != null)).length;
                      final subjectPending =
                          (subjectTotal - subjectScored).clamp(0, subjectTotal);
                      final classLabel = subject.className ?? '--';
                      final subjectName = subject.subjectName ?? '---';

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                SubjectTeacherStudentsResult? data = subjectData;
                                // Fetch if not yet loaded
                                if (data == null) {
                                  await scoreState.fetchSubjectTeacherStudents(
                                    subjectTeacherId: subject.subjectTeacherId,
                                    scheduleId: subject.scheduleId,
                                    year: activeYearInt,
                                    month: activeMonthInt,
                                    force: true,
                                  );
                                  data = scoreState
                                      .subjectTeacherStudents[subject.subjectTeacherId];
                                }
                                final resolved = data;
                                if (resolved == null) return;
                                Get.to(
                                  () => DetailScorePage(
                                    subjectName: subjectName,
                                    className: classLabel,
                                    monthly: monthly,
                                    subjectTeacherStudents: resolved.students,
                                    subjectTeacherId: subject.subjectTeacherId,
                                  ),
                                  transition: Transition.fadeIn,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: fSize * 0.009,
                                  vertical: fSize * 0.0075,
                                ),
                                decoration: BoxDecoration(
                                  color: appColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColor.grey.withOpacity(0.18),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: subjectName,
                                            fontSize: fSize * 0.015,
                                            fontWeight: FontWeight.w700,
                                            color: appColor.mainColor,
                                          ),
                                          SizedBox(height: fSize * 0.0025),
                                          CustomText(
                                            text:
                                                'ຫ້ອງ: ${classLabel.isEmpty ? '--' : classLabel}',
                                            fontSize: fSize * 0.012,
                                            color: appColor.black.withOpacity(0.55),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        CustomText(
                                          text: 'ນັກຮຽນທັງໝົດ: $subjectTotal',
                                          fontSize: fSize * 0.0118,
                                          fontWeight: FontWeight.w700,
                                          color: appColor.darkBlue,
                                        ),
                                        CustomText(
                                          text: 'ໃຫ້ຄະແນນເເລ້ວ: $subjectScored',
                                          fontSize: fSize * 0.0118,
                                          fontWeight: FontWeight.w700,
                                          color: appColor.green,
                                        ),
                                        CustomText(
                                          text: 'ຍັງບໍ່ໃຫ້ເທື່ອ: $subjectPending',
                                          fontSize: fSize * 0.0118,
                                          fontWeight: FontWeight.w700,
                                          color: appColor.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (subjectLoading && students.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: CustomText(
                                  text: 'ກຳລັງໂຫລດລາຍຊື່ນັກຮຽນ...',
                                  fontSize: fSize * 0.013,
                                  color: appColor.black.withOpacity(0.6),
                                ),
                              )
                            else if (students.isEmpty)
                              SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showBottomDialog() {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<HistoryPaymentState>(builder: (getPay) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: historyPaymentState.selectedMonth2.isEmpty
                        ? null
                        : historyPaymentState.selectedMonth2,
                    hint: const CustomText(text: 'select_month'),
                    onChanged: (selectedMonth) async {
                      historyPaymentState.updateMonth(selectedMonth!);
                      if (historyPaymentState.selectedYear1 != '' &&
                          selectedMonth != '') {
                        Future.delayed(const Duration(seconds: 3));
                        await scoreState.getTotalScore(
                          classId.toString(),
                          '${selectedMonth.toString()}/${historyPaymentState.selectedYear1}',
                        );
                        setState(() {
                          monthly =
                              '${selectedMonth.toString()}/${historyPaymentState.selectedYear1}';
                        });
                      }
                    },
                    items: historyPaymentState.monthList.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: CustomText(text: month),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                  ),
                  DropdownButton<String>(
                    value: historyPaymentState.selectedYear1.isEmpty
                        ? null
                        : historyPaymentState.selectedYear1,
                    hint: const CustomText(text: 'select_year'),
                    onChanged: (selectedYear) async {
                      historyPaymentState.updateYear(selectedYear!);
                      if (selectedYear != '' &&
                          historyPaymentState.selectedMonth2 != '') {
                        Future.delayed(const Duration(seconds: 3));
                        await scoreState.getTotalScore(
                          classId.toString(),
                          '${historyPaymentState.selectedMonth2.toString()}/$selectedYear',
                        );
                        setState(() {
                          monthly =
                              '${historyPaymentState.selectedMonth2.toString()}/$selectedYear';
                        });
                      }
                    },
                    items: historyPaymentState.yearList.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}
