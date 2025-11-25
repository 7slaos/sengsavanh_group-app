import 'dart:math';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/states/date_picker_state.dart';
import 'package:multiple_school_app/states/payment_state.dart';
import 'package:multiple_school_app/widgets/custom_app_bar.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissSchoolPage extends StatefulWidget {
  const MissSchoolPage({super.key});

  @override
  State<MissSchoolPage> createState() => _MissSchoolPageState();
}

class _MissSchoolPageState extends State<MissSchoolPage> {
  LocaleState localeState = Get.put(LocaleState());
  PaymentState paymentState = Get.put(PaymentState());
  DatePickerState datePickerState = Get.put(DatePickerState());
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
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

    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: InkWell(
          onTap: () => {Get.back()},
          child: Icon(
            Icons.arrow_back,
            color: appColor.white.withOpacity(0.85),
          ),
        ),
        orientation: orientation,
        height: size.height,
        color: appColor.white.withOpacity(0.85),
        title: "ຂາດຮຽນ",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<DatePickerState>(builder: (getDate) {
              return TextField(
                onTap: () async {
                  await datePickerState.selectDATE(context: context);
                  // Future.delayed(Duration(seconds: 3));
                  // await historyState.getData(widget.data.id.toString(),
                  //     datePickerState.month.toString());
                },
                controller: datePickerState.date,
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'ເລືອກວັນທີ',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: appColor.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: appColor.mainColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.5, color: appColor.mainColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: appColor.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: fixSize(0.0025, context),
                                    offset: const Offset(0, 1),
                                    color: appColor.grey)
                              ],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: getRandomColor(),
                                child: CustomText(
                                  text: '10',
                                  fontWeight: FontWeight.bold,
                                  color: appColor.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'ທ້າວ ແສງດີ ອິນທະວົງ',
                                    fontSize: fSize * 0.0165,
                                    color: appColor.black,
                                  ),
                                  CustomText(
                                    text: 'ຂາດໝົດມື້',
                                    fontSize: fSize * 0.0165,
                                    color: appColor.black,
                                  ),
                                  CustomText(
                                      text: '04/10/2024 08:30:54',
                                      fontSize: fSize * 0.015,
                                      color: appColor.black.withOpacity(0.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              CustomText(
                                  text: (index == 1 ||
                                          index == 3 ||
                                          index == 6 ||
                                          index == 10)
                                      ? 'ອະນຸຍາດ'
                                      : 'ບໍ່ອະນຸຍາດ',
                                  fontSize: fSize * 0.0165,
                                  color: (index == 1 ||
                                          index == 3 ||
                                          index == 6 ||
                                          index == 10)
                                      ? appColor.green.withOpacity(0.9)
                                      : appColor.red.withOpacity(0.9))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
