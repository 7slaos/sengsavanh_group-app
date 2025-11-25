import 'dart:math';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/score_list_model.dart';
import 'package:multiple_school_app/states/about_score_state.dart';
import 'package:multiple_school_app/states/date_picker_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScorePage extends StatefulWidget {
  const DetailScorePage({super.key, required this.data, required this.monthly});
  final ScoreListModels data;
  final String? monthly;
  @override
  State<DetailScorePage> createState() => _DetailScorePageState();
}

class _DetailScorePageState extends State<DetailScorePage> {
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
        title: "${'score_details'.tr} ${widget.monthly ?? ''}",
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.008),
        child: GetBuilder<AboutScoreState>(
          builder: (getdetails) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.data.items!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: widget.data.items?[index].name ?? "",
                                color: appColor.grey,
                                fontSize: fSize * 0.0185,
                              ),
                              if (widget.data.items![index].score != null &&
                                  widget.data.items![index].score.toString() !=
                                      'null')
                                CustomText(
                                  text: widget.data.items![index].score ?? '',
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
                                  num.parse(widget.data.totalScore.toString()))
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
                          widget.data.averageScore.toString(),
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
            '${'no'.tr} ${FormatPrice(price: num.parse(widget.data.level.toString())).toString()}',
      ),
    );
  }
}
