import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/states/history_payment_state.dart';
import 'package:pathana_school_app/states/parent_follow_student.state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class FollowMissingSchool extends StatefulWidget {
  const FollowMissingSchool({super.key});

  @override
  State<FollowMissingSchool> createState() => _FollowMissingSchoolState();
}

class _FollowMissingSchoolState extends State<FollowMissingSchool> {
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  ParentFollowStudentState parentFollowStudent =
      Get.put(ParentFollowStudentState());
  AppColor appColor = AppColor();
  final search = TextEditingController();
  @override
  void initState() {
    parentFollowStudent.getData('', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'missing_school',
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
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
      body: GetBuilder<ParentFollowStudentState>(builder: (getData) {
        if (getData.check == false) {
          return CircleLoad();
        }
        if (getData.data.isEmpty) {
          return Expanded(
            child: Center(
              child: CustomText(
                text: 'not_found_data',
                fontSize: fSize * 0.02,
                color: appColor.grey,
              ),
            ),
          );
        }
        var searchText = search.text.toLowerCase(); // Convert search text once
        var value = getData.data
            .where((e) =>
                (e.firstname?.toLowerCase().contains(searchText) ?? false) ||
                (e.lastname?.toLowerCase().contains(searchText) ?? false))
            .toList();

        return Padding(
          padding: EdgeInsets.all(fSize * 0.005),
          child: Column(children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  color: appColor.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(8, 169, 169, 169)
                          // ignore: deprecated_member_use
                          .withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3),
                    ),
                  ]),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  hintStyle: TextStyle(color: appColor.grey),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fSize * 0.01),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onChanged: (value) {
                  parentFollowStudent.update();
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  historyPaymentState.clearData();
                  parentFollowStudent.getData('', '');
                },
                child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.all(fSize * 0.01),
                          decoration: BoxDecoration(
                            color: appColor.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: fixSize(0.0025, context),
                                offset: const Offset(0, 1),
                                color: appColor.grey,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(fSize * 0.01),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    '${value[i].firstname ?? ''} ${value[i].lastname ?? ''}',
                                fontSize: fixSize(0.0155, context),
                                color: appColor.mainColor,
                              ),
                              CustomText(
                                text:
                                    '${"score_cut_out".tr}: ${value[i].score ?? ""}',
                                fontSize: fixSize(0.0145, context),
                                // ignore: deprecated_member_use
                                color: appColor.red.withOpacity(0.8),
                              ),
                              value[i].note != null
                                  ? CustomText(
                                      text:
                                          '${"note".tr}: ${value[i].note ?? ""}',
                                      fontSize: fixSize(0.0145, context),
                                    )
                                  : const SizedBox(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                    text: "${'date'.tr}: ${value[i].dated ?? ''}",
                                    fontSize: fixSize(0.0145, context),
                                    // ignore: deprecated_member_use
                                    color: appColor.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ]),
        );
      }),
      bottomNavigationBar: GetBuilder<ParentFollowStudentState>(
        builder: (getData) {
          var searchText =
              search.text.toLowerCase(); // Convert search text once
          var value = getData.data
              .where((e) =>
                  (e.firstname?.toLowerCase().contains(searchText) ?? false) ||
                  (e.lastname?.toLowerCase().contains(searchText) ?? false))
              .toList();
          var sumTotal = value
              .map((e) => e.score)
              .whereType<
                  String>() // Ensures only valid integer scores are summed
              .fold(
                  0,
                  (prev, score) =>
                      int.parse(prev.toString()) + int.parse(score.toString()));

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appColor.white,
              border: const Border(
                top: BorderSide(width: 2, color: Colors.black45),
              ),
              // boxShadow: [BoxShadow(color: Color.fromARGB(9, 169, 169, 169))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text:
                      '${'total_score_cut_out'.tr}: ${FormatPrice(price: num.parse(sumTotal.toString()))}',
                  fontWeight: FontWeight.bold,
                  fontSize: fSize * 0.0165,
                ),
              ],
            ),
          );
        },
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
                      parentFollowStudent.getData(
                          selectedMonth, historyPaymentState.selectedYear1);
                    },
                    items: historyPaymentState.monthList.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
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
                      parentFollowStudent.getData(
                          historyPaymentState.selectedMonth2, selectedYear);
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
