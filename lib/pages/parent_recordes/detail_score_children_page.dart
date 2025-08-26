import 'dart:math';

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/models/score_children_model.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/states/date_picker_state.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_app_bar.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScoreChildrenPage extends StatefulWidget {
  const DetailScoreChildrenPage(
      {super.key,
      required this.data,
      required this.index,
      required this.monthly});
  final int index;
  final ScoreChildrenModels data;
  final String? monthly;
  @override
  State<DetailScoreChildrenPage> createState() =>
      _DetailScoreChildrenPageState();
}

class _DetailScoreChildrenPageState extends State<DetailScoreChildrenPage> {
  LocaleState localeState = Get.put(LocaleState());
  PaymentState paymentState = Get.put(PaymentState());
  DatePickerState datePickerState = Get.put(DatePickerState());
  final Random _random = Random();

  // Generate a random color
  Color getRandomColor() {
    return Color.fromARGB(
      255, // Set alpha to full opacity
      _random.nextInt(256), // Red
      _random.nextInt(256), // Green
      _random.nextInt(256), // Blue
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: InkWell(
          onTap: () => {Get.back()},
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
        title: "${widget.data.firstname ?? ''} ${widget.data.lastname ?? ''}",
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.008),
        child: GetBuilder<AboutScoreState>(
          builder: (getdetails) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      width: 4,
                      color: appColor.mainColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text:
                          "${'score_details'.tr} ${widget.data.months?[widget.index].month ?? ''}/${widget.data.months?[widget.index].year ?? ''}",
                      fontSize: fixSize(0.02, context),
                      color: appColor.mainColor,
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.data.months![widget.index].items!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: widget.data.months![widget.index]
                                        .items?[index].name ??
                                    "",
                                color: appColor.grey,
                                fontSize: fSize * 0.0185,
                              ),
                              CustomText(
                                text: widget.data.months![widget.index]
                                            .items![index].score !=
                                        'null'
                                    ? widget.data.months![widget.index]
                                        .items![index].score
                                        .toString()
                                    : '0',
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
                      text: 'total_score',
                      fontSize: fSize * 0.0185,
                      color: appColor.grey,
                    ),
                    CustomText(
                      text: FormatPrice(
                              price: num.parse(widget
                                      .data.months?[widget.index].totalScore
                                      .toString() ??
                                  '0'.toString()))
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
                      text: 'average_score',
                      fontSize: fSize * 0.0185,
                      color: appColor.grey,
                    ),
                    CustomText(
                      text: FormatPrice(
                              price: num.parse(widget
                                      .data.months?[widget.index].averageScore
                                      .toString() ??
                                  '0'))
                          .toString(),
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
      bottomNavigationBar: ButtonWidget(
        height: fSize * 0.05,
        width: size.width,
        fontSize: fSize * 0.0185,
        fontWeight: FontWeight.bold,
        borderRadius: 0,
        // ignore: deprecated_member_use
        color: appColor.mainColor.withOpacity(0.95),
        // ignore: deprecated_member_use
        backgroundColor: Colors.blue.withOpacity(0.2),
        onPressed: () {
          Get.back();
        },
        text:
            '${'no'.tr} ${FormatPrice(price: num.parse(widget.data.months?[widget.index].level.toString() ?? '0')).toString()}',
      ),
    );
  }
}
