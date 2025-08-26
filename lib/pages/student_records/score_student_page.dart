import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/pages/student_records/detail_score_student_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/states/date_picker_state.dart';
import 'package:pathana_school_app/states/history_payment_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreStudentPage extends StatefulWidget {
  const ScoreStudentPage({super.key});

  @override
  State<ScoreStudentPage> createState() => _ScoreStudentPageState();
}

class _ScoreStudentPageState extends State<ScoreStudentPage> {
  DatePickerState datePickerState = Get.put(DatePickerState());
  AboutScoreState aboutScoreState = Get.put(AboutScoreState());
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration(seconds: 5));
    datePickerState.setCurrentMonth();
    aboutScoreState.getScoreStudent();
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
                        aboutScoreState.getScoreStudent(
                            monthly:
                                '${selectedMonth.toString()}/${historyPaymentState.selectedYear1}');
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
                        aboutScoreState.getScoreStudent(
                            monthly:
                                '${historyPaymentState.selectedMonth2.toString()}/$selectedYear');
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'score',
          fontSize: fixSize(0.0235, context),
        ),
        foregroundColor: Colors.white,
        backgroundColor: appColor.mainColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              historyPaymentState.clearData();
              getData();
            },
            icon: Icon(Icons.autorenew),
            color: appColor.white,
          ),
          IconButton(
            onPressed: () {
              showBottomDialog();
            },
            icon: Icon(
              Icons.calendar_month,
              color: appColor.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.01),
        child: Column(
          children: [
            GetBuilder<AboutScoreState>(
              builder: (getList) {
                if (getList.checkMyOwnScore == false) {
                  // Show a loading indicator
                  return CircleLoad();
                } else if (getList.scoreStudentModels.isEmpty) {
                  // Show a message when the list is empty
                  return Expanded(
                    child: Center(
                      child: CustomText(
                        text: 'not_found_data', // Add Data
                        color: appColor.grey,
                        fontSize: fixSize(0.0155, context),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: getList.scoreStudentModels.length,
                    itemBuilder: (context, index) {
                      final student = getList.scoreStudentModels[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                              () => DetailScoreStudentPage(
                                    data: getList.scoreStudentModels[index],
                                    monthly: getList
                                            .scoreStudentModels[index].month ??
                                        '',
                                  ),
                              transition: Transition.fadeIn);
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: student.profileImage != null
                                  ? NetworkImage(
                                      "${Repository().urlApi.trim()}${student.profileImage}")
                                  : const AssetImage(
                                          'assets/images/istockphoto-587805078-612x612.jpg')
                                      as ImageProvider,
                            ),
                            title: CustomText(
                              text:
                                  '${student.firstname ?? ''} ${student.lastname ?? ''}',
                              fontSize: fixSize(0.0155, context),
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      '${'average_score'.tr}: ${student.averageScore.toString().replaceAll('.', ',')}',
                                  fontSize: fSize * 0.015,
                                ),
                                CustomText(
                                  text:
                                      '${'monthly'.tr}: ${getList.scoreStudentModels[index].month ?? ''}', // Replace with dynamic date if needed
                                  fontSize: fSize * 0.0145,
                                  color: appColor.grey,
                                ),
                              ],
                            ),
                            trailing: Container(
                              height: size.height * 0.05,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                color: appColor.mainColor,
                                borderRadius:
                                    BorderRadius.circular(fSize * 0.01),
                              ),
                              child: Center(
                                child: CustomText(
                                  text:
                                      '${'no'.tr} ${FormatPrice(price: num.parse(getList.scoreStudentModels[index].level.toString()))}', // Replace with dynamic text if needed
                                  color: appColor.white,
                                  fontSize: fixSize(0.0120, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
