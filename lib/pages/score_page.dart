// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/pages/select_myclasse_page.dart';
import 'package:multiple_school_app/pages/detail_score_page.dart';
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
  final searchT = TextEditingController();

  int indexCategory = 0;
  int classId = 0;
  String monthly = '${DateTime.now().month}/${DateTime.now().year}';

  @override
  void initState() {
    super.initState();
    datePickerState.setCurrentMonth();
    getData('0', '0');
  }

  Future<void> getData(String? id, String monthly) async {
    await Future.delayed(Duration.zero);
    await scoreState.getAllScore(id, monthly);
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
          onTap: Get.back,
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
        actions: [
          IconButton(
              onPressed: () {
                showBottomDialog();
              },
              icon: Icon(
                Icons.calendar_month,
                color: appColor.white,
              ))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchT, // Attach the controller
              onChanged: (value) => {scoreState.update()},
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                labelText: 'search'.tr,
                hintStyle: TextStyle(fontSize: fSize * 0.015),
                labelStyle: TextStyle(fontSize: fSize * 0.015),
                fillColor: appColor.white.withOpacity(0.98),
                filled: true,

                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: appColor.grey),
                ),

                // Customize the focused border
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5, // Customize width
                    color:
                        appColor.mainColor, // Change this to your desired color
                  ),
                ),
                // Optionally, you can also change the enabled border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: appColor.grey,
                  ),
                ),
              ),
            ),
          ),
          // Score List
          Expanded(
            child: GetBuilder<AboutScoreState>(
              builder: (getList_) {
                if (!getList_.checkClasse || !getList_.checkScoreList) {
                  return CircleLoad(); // Loading widget
                } else if (getList_.scoreListModel.isEmpty) {
                  return SizedBox(
                    height: fSize * 0.4,
                    child: Center(
                      child: CustomText(
                        text: 'No_information_yet',
                        fontSize: fSize * 0.0185,
                      ),
                    ),
                  );
                }
                var value = getList_.scoreListModel
                    .where((e) =>
                        (e.firstname ?? '')
                            .toLowerCase()
                            .contains(searchT.text.toLowerCase()) ||
                        (e.lastname ?? '')
                            .toLowerCase()
                            .contains(searchT.text.toLowerCase()))
                    .toList();
                return Column(
                  children: [
                    // Classe List
                    Container(
                      height: size.height * 0.04,
                      color: appColor.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: getList_.classeList.length,
                        itemBuilder: (context, index) {
                          final classe = getList_.classeList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                indexCategory = index;
                                classId = getList_.classeList[index].id!;
                              });
                              getData(
                                  getList_.classeList[index].id.toString(), '');
                              // clear data class
                              getList_.classeList.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: fSize * 0.016),
                              alignment: Alignment.center,
                              child: CustomText(
                                text: classe.name ?? '',
                                fontSize: fixSize(0.015, context),
                                color: indexCategory == index
                                    ? appColor.mainColor
                                    : appColor.black,
                                fontWeight: indexCategory == index
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: fSize * 0.01),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          historyPaymentState.clearData();
                          setState(() {
                            monthly =
                                '${DateTime.now().month}/${DateTime.now().year}';
                          });
                          await getData(classId.toString(), monthly);
                        },
                        child: getList_.scoreListModel.isEmpty
                            ? Center(
                                child: CustomText(
                                  text: 'No_information_yet', // Add data
                                  fontSize: fixSize(0.0160, context),
                                  color: appColor.grey,
                                ),
                              )
                            : ListView.builder(
                                itemCount: value.length,
                                padding:
                                    EdgeInsets.only(bottom: size.height * 0.1),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => DetailScorePage(
                                          data: value[index],
                                          monthly: monthly,
                                        ),
                                        transition: Transition.fadeIn,
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: fSize * 0.008,
                                        vertical: fSize * 0.008,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.all(fSize * 0.008),
                                            decoration: BoxDecoration(
                                              color: appColor.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius:
                                                      fixSize(0.0025, context),
                                                  offset: const Offset(0, 1),
                                                  color: appColor.grey,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      fSize * 0.005),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      getRandomColor(),
                                                  child: CustomText(
                                                    text: '${index + 1}',
                                                    fontWeight: FontWeight.bold,
                                                    color: appColor.white,
                                                  ),
                                                ),
                                                SizedBox(width: fSize * 0.01),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width *
                                                          0.5, // Restrict width
                                                      child: CustomText(
                                                        text:
                                                            '${value[index].firstname ?? ''} ${value[index].lastname ?? ''}',
                                                        fontSize: fSize * 0.015,
                                                        color: appColor.black,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '${'average_score'.tr}: ${value[index].averageScore.toString().replaceAll('.', ',')}',
                                                      fontSize: fSize * 0.015,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '${'monthly'.tr}: $monthly',
                                                      fontSize: fSize * 0.015,
                                                      color: appColor.black
                                                          .withOpacity(0.5),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ButtonWidget(
                                            height: size.width * 0.125,
                                            width: size.width * 0.25,
                                            color: appColor.mainColor
                                                .withOpacity(0.95),
                                            backgroundColor:
                                                Colors.blue.withOpacity(0.2),
                                            fontSize: fixSize(0.0145, context),
                                            borderRadius: 10,
                                            onPressed: () {},
                                            text:
                                                '${'no'.tr} ${FormatPrice(price: num.parse(value[index].level.toString()))}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor.mainColor,
        onPressed: () {
          Get.to(
            () => const SelectMyclassePage(),
            transition: Transition.leftToRight,
          );
        },
        child: Icon(
          Icons.add,
          color: appColor.white,
        ),
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
