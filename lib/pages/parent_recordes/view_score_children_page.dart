import 'package:cached_network_image/cached_network_image.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/pages/parent_recordes/detail_score_children_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/states/date_picker_state.dart';
import 'package:pathana_school_app/states/history_payment_state.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ViewScoreChildrenPage extends StatefulWidget {
  const ViewScoreChildrenPage({super.key});

  @override
  State<ViewScoreChildrenPage> createState() => _ViewScoreChildrenPageState();
}

class _ViewScoreChildrenPageState extends State<ViewScoreChildrenPage> {
  AboutScoreState aboutScoreState = Get.put(AboutScoreState());
  DatePickerState datePickerState = Get.put(DatePickerState());
  HomeState homeState = Get.put(HomeState());
  HistoryPaymentState historyPaymentState = Get.put(HistoryPaymentState());
  final searchT = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    historyPaymentState.clearData();
    aboutScoreState.getScoreViewChildren(monthly: '');
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height * size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              homeState.setCurrentPage(0);
            },
            child: Icon(Icons.arrow_back, color: appColor.white, size: fixSize(0.02, context),)),
        title: GetBuilder<HistoryPaymentState>(builder: (getMonth) {
          return CustomText(
            text:
                "score",
            color: appColor.white,
            fontSize: fixSize(0.02, context),
          );
        }),
        backgroundColor: appColor.mainColor,
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
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchT, // Attach the controller
              onChanged: (value) => {aboutScoreState.update()},
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                labelText: 'search'.tr,
                // ignore: deprecated_member_use
                fillColor: appColor.white.withOpacity(0.98),
                filled: true,
            
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: appColor.grey),
                ),
            
                // Customize the focused border
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5, // Customize width
                    color: appColor
                        .mainColor, // Change this to your desired color
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
            SizedBox(height: size.height*0.01),
            GetBuilder<AboutScoreState>(
              builder: (getList) {
                if (getList.checkscoreChildren == false) {
                  return SizedBox(
                      height: size.height * 0.6, child: CircleLoad());
                } else if (getList.checkscoreChildren == true &&
                    getList.scoreChildrenModels.isEmpty) {
                  return SizedBox(
                     height: size.height * 0.6,
                    child: Center(
                      child: CustomText(
                        text: 'No_information_yet',
                        color: appColor.grey,
                        fontSize: fixSize(0.0165, context),
                      ),
                    ),
                  );
                }
                var value = getList.scoreChildrenModels
                  .where(
                      (e) => e.firstname!.toLowerCase().contains(searchT.text) || 
                      e.lastname!.toLowerCase().contains(searchT.text)
                      )
                  .toList();
                return Expanded(
                  // Ensure this is inside a Column with constraints
                  child: RefreshIndicator(
                    onRefresh: () async {
                      historyPaymentState.clearData();
                      await getData();
                    },
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final listData = value[index];
                        return GetBuilder<HistoryPaymentState>(
                            builder: (getMonth) {
                          return Column(
                            children: [
                              if (listData.months != null) ...[
                                for (var i = 0;
                                    i < listData.months!.length;
                                    i++)
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => DetailScoreChildrenPage(
                                          data: getList
                                              .scoreChildrenModels[index],
                                          index: i,
                                          monthly:
                                              '${historyPaymentState.selectedMonth2}/${historyPaymentState.selectedYear1}',
                                        ),
                                        transition: Transition.leftToRight,
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Card(
                                          elevation: 3,
                                          color: appColor.white,
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Container(
                                                  width: size.width * 0.2,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color:
                                                            appColor.mainColor),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Repository().urlApi}${listData.profileImage}",
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: appColor
                                                                  .mainColor),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'assets/images/logo.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.6,
                                                      child: CustomText(
                                                        text:
                                                            '${listData.firstname ?? ''} ${listData.lastname ?? ''}',
                                                        fontSize: fixSize(
                                                            0.0150, context),
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '${'class'.tr}: ${listData.className ?? ''}',
                                                      fontSize: fixSize(
                                                          0.0150, context),
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '${'average_score'.tr}: ${listData.months?[i].averageScore ?? ''}',
                                                      fontSize: fixSize(
                                                          0.0150, context),
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          '${'score_details'.tr}: ${listData.months?[i].month.toString().padLeft(2,"0")}/${listData.months![i].year}',
                                                      color: appColor.grey,
                                                      fontSize: fixSize(
                                                          0.0150, context),
                                                      maxLines: 1,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: appColor.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                fSize * 0.01),
                                          ),
                                          child: CustomText(
                                            text:
                                                '${'no'.tr} ${FormatPrice(price: num.parse(listData.months?[i].level.toString() ?? '0'))}',
                                            fontWeight: FontWeight.bold,
                                            color: appColor.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ]
                            ],
                          );
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
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
                      await aboutScoreState.getScoreViewChildren(
                          monthly:
                              '$selectedMonth/${historyPaymentState.selectedYear1}');
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
                      await aboutScoreState.getScoreViewChildren(
                          monthly:
                              '${historyPaymentState.selectedMonth2}/${historyPaymentState.selectedYear1}');
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
