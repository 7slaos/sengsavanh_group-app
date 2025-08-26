// ignore_for_file: deprecated_member_use

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    super.key,
    required this.type,
    this.title,
    this.afterSelect,
  });
  final SelectDateType type;
  final AppColor appColors = AppColor();
  final CustomDatePickerState customDatePickerState =
      Get.put(CustomDatePickerState());
  final String? title;
  final Function()? afterSelect;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixSize = size.width + size.height;
    return InkWell(
      onTap: () async {
        if (type == SelectDateType.startDate) {
          await customDatePickerState.pickStartDate(context);
          try {
            afterSelect!();
          } catch (e) {
            return;
          }
          return;
        } else if (type == SelectDateType.endDate) {
          await customDatePickerState.pickEndDate(context);
          try {
            afterSelect!();
          } catch (e) {
            return;
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: fixSize * 0.005,
            ),
            child: CustomText(
              text: title ?? "",
              color: appColors.white,
              fontSize: fixSize * 0.012,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: appColors.white,
                size: fixSize * 0.045,
              ),
              GetBuilder<CustomDatePickerState>(builder: (date) {
                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "day",
                          color: appColors.white.withOpacity(
                            0.75,
                          ),
                          fontSize: fixSize * 0.008,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: fixSize * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border(
                              left: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                              top: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: type == SelectDateType.startDate
                              ? CustomText(
                                  text: date.startDate != null
                                      ? date.startDate!.day
                                          .toString()
                                          .padLeft(2, "0")
                                      : "- -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                )
                              : CustomText(
                                  text: date.endDate != null
                                      ? date.endDate!.day
                                          .toString()
                                          .padLeft(2, "0")
                                      : "- -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "month",
                          color: appColors.white.withOpacity(
                            0.75,
                          ),
                          fontSize: fixSize * 0.008,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: fixSize * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border(
                              left: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                              top: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: appColors.mainColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: type == SelectDateType.startDate
                              ? CustomText(
                                  text: date.startDate != null
                                      ? date.startDate!.month
                                          .toString()
                                          .padLeft(2, "0")
                                      : "- -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                )
                              : CustomText(
                                  text: date.endDate != null
                                      ? date.endDate!.month
                                          .toString()
                                          .padLeft(2, "0")
                                      : "- -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "year",
                          color: appColors.white.withOpacity(
                            0.75,
                          ),
                          fontSize: fixSize * 0.008,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: fixSize * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            border: Border.all(
                              color: appColors.mainColor,
                              width: 1,
                            ),
                          ),
                          child: type == SelectDateType.startDate
                              ? CustomText(
                                  text: date.startDate != null
                                      ? date.startDate!.year.toString()
                                      : "- - - -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                )
                              : CustomText(
                                  text: date.endDate != null
                                      ? date.endDate!.year.toString()
                                      : "- - - -",
                                  color: appColors.black,
                                  fontSize: fixSize * 0.012,
                                ),
                        )
                      ],
                    ),
                  ],
                );
              })
            ],
          ),
          // Container(
          //   margin: EdgeInsets.only(
          //     left: fixSize * 0.005,
          //   ),
          //   width: size.width * 0.135,
          //   decoration: BoxDecoration(
          //       color: appColors.mainColor,
          //       borderRadius: BorderRadius.circular(
          //         fixSize * 0.005,
          //       )),
          //   child: Center(
          //     child: CustomText(
          //       text: "pick",
          //       color: appColors.white,
          //       fontSize: fixSize * 0.012,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

enum SelectDateType {
  startDate,
  endDate,
}

class CustomDatePickerState extends GetxController {
  DateTime? startDate;
  DateTime? endDate;
  final AppColor appColors = AppColor();
  pickStartDate(BuildContext context) async {
    startDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.parse("2014-05-01 00:00:00"),
      lastDate: DateTime.parse("2030-05-01 23:59:59"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.mainColor,
            ),
          ),
          child: child!,
        );
      },
    );

    endDate = null;
    update();
  }

  pickEndDate(BuildContext context) async {
    endDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime.parse("2014-05-01 00:00:00"),
      lastDate: DateTime.parse("2030-05-01 23:59:59"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.mainColor,
            ),
          ),
          child: child!,
        );
      },
    );

    update();
  }

  setStartDateEndDate() {
    startDate = DateTime.now();
    endDate = DateTime.now();
    update();
  }

  String converToDateTimeApi(DateTime date) {
    String datetime =
        "${date.year.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}";
    return datetime;
  }

  String converToDateTimeLaos(DateTime date) {
    String datetime =
        "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year.toString().padLeft(2, "0")} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}";
    return datetime;
  }

  String converToDateLaos(DateTime date) {
    String datetime =
        "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year.toString().padLeft(2, "0")}";
    return datetime;
  }
String converToDateTimeApiWithCustom(
      {required DateTime date}) {
    String datetime =
        "${date.year.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
    return datetime;
  }
  String converToDateTimeApiWithCustomTime(
      {required DateTime date, required String time}) {
    String datetime =
        "${date.year.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")} $time";
    return datetime;
  }

  initData() {
    startDate = null;
    endDate = null;
  }

  @override
  void onReady() {
    // initData();
    super.onReady();
  }
}
