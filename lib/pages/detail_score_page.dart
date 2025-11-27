import 'dart:math';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/score_list_model.dart';
import 'package:multiple_school_app/models/subject_teacher_student_model.dart';
import 'package:multiple_school_app/states/about_score_state.dart';
import 'package:multiple_school_app/states/date_picker_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/pages/score_page.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScorePage extends StatefulWidget {
  const DetailScorePage({
    super.key,
    this.data,
    required this.monthly,
    this.subjectName,
    this.students,
    this.subjectTeacherStudents,
    this.className,
    this.subjectTeacherId,
  });

  final ScoreListModels? data;
  final String? monthly;
  final String? subjectName;
  final List<ScoreListModels>? students;
  final List<SubjectTeacherStudent>? subjectTeacherStudents;
  final String? className;
  final int? subjectTeacherId;
  @override
  State<DetailScorePage> createState() => _DetailScorePageState();
}

class _DetailScorePageState extends State<DetailScorePage> {
  LocaleState localeState = Get.put(LocaleState());
  PaymentState paymentState = Get.put(PaymentState());
  DatePickerState datePickerState = Get.put(DatePickerState());
  final AboutScoreState _scoreState = Get.put(AboutScoreState());
  final Random _random = Random();
  final Map<int, TextEditingController> _scoreControllers = {};
  bool get _hasTeacherSubjectStudents =>
      (widget.subjectTeacherStudents != null && widget.subjectName != null);
  List<SubjectTeacherStudent> get _teacherStudents =>
      widget.subjectTeacherStudents ?? <SubjectTeacherStudent>[];
  String _searchQuery = '';

  // Generate a random color
  Color getRandomColor() {
    return Color.fromARGB(
      255, // Set alpha to full opacity
      _random.nextInt(256), // Red
      _random.nextInt(256), // Green
      _random.nextInt(256), // Blue
    );
  }

  String _prefixForGender(int? gender) {
    if (gender == 1) return 'ນາງ ';
    if (gender == 2) return 'ທ້າວ ';
    return '';
  }

  Future<void> _handleSaveTeacherScores() async {
    if (!_hasTeacherSubjectStudents || widget.subjectTeacherId == null) {
      return;
    }
    final subjectData = _scoreState.subjectTeacherStudents[widget.subjectTeacherId!];
    if (subjectData == null) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'something_went_wrong'.tr,
      );
      return;
    }
    final scores = <int, String>{};
    for (final student in _teacherStudents) {
      final controller = _scoreControllers[student.studentRecordId];
      if (controller == null) continue;
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        scores[student.studentRecordId] = text;
      }
    }
    if (scores.isEmpty) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'ກະລຸນາໃສ່ຄະແນນກ່ອນ',
      );
      return;
    }
    // Use selected month/year if provided, fallback to today.
    String? datedOverride;
    if ((widget.monthly ?? '').contains('/')) {
      final parts = widget.monthly!.split('/');
      if (parts.length == 2) {
        final m = parts[0].padLeft(2, '0');
        final y = parts[1];
        datedOverride = '$y-$m-01';
      }
    }
    final success = await _scoreState.saveTeacherScores(
      subjectData: subjectData,
      scores: scores,
      datedOverride: datedOverride,
    );
    if (success && mounted) {
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAll(() => const ScorePage());
    }
  }

  @override
  void dispose() {
    for (final c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    final hasTeacherSubjectStudents = _hasTeacherSubjectStudents;
    final teacherStudents = _teacherStudents
        .where((s) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          final name = '${s.firstname ?? ''} ${s.lastname ?? ''}'.toLowerCase();
          final nick = (s.nickname ?? '').toLowerCase();
          return name.contains(q) || nick.contains(q);
        })
        .toList();
    final isLegacySubjectMode =
        !hasTeacherSubjectStudents && (widget.students != null && widget.subjectName != null);
    final subjectStudents =
        isLegacySubjectMode ? (widget.students ?? []).take(5).toList() : <ScoreListModels>[];
    final sampleStudents = <ScoreListModels>[
      ScoreListModels(id: -1, firstname: 'ທ້າວ', lastname: 'ກັນຍາ ພົມມະຈັກຍາ'),
      ScoreListModels(id: -2, firstname: 'ນາງ', lastname: 'ສະຫວັນນະໄຊ'),
      ScoreListModels(id: -3, firstname: 'ທ້າວ', lastname: 'ສີສະຫວັນ'),
      ScoreListModels(id: -4, firstname: 'ນາງ', lastname: 'ດາວຄຳ'),
      ScoreListModels(id: -5, firstname: 'ທ້າວ', lastname: 'ທອງພູ'),
    ];
    final displayStudents =
        subjectStudents.isNotEmpty ? subjectStudents : sampleStudents;

    if (hasTeacherSubjectStudents) {
      for (final student in teacherStudents) {
        final id = student.studentRecordId;
        if (!_scoreControllers.containsKey(id)) {
          _scoreControllers[id] =
              TextEditingController(text: student.score?.toString() ?? '');
        }
      }
    } else if (isLegacySubjectMode) {
      for (var student in displayStudents) {
        final id = student.id ?? displayStudents.indexOf(student);
        if (!_scoreControllers.containsKey(id)) {
          String? existingScore;
          final subjectItem = (student.items ?? []).firstWhere(
            (it) =>
                (it.name ?? '').toLowerCase() ==
                (widget.subjectName ?? '').toLowerCase(),
            orElse: () => Items(),
          );
          existingScore = subjectItem.score;
          _scoreControllers[id] =
              TextEditingController(text: existingScore ?? '');
        }
      }
    }
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: InkWell(
          onTap: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAll(() => const ScorePage());
            }
          },
          child: Icon(
            Icons.arrow_back,
            // ignore: deprecated_member_use
            color: appColor.white.withOpacity(0.85),
          ),
        ),
        centerTitle: true,
        orientation: orientation,
        height: size.height,
        // ignore: deprecated_member_use
        color: appColor.white.withOpacity(0.85),
        title: (widget.monthly != null && widget.monthly!.contains('/'))
            ? 'ສຳຫຼັບເດືອນ: ${widget.monthly!.split('/')[0]} ປີ: ${widget.monthly!.split('/')[1]}'
            : ((hasTeacherSubjectStudents || isLegacySubjectMode)
                ? (widget.subjectName ?? '')
                : "${'score_details'.tr} ${widget.monthly ?? ''}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.008),
        child: hasTeacherSubjectStudents
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'ວິຊາ: ${widget.subjectName ?? ''}',
                    fontSize: fSize * 0.015,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: fSize * 0.004),
                  CustomText(
                    text: 'ຫ້ອງ: ${widget.className ?? widget.monthly ?? ''}',
                    fontSize: fSize * 0.0145,
                    color: appColor.black.withOpacity(0.65),
                  ),
                  SizedBox(height: fSize * 0.005),
                  TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'ຄົ້ນຫານັກຮຽນ...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: appColor.grey, width: 0.5),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: fSize * 0.008,
                        vertical: fSize * 0.010,
                      ),
                    ),
                  ),
                  SizedBox(height: fSize * 0.008),
                  Expanded(
                    child: teacherStudents.isEmpty
                        ? Center(
                            child: CustomText(
                              text: 'ບໍ່ພົບຂໍ້ມູນນັກຮຽນ',
                              fontSize: fSize * 0.014,
                            ),
                          )
                        : ListView.builder(
                            itemCount: teacherStudents.length,
                            itemBuilder: (context, index) {
                              final student = teacherStudents[index];
                              final controller =
                                  _scoreControllers[student.studentRecordId] ??=
                                      TextEditingController(
                                          text: student.score?.toString() ?? '');
                              return Container(
                                margin: EdgeInsets.only(bottom: fSize * 0.006),
                                padding: EdgeInsets.all(fSize * 0.008),
                                decoration: BoxDecoration(
                                  color: appColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColor.grey.withOpacity(0.18),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: fSize * 0.014,
                                      backgroundColor: getRandomColor(),
                                      child: CustomText(
                                        text: '${index + 1}',
                                        color: appColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: fSize * 0.012),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text:
                                                '${_prefixForGender(student.gender)}${student.firstname ?? ''} ${student.lastname ?? ''}',
                                            fontSize: fSize * 0.015,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          if ((student.nickname ?? '').isNotEmpty)
                                            CustomText(
                                              text: student.nickname ?? '',
                                              fontSize: fSize * 0.012,
                                              color: appColor.black.withOpacity(0.6),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: fSize * 0.012),
                                    SizedBox(
                                      width: size.width * 0.25,
                                      child: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: 'ຄະແນນ',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: appColor.grey,
                                              width: 0.5,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: fSize * 0.008,
                                            vertical: fSize * 0.009,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
        },
      ),
                  ),
                ],
              )
            : isLegacySubjectMode
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'ຫ້ອງ: ${widget.monthly ?? ''}',
                        fontSize: fSize * 0.0145,
                        color: appColor.black.withOpacity(0.65),
                      ),
                      SizedBox(height: fSize * 0.005),
                      Expanded(
                        child: ListView.builder(
                          itemCount: displayStudents.length,
                          itemBuilder: (context, index) {
                            final student = displayStudents[index];
                            final id = student.id ?? index;
                            return Container(
                              margin: EdgeInsets.only(bottom: fSize * 0.006),
                              padding: EdgeInsets.all(fSize * 0.008),
                              decoration: BoxDecoration(
                                color: appColor.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColor.grey.withOpacity(0.18),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: fSize * 0.014,
                                    backgroundColor: getRandomColor(),
                                    child: CustomText(
                                      text: '${index + 1}',
                                      color: appColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: fSize * 0.012),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              '${student.firstname ?? ''} ${student.lastname ?? ''}',
                                          fontSize: fSize * 0.015,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomText(
                                          text: 'nickname: -',
                                          fontSize: fSize * 0.012,
                                          color: appColor.black.withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: fSize * 0.012),
                                  SizedBox(
                                    width: size.width * 0.25,
                                    child: TextField(
                                      controller: _scoreControllers[id],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        labelText: 'ຄະແນນ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: appColor.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: fSize * 0.008,
                                          vertical: fSize * 0.009,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : GetBuilder<AboutScoreState>(
                    builder: (getdetails) {
                      final data = widget.data;
                      if (data == null) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.items!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: data.items?[index].name ?? "",
                                          color: appColor.grey,
                                          fontSize: fSize * 0.0185,
                                        ),
                                        if (data.items![index].score != null &&
                                            data.items![index].score.toString() !=
                                                'null')
                                          CustomText(
                                            text: data.items![index].score ?? '',
                                            // color: getRandomColor(),
                                            fontSize: fSize * 0.0200,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      ],
                                    ),
                                    Divider(
                                      color: appColor.grey,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: '${"total_score".tr}:',
                                fontSize: fSize * 0.0185,
                                color: appColor.grey,
                              ),
                              CustomText(
                                text: FormatPrice(
                                        price:
                                            num.parse(data.totalScore.toString()))
                                    .toString(),
                                fontWeight: FontWeight.bold,
                                fontSize: fSize * 0.0235,
                                // color: getRandomColor(),
                              ),
                            ],
                          ),
                          Divider(
                            color: appColor.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: '${"average_score".tr}:',
                                fontSize: fSize * 0.0185,
                                color: appColor.grey,
                              ),
                              CustomText(
                                text: FormatPrice(
                                  price: num.parse(
                                    data.averageScore.toString(),
                                  ),
                                ).toString(),
                                fontWeight: FontWeight.bold,
                                fontSize: fSize * 0.0235,
                                // color: getRandomColor(),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
      ),
      bottomNavigationBar: GetBuilder<AboutScoreState>(
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
              left: fSize * 0.008,
              right: fSize * 0.008,
              bottom: fSize * 0.008,
            ),
            child: ButtonWidget(
              height: fSize * 0.05,
              width: size.width,
              fontSize: fSize * 0.0185,
              fontWeight: FontWeight.bold,
              borderRadius: 12,
              // ignore: deprecated_member_use
              color: appColor.mainColor.withOpacity(0.95),
              // ignore: deprecated_member_use
              backgroundColor: Colors.blue.withOpacity(0.2),
              onPressed: () async {
                if (_scoreState.savingTeacherScores) return;
                if (hasTeacherSubjectStudents) {
                  await _handleSaveTeacherScores();
                } else {
                  Get.back();
                }
              },
              text: (hasTeacherSubjectStudents || isLegacySubjectMode)
                  ? (_scoreState.savingTeacherScores
                      ? 'ກຳລັງບັນທຶກ...'
                      : 'ຍຶນຍັນຄະແນນ')
                  : '${'no'.tr} ${FormatPrice(price: num.parse(widget.data?.level.toString() ?? '0')).toString()}',
            ),
          );
        },
      ),
    );
  }
}
