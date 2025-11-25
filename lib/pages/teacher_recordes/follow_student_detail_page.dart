// ignore_for_file: deprecated_member_use

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/pages/teacher_recordes/follow_student_page.dart';
import 'package:multiple_school_app/states/adminschool/admin_dashboard_state.dart';
import 'package:multiple_school_app/states/dashboard_teacher_state.dart';
import 'package:multiple_school_app/states/follow_student_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowStudentDetailPage extends StatefulWidget {
  const FollowStudentDetailPage({super.key});

  @override
  State<FollowStudentDetailPage> createState() =>
      _FollowStudentDetailPageState();
}

class _FollowStudentDetailPageState extends State<FollowStudentDetailPage> {
  final startDateController = TextEditingController();
  final search = TextEditingController();
  FollowStudentState followStudentState = Get.put(FollowStudentState());
  DashboardTeacherState dashboardTeacherState =
      Get.put(DashboardTeacherState());
  AdminDashboardState adminDashboardState =  Get.put(AdminDashboardState());

  Future<void> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set your desired range
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        startDateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  // Function to refresh the data
  Future<void> refreshData() async {
    startDateController.clear();
    followStudentState.selectedStatus; // Reset the selected status
    followStudentState.detailModels; // Fetch updated data
    // followStudentState.sumTotalScore();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    adminDashboardState.setcurrentDate();
    followStudentState.createFollowStudentDetail(
        id: dashboardTeacherState.data?.id.toString() ?? '');
  }
void showBottomDialog() {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey[200],
      builder: (context) {
        return GetBuilder<AdminDashboardState>(builder: (getSale) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'start_date',
                        fontSize: fixSize(0.0185, context),
                      ),
                      TextField(
                        controller: adminDashboardState.startDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () => adminDashboardState.selectDate(
                                context, 'start'),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (value) async {
                               followStudentState.createFollowStudentDetail(
                                id: dashboardTeacherState.data?.id.toString() ?? '',startDate: adminDashboardState.startDate.text,endDate: adminDashboardState.endDate.text);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'end_date',
                        fontSize: fixSize(0.0185, context),
                      ),
                      TextField(
                        controller: adminDashboardState.endDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () =>
                                adminDashboardState.selectDate(context, 'end'),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (value) async {
                             followStudentState.createFollowStudentDetail(
                            id: dashboardTeacherState.data?.id.toString() ?? '',startDate: adminDashboardState.startDate.text,endDate: adminDashboardState.endDate.text);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Expanded(child: Container()),
                      ButtonWidget(
                          height: size.height * 0.08,
                          borderRadius: 10,
                          backgroundColor: appColor.mainColor,
                          onPressed: () async {
                               followStudentState.createFollowStudentDetail(
                               id: dashboardTeacherState.data?.id.toString() ?? '',startDate: adminDashboardState.startDate.text,endDate: adminDashboardState.endDate.text);
                            Get.back();
                          },
                          fontSize: fixSize(0.0165, context),
                          text: 'search'),
                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: appColor.mainColor,
                  child: Icon(
                    Icons.close,
                    color: appColor.white,
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    return Scaffold(
      appBar: AppBar(
        title:  CustomText(text: 'follow_lack_off_details', fontSize: fSize*0.02),
        foregroundColor: appColor.white,
        backgroundColor: appColor.mainColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon:  Icon(Icons.calendar_month, color: appColor.white,),
            onPressed: () {
              showBottomDialog();
            },
          ),
         
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: appColor.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(8, 169, 169, 169)
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
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: GetBuilder<FollowStudentState>(
                  builder: (getList) {
                    if (getList.checkDetail == false) {
                      return CircleLoad();
                    } else if (getList.detailModels.isEmpty) {
                      return SizedBox(
                        height: fSize * 0.4,
                        child: Center(
                          child: CustomText(
                            text: 'not_found_data',
                            fontSize: fSize * 0.0185,
                            color: appColor.grey,
                          ),
                        ),
                      );
                    }

                    var details = getList.detailModels
                        .where((e) => (e.firstname
                                .toString()
                                .contains(search.text.toString()) ||
                            e.lastname
                                .toString()
                                .contains(search.text.toString())))
                        .toList();

                    return ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        final detail = details[index];
                        String typeDescription;
                        switch (detail.type) {
                          case 1:
                            typeDescription = 'missing_the_morning'.tr;
                            break;
                          case 2:
                            typeDescription = 'missing_evening'.tr;
                            break;
                          default:
                            typeDescription = 'missing_all_day'.tr;
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: appColor.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(9, 169, 169, 169),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Card(
                            color: appColor.white,
                            elevation: 4,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors
                                    .primaries[index % Colors.primaries.length],
                                child: CustomText(
                                  text: '${index + 1}',
                                  color: appColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: CustomText(
                                text: '${"dated".tr}: ${detail.dated ?? ''}',
                                fontWeight: FontWeight.w600,
                                fontSize: fixSize(0.0145, context),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        '${'student_name'.tr}: ${detail.firstname ?? ''} ${detail.lastname ?? ''}',
                                    fontWeight: FontWeight.w600,
                                    // textOverflow: TextOverflow.ellipsis,
                                    // maxLines: 1,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: '${'score_cut_out'.tr}:',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(width: size.width * 0.01),
                                      CustomText(
                                        text: '- ${detail.score ?? '0'}',
                                        color: appColor.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  CustomText(
                                    text: '${"type".tr}: $typeDescription',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    text:
                                        '${'creator'.tr}: ${detail.createFullname ?? ''} ${detail.createLastname ?? ''}',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    text: '${'note'.tr}: ${detail.note ?? ''}',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.to(
                                            () =>
                                                FollowStudentPage(data: detail),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const CustomText(
                                        text: 'edit',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          followStudentState.removeListId(
                                              context: context,
                                              id: int.parse(
                                                  detail.id.toString()));
                                          // showDeleteDialog(context, detail.id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const CustomText(
                                        text: 'delete',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<FollowStudentState>(
        builder: (getTotal) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: appColor.white,
                  border: const Border(
                    top: BorderSide(width: 2, color: Colors.black45),
                  ),
                  // boxShadow: [BoxShadow(color: Color.fromARGB(9, 169, 169, 169))],
                ),
                child: CustomText(
                  text:
                      '${'total_score_cut_out'.tr}: ${FormatPrice(price: num.parse(getTotal.totalScore.toString()))}',
                  fontWeight: FontWeight.bold,
                  fontSize: fSize * 0.0165,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
