import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/states/adminschool/admin_students_state.dart';
import 'package:pathana_school_app/states/camera_scan_state.dart';
import 'package:pathana_school_app/states/superadmin/super_admin_state.dart';

import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/shimmer_listview.dart';

import '../../widgets/button_widget.dart';

class AdminStudents extends StatefulWidget {
  const AdminStudents({super.key, required this.branchId, this.checkInOut=false});
  final String branchId;
  final bool checkInOut;
  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  AdminStudentsState adminStudentsState = Get.put(AdminStudentsState());
  final searchT = TextEditingController();
  AppColor appColor = AppColor();
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Future.delayed(Duration(seconds: 5));
    adminStudentsState.getData('', '', branchId: widget.branchId);
  }

  SuperAdminState superAdminState = Get.put(SuperAdminState());
  CameraScanPageState cameraScanPageState = Get.put(CameraScanPageState());
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
        return GetBuilder<AdminStudentsState>(builder: (getSale) {
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
                        controller: superAdminState.startDate,
                        readOnly: true,
                        onChanged: (value) {
                          Future.delayed(Duration(seconds: 3));
                          adminStudentsState.getData(
                              superAdminState.startDate.text,
                              superAdminState.endDate.text,
                              branchId: widget.branchId);
                        },
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                superAdminState.selectDate(context, 'start');
                              }),
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
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'end_date',
                        fontSize: fixSize(0.0185, context),
                      ),
                      TextField(
                        controller: superAdminState.endDate,
                        readOnly: true,
                        onChanged: (value) {
                          Future.delayed(Duration(seconds: 3));
                          adminStudentsState.getData(
                              superAdminState.startDate.text,
                              superAdminState.endDate.text,
                              branchId: widget.branchId);
                        },
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                superAdminState.selectDate(context, 'end');
                              }),
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
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Expanded(child: Container()),
                      ButtonWidget(
                          height: size.height * 0.08,
                          borderRadius: 10,
                          backgroundColor: appColor.mainColor,
                          onPressed: () async {
                            if (superAdminState.startDate.text != '' &&
                                superAdminState.endDate.text != '') {
                              adminStudentsState.getData(
                                  superAdminState.startDate.text,
                                  superAdminState.endDate.text,
                                  branchId: widget.branchId);
                            }
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'student', color: appColor.mainColor, fontSize: fixSize(0.016, context)),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: appColor.mainColor,
            )),
        centerTitle: true,
        elevation: 4,
        surfaceTintColor: appColor.white,
        actions: [
          IconButton(
              onPressed: () {
                showBottomDialog();
              },
              icon: Icon(
                Icons.calendar_month,
                color: appColor.mainColor,
              ))
        ],
      ),
      body: GetBuilder<AdminStudentsState>(builder: (getD) {
        if (getD.data.isEmpty && getD.loading == true) {
          return ShimmerListview();
        }
        if (getD.data.isEmpty && getD.loading == false) {
          return Column(
            children: [
              Expanded(
                child: Center(
                    child: CustomText(
                  text: 'not_found_data',
                  color: appColor.grey,
                  fontSize: fixSize(0.0185, context),
                )),
              ),
            ],
          );
        }
        var value = getD.data
            .where((e) =>
                (e.firstname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.lastname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.phone ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.myClass ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()))
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchT, // Attach the controller
                onChanged: (value) {
                  adminStudentsState.update();
                },
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
            ),
            Expanded(
              child: RefreshIndicator(
                color: appColor.mainColor,
                onRefresh: () async {
                  superAdminState.clearData();
                  getData();
                },
                child: ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                         if(widget.checkInOut == true){
                           Get.back();
                           cameraScanPageState.scanOut(context: context, code: value[index].admissionNumber);
                         }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                            decoration: BoxDecoration(color: appColor.white),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text:
                                          '${value[index].firstname ?? ""} ${value[index].lastname ?? ""}'),
                                  CustomText(
                                    text: '${"phone".tr}: ${value[index].phone}',
                                    color: appColor.grey,
                                  ),
                                  CustomText(
                                    text:
                                        '${"class".tr}: ${value[index].myClass}',
                                    color: appColor.grey,
                                  ),
                                ],
                              ),
                              trailing: CustomText(
                                text: value[index].date ?? '',
                                color: appColor.grey,
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: GetBuilder<AdminStudentsState>(builder: (getData) {
        if (getData.data.isEmpty) {
          return const SizedBox();
        }
        var value = getData.data
            .where((e) =>
                (e.firstname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.lastname ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.phone ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.myClass ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()))
            .toList();
        var woman = value.where((e) => e.gender == '1').toList().length;
        var man = value.where((e) => e.gender == '2').toList().length;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: appColor.white, boxShadow: [
                BoxShadow(
                    blurRadius: fixSize(0.0025, context),
                    offset: const Offset(0, 1),
                    color: appColor.grey)
              ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"all".tr}:',
                          fontSize: fixSize(0.016, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(value.length.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.016, context),
                          color: appColor.mainColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"female".tr}:',
                          fontSize: fixSize(0.016, context),
                          color: appColor.red),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(woman.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.016, context),
                          color: appColor.red),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"male".tr}:',
                          fontSize: fixSize(0.016, context),
                          color: appColor.green),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(man.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.016, context),
                          color: appColor.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
