import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/confirm_register_model.dart';
import 'package:multiple_school_app/states/adminschool/admin_students_state.dart';
import 'package:multiple_school_app/states/superadmin/super_admin_state.dart';

import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/widgets/shimmer_listview.dart';

import '../../widgets/button_widget.dart';

class ConfirmRegister extends StatefulWidget {
  const ConfirmRegister({super.key});
  @override
  State<ConfirmRegister> createState() => _ConfirmRegisterState();
}

class _ConfirmRegisterState extends State<ConfirmRegister> {
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
    adminStudentsState.getregisterData('', '');
  }

  SuperAdminState superAdminState = Get.put(SuperAdminState());
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
                          adminStudentsState.getregisterData(
                              superAdminState.startDate.text,
                              superAdminState.endDate.text);
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
                          adminStudentsState.getregisterData(
                              superAdminState.startDate.text,
                              superAdminState.endDate.text);
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
                              adminStudentsState.getregisterData(
                                  superAdminState.startDate.text,
                                  superAdminState.endDate.text);
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

  void showBottomDialogConfirm(ConfirmRegisterModel data) {
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
                height: size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomText(
                          text: 'register',
                          fontSize: fixSize(0.02, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomText(
                        text: 'student',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.bold,
                      ),
                      const Divider(),
                      CustomText(
                        text: 'firstname',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.firstname ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      CustomText(
                        text: 'lastname',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.lastname ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      CustomText(
                        text: 'phone',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.phone ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      CustomText(
                        text: 'class',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.myClassId?.name ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      CustomText(
                        text: 'parent',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.bold,
                      ),
                      const Divider(),
                      CustomText(
                        text: 'parent_data',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.parentData ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      CustomText(
                        text: 'phone',
                        fontSize: fixSize(0.0165, context),
                        fontWeight: FontWeight.w300,
                        color: appColor.grey,
                      ),
                      CustomText(
                        text: data.parentContact ?? '',
                        fontSize: fixSize(0.0165, context),
                      ),
                      const Divider(),
                      Expanded(child: Container()),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                                height: size.height * 0.08,
                                borderRadius: 10,
                                backgroundColor: appColor.grey,
                                onPressed: () async {
                                  Get.back();
                                },
                                fontSize: fixSize(0.0165, context),
                                text: 'cancel'),
                          ),
                          SizedBox(width: size.width * 0.2),
                          Expanded(
                            child: ButtonWidget(
                                height: size.height * 0.08,
                                borderRadius: 10,
                                backgroundColor: appColor.mainColor,
                                onPressed: () async {
                                  adminStudentsState.confirmregisterStudent(
                                      id: data.id.toString());
                                  Get.back();
                                },
                                fontSize: fixSize(0.0165, context),
                                text: 'confirm'),
                          ),
                        ],
                      ),
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
        title: CustomText(text: 'register', color: appColor.mainColor),
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
        if (getD.registerList.isEmpty && getD.loadingRe == true) {
          return ShimmerListview();
        }
        if (getD.registerList.isEmpty && getD.loadingRe == false) {
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
        var value = getD.registerList
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
                (e.parentData ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.parentContact ?? '')
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
                      onTap: () {
                        showBottomDialogConfirm(value[index]);
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
                                    text:
                                        '${"phone".tr}: ${value[index].phone}',
                                    color: appColor.grey,
                                  ),
                                  CustomText(
                                    text:
                                        '${"class".tr}: ${value[index].myClassId?.name ?? ''}',
                                    color: appColor.grey,
                                  ),
                                ],
                              ),
                              trailing: CustomText(
                                text: value[index].admissionDate ?? '',
                                color: appColor.mainColor,
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
        if (getData.registerList.isEmpty) {
          return const SizedBox();
        }
        var value = getData.registerList
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
                (e.parentData ?? '')
                    .toLowerCase()
                    .contains(searchT.text.toLowerCase()) ||
                (e.parentContact ?? '')
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
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(value.length.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.mainColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"female".tr}:',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.red),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(woman.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.red),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"male".tr}:',
                          fontSize: fixSize(0.0185, context),
                          color: appColor.green),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(man.toString()))} ${"people".tr}',
                          fontSize: fixSize(0.0185, context),
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
