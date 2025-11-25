import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/expense_category_model.dart';
import 'package:multiple_school_app/states/adminschool/admin_expense_state.dart';
import 'package:multiple_school_app/states/superadmin/super_admin_state.dart';
import 'package:multiple_school_app/states/update_images_profile_state.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';

import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/widgets/drop_down_widget.dart';
import 'package:multiple_school_app/widgets/shimmer_listview.dart';

import '../../widgets/button_widget.dart';

class AdminExpense extends StatefulWidget {
  const AdminExpense({super.key, required this.branchId});
  final String branchId;
  @override
  State<AdminExpense> createState() => _AdminExpenseState();
}

class _AdminExpenseState extends State<AdminExpense> {
  AdminExpenseState adminExpenseState = Get.put(AdminExpenseState());
  final searchT = TextEditingController();
  final name = TextEditingController();
  final subtotal = TextEditingController();
  PickImageState pickImageState = Get.put(PickImageState());
  AppColor appColor = AppColor();
  @override
  void initState() {
    adminExpenseState.getexpeseCategory();
    getData();
    super.initState();
  }

  getData() {
    Future.delayed(Duration(seconds: 5));
    adminExpenseState.getData('', '', branchId: widget.branchId);
  }

  SuperAdminState superAdminState = Get.put(SuperAdminState());
  void showBottomDialogAdd() {
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
        return GetBuilder<AdminExpenseState>(builder: (getExpense) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: size.height * 0.98,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: '2',
                                  groupValue: adminExpenseState.payType,
                                  activeColor: appColor.mainColor,
                                  onChanged: (v) => {
                                    adminExpenseState
                                        .updatepayType(v.toString())
                                  },
                                ),
                                CustomText(
                                  text: 'cash',
                                  fontSize: fixSize(0.0165, context),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: '1',
                                  groupValue: adminExpenseState.payType,
                                  activeColor: appColor.mainColor,
                                  onChanged: (v) => {
                                    adminExpenseState
                                        .updatepayType(v.toString())
                                  },
                                ),
                                CustomText(
                                  text: 'transfer',
                                  fontSize: fixSize(0.0165, context),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: '2',
                                  groupValue: adminExpenseState.type,
                                  activeColor: appColor.mainColor,
                                  onChanged: (v) => {
                                    adminExpenseState.updateType(v.toString())
                                  },
                                ),
                                CustomText(
                                  text: 'income',
                                  fontSize: fixSize(0.0165, context),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: '1',
                                  groupValue: adminExpenseState.type,
                                  activeColor: appColor.mainColor,
                                  onChanged: (v) => {
                                    adminExpenseState.updateType(v.toString())
                                  },
                                ),
                                CustomText(
                                  text: 'expenses',
                                  fontSize: fixSize(0.0165, context),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '*',
                              color: appColor.red,
                              fontSize: fixSize(0.0165, context),
                            ),
                            CustomText(
                              text: 'type',
                              fontSize: fixSize(0.0165, context),
                            ),
                          ],
                        ),
                        CustomDropDownWidget<String>(
                          fixSize: fixSize(1, context),
                          appColor: appColor,
                          borderRaduis: 5.0,
                          value: adminExpenseState
                              .selectexpenseCategory, // Bind the selected status
                          dropdownData: adminExpenseState
                              .expenseCategoryList, // Use the status list
                          hint: '-- ${'type'.tr} --', // Hint text
                          listMenuItems:
                              adminExpenseState.expenseCategoryList.map((item) {
                            return DropdownMenuItem<ExpenseCategoryModel>(
                              value: item,
                              child: CustomText(
                                text: item.name ?? '', // Display status as text
                                fontSize: fixSize(0.0165, context),
                              ),
                            );
                          }).toList(),
                          onChange: (v) {
                            adminExpenseState.updateexpeseCategory(v);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '*',
                              color: appColor.red,
                              fontSize: fixSize(0.0185, context),
                            ),
                            CustomText(
                              text: 'transaction',
                              fontSize: fixSize(0.0165, context),
                            ),
                          ],
                        ),
                        TextField(
                          controller: name,
                          style: TextStyle(
                              fontSize: fixSize(0.0165, context)),
                          decoration: InputDecoration(
                            hintText: 'detail'.tr,
                            hintStyle: TextStyle(
                                color: appColor.grey,
                                fontSize: fixSize(0.0165, context)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '*',
                              color: appColor.red,
                              fontSize: fixSize(0.0185, context),
                            ),
                            CustomText(
                              text: 'amount',
                              fontSize: fixSize(0.0165, context),
                            ),
                          ],
                        ),
                        TextField(
                          controller: subtotal,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: fixSize(0.0165, context)),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                                color: appColor.grey,
                                fontSize: fixSize(0.0165, context)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '*',
                              color: appColor.red,
                              fontSize: fixSize(0.0165, context),
                            ),
                            CustomText(
                              text: 'date',
                              fontSize: fixSize(0.0165, context),
                            ),
                          ],
                        ),
                        TextField(
                          controller: superAdminState.payDate,
                          style: TextStyle(
                              fontSize: fixSize(0.0165, context)),
                          decoration: InputDecoration(
                            hintText: 'd/m/Y',
                            hintStyle: TextStyle(
                                color: appColor.grey,
                                fontSize: fixSize(0.0165, context)),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.date_range),
                                onPressed: () {
                                  superAdminState.selectDate(context, 'pay');
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
                        GetBuilder<PickImageState>(builder: (getFile) {
                          return Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                pickImageState.showPickImage(context);
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    width: size.width * 0.5,
                                    height:
                                        size.width * 0.5, // Square for a circle
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: appColor.mainColor),

                                      image: (getFile.file != null &&
                                              getFile.file!.path.isNotEmpty)
                                          ? DecorationImage(
                                              image: FileImage(
                                                  File(getFile.file!.path)),
                                              fit: BoxFit.cover,
                                            )
                                          : null, // No image if path is invalid
                                    ),
                                    child: (getFile.file == null ||
                                            getFile.file!.path.isEmpty)
                                        ? const Icon(Icons.image,
                                            size: 50, color: Colors.grey)
                                        : null, // Show icon only when no image
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        pickImageState.deleteFileImage();
                                      },
                                      icon: Icon(Icons.close,
                                          color: appColor.red))
                                ],
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        adminExpenseState.checkSave == false
                            ? CircleLoad()
                            : ButtonWidget(
                                height: size.height * 0.08,
                                borderRadius: 10,
                                backgroundColor: appColor.mainColor,
                                onPressed: () async {
                                  if (adminExpenseState.selectexpenseCategory ==
                                          null ||
                                      name.text == '' ||
                                      subtotal.text == '' ||
                                      superAdminState.payDate.text == '') {
                                    CustomDialogs().showToast(
                                      // ignore: deprecated_member_use
                                      backgroundColor:
                                          AppColor().red.withOpacity(0.8),
                                      text:
                                          'please_enter_all', // Message for "Entered amount is too large"
                                    );
                                    return;
                                  }
                                  adminExpenseState.postExpense(
                                      id: '0',
                                      name: name.text,
                                      dated: superAdminState.payDate.text,
                                      subtotal: subtotal.text,
                                      type: adminExpenseState.type,
                                      payType: adminExpenseState.payType,
                                      incomeexpendcategoryId: adminExpenseState
                                          .selectexpenseCategory!.id
                                          .toString(),
                                      image: pickImageState.file,
                                      branchId: widget.branchId,
                                      startDate: '',
                                      endDate: '');
                                  Get.back();
                                },
                                fontSize: fixSize(0.0165, context),
                                text: 'save'),
                      ],
                    ),
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
        return GetBuilder<SuperAdminState>(builder: (getSale) {
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
                          adminExpenseState.getData(
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
                          adminExpenseState.getData(
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
                              adminExpenseState.getData(
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
        title: CustomText(text: 'expenses', color: appColor.mainColor),
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
                superAdminState.setCurrentDate();
                setState(() {
                  name.text = '';
                  subtotal.text = '';
                });
                pickImageState.deleteFileImage();
                showBottomDialogAdd();
              },
              icon: Icon(
                Icons.add,
                color: appColor.mainColor,
              )),
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
      body: GetBuilder<AdminExpenseState>(builder: (getD) {
        if (getD.data == null && getD.loading == true) {
          return ShimmerListview();
        }
        if (getD.data == null && getD.loading == false) {
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
        return Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: RefreshIndicator(
                color: appColor.mainColor,
                onRefresh: () async {
                  superAdminState.clearData();
                  getData();
                },
                child: ListView.builder(
                  itemCount: getD.data!.items!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                          decoration: BoxDecoration(color: appColor.white),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    text:
                                        '${getD.data!.items![index].name ?? ""}(${getD.data!.items![index].category ?? ""})'),
                                CustomText(
                                  text: getD.data!.items![index].dated ?? '',
                                  color: appColor.grey,
                                ),
                              ],
                            ),
                            trailing: CustomText(
                              text: FormatPrice(
                                      price: num.parse(
                                          getD.data!.items![index].subtotal ??
                                              '0'))
                                  .toString(),
                              fontSize: fixSize(0.0145, context),
                              color: appColor.red,
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: GetBuilder<AdminExpenseState>(builder: (getData) {
        if (getData.data == null) {
          return const SizedBox();
        }
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
                          fontSize: fixSize(0.0165, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(getData.data!.items!.length.toString()))} ${"items".tr}',
                          fontSize: fixSize(0.0165, context),
                          color: appColor.mainColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: '${"total".tr}:',
                          fontSize: fixSize(0.0165, context),
                          color: appColor.mainColor),
                      CustomText(
                          text:
                              '${FormatPrice(price: num.parse(getData.data?.total ?? '0'))} ₭',
                          fontSize: fixSize(0.0165, context),
                          color: appColor.mainColor),
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
