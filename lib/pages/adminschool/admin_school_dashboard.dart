import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/functions/format_price.dart';
import 'package:multiple_school_app/models/admin_schools_model.dart';
import 'package:multiple_school_app/pages/adminschool/admin_expense.dart';
import 'package:multiple_school_app/pages/adminschool/admin_profile.dart';
import 'package:multiple_school_app/pages/adminschool/admin_students.dart';
import 'package:multiple_school_app/pages/adminschool/confirm_register.dart';
import 'package:multiple_school_app/pages/adminschool/tuition_fee.dart';
import 'package:multiple_school_app/pages/adminschool/update_package.dart';
import 'package:multiple_school_app/pages/change_language_page.dart';
import 'package:multiple_school_app/pages/superadmin/super_admin_detail_school.dart';
import 'package:multiple_school_app/states/adminschool/admin_dashboard_state.dart';
import 'package:multiple_school_app/states/profile_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:multiple_school_app/widgets/drop_down_widget.dart';
import 'package:multiple_school_app/widgets/shimmer_listview.dart';

import '../teacher_recordes/chec_in_check_out_page.dart';
import '../teacher_recordes/check_in_map_page.dart';
import '../teacher_recordes/dashboard_page.dart';
import '../teacher_recordes/teacher_card_page.dart';

class AdminSchoolDashboard extends StatefulWidget {
  const AdminSchoolDashboard({super.key});

  @override
  State<AdminSchoolDashboard> createState() => _AdminSchoolDashboardState();
}

class _AdminSchoolDashboardState extends State<AdminSchoolDashboard> {
  ProfileState profileState = Get.put(ProfileState());
  AdminDashboardState adminDashboardState = Get.put(AdminDashboardState());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profileState.profiledModels == null) {
        profileState.checkToken();
      }
      adminDashboardState.getSchools();
      getData();
    });
    super.initState();
  }

  getData() {
    adminDashboardState.setcurrentDate();
    DateTime now = DateTime.now();
    String startDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    String endDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    adminDashboardState.getDashboard('0', startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppColor appColor = AppColor();
    final scale = (size.width / 390).clamp(0.9, 1.3);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GetBuilder<ProfileState>(builder: (getPro) {
          final g = getPro.profiledModels?.gender?.toString();
          final prefix = g == '1'
              ? 'ນາງ '
              : g == '2'
                  ? 'ທ້າວ '
                  : '';
          return Text(
            prefix +
                '${getPro.profiledModels?.firstname ?? ""} ${getPro.profiledModels?.lastname ?? ""}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          );
        }),
        centerTitle: true,
        elevation: 4,
        surfaceTintColor: AppColor().white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showBottomDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              Get.to(() => const ChangeLanguagePage(),
                  transition: Transition.fadeIn);
            },
          ),
        ],
      ),
      drawer: GetBuilder<AdminDashboardState>(builder: (getData) {
        return Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Remove the border radius
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: CustomText(
                  text: 'home',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: CustomText(
                    text: '${"student".tr}${"all".tr}',
                    fontSize: fixSize(0.0185, context)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(
                      () => AdminStudents(
                          branchId: adminDashboardState.selectSchool != null
                              ? adminDashboardState.selectSchool!.id.toString()
                              : ''),
                      transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.money),
                title: CustomText(
                  text: 'Pay_tuition_fees',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(
                      () => TuitionFee(
                          type: 'debt',
                          branchId: adminDashboardState.selectSchool != null
                              ? adminDashboardState.selectSchool!.id.toString()
                              : ''),
                      transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.feed_outlined),
                title: CustomText(
                  text: 'Contract_management',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(
                      () => SuperAdminDetailSchool(
                          branchid: adminDashboardState.selectSchool != null
                              ? adminDashboardState.selectSchool!.id.toString()
                              : '0'),
                      transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: CustomText(
                  text: 'expenses',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => AdminExpense(branchId: adminDashboardState.selectSchool != null
                              ? adminDashboardState.selectSchool!.id.toString()
                              : '0'), transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner),
                title: CustomText(
                  text: 'scan-in-out',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => CheckInCheckOutPage(type: 'a'), transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: CustomText(
                  text: 'profile',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => AdminProfile(), transition: Transition.fadeIn);
                },
              ),
              ListTile(
                leading: Icon(Icons.power_settings_new_rounded),
                title: CustomText(
                  text: 'logout',
                  fontSize: fixSize(0.0185, context),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: fixSize(0.0115, context),
                ),
                onTap: () {
                  Get.back();
                  profileState.logouts();
                },
              )
            ],
          ),
        );
      }),
      body: GetBuilder<LocaleState>(builder: (tran) {
        return GetBuilder<AdminDashboardState>(builder: (getSale) {
          if (getSale.checkDashboard == false) {
            return ShimmerListview();
          }
          return RefreshIndicator(
            color: AppColor().mainColor,
            onRefresh: () async {
              adminDashboardState.setcurrentDate();
              adminDashboardState.getSchools();
              Future.delayed(Duration(seconds: 5));
              await adminDashboardState.getDashboard(
                  adminDashboardState.selectSchool?.id.toString() ?? '0',
                  adminDashboardState.startDate.text,
                  adminDashboardState.endDate.text);
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QuickAction(
                              scale: scale,
                              icon: Icons.location_on,
                              label: 'Check-In',
                              onTap: () {
                                Get.to(() => CheckInMapPage(type: 'a',status: 'check_in'), transition: Transition.fadeIn);
                              },
                            ),
                            SizedBox(width: 20),
                            QuickAction(
                              scale: scale,
                              icon: Icons.qr_code_scanner,
                              label: 'Scan List',
                              onTap: () {
                                Get.to(() => CheckInCheckOutPage(type: 'a'), transition: Transition.fadeIn);
                              },
                            ),
                            SizedBox(width: 20),
                            QuickAction(
                              scale: scale,
                              icon: Icons.qr_code_2,
                              label: 'My QR',
                              onTap: () {
                                Get.to(() => TeacherCardPage(), transition: Transition.fadeIn);
                              },
                            ),
                            SizedBox(width: 20),
                            QuickAction(
                              scale: scale,
                              icon: Icons.location_on,
                              label: 'Check-Out',
                              color: appColor.red,
                              onTap: () {
                                Get.to(() => CheckInMapPage(type: 'a',status: 'check_out', id: 'today'), transition: Transition.fadeIn);
                              },
                            ),
                          ],
                        ),
                      ),
                      if (adminDashboardState.selectSchool != null &&
                          adminDashboardState.selectSchool?.nameLa != 'all')
                        CustomText(
                          text: adminDashboardState.selectSchool?.nameLa ?? '',
                          fontSize: fixSize(0.0225, context),
                        ),
                      if (adminDashboardState.startDate.text != '' &&
                          adminDashboardState.endDate.text != '') ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: 4,
                              color: appColor.mainColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              text:
                                  '${"start_date".tr}: ${adminDashboardState.startDate.text} - ${adminDashboardState.endDate.text}',
                              fontSize: fixSize(0.0165, context),
                              color: appColor.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        )
                      ],
                      TotalIncomeCard(
                        title: 'total_income',
                        totalIncome: adminDashboardState
                                .adminDashboardModel?.totalincomeAll ??
                            '0',
                        width: size.width,
                        fontSize: fixSize(0.0165, context),
                        backgroundColor: Color(0xFF17A2B8),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TotalIncomeCard(
                        title: '${"total_income".tr}(${"cash".tr})',
                        totalIncome: adminDashboardState
                                .adminDashboardModel?.totalincomeAllCash ??
                            '0',
                        width: size.width,
                        fontSize: fixSize(0.0165, context),
                        backgroundColor: Color(0xFF17A2B8),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TotalIncomeCard(
                        title: '${"total_income".tr}(${"transfer".tr})',
                        totalIncome: adminDashboardState.adminDashboardModel
                                ?.totalincomeAllTransfer ??
                            '0',
                        width: size.width,
                        fontSize: fixSize(0.0165, context),
                        backgroundColor: Color(0xFF17A2B8),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => TuitionFee(
                                  type: 'all',
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: TotalIncomeCard(
                          title: 'Total_income_plan',
                          totalIncome: adminDashboardState
                                  .adminDashboardModel?.totalAll ??
                              '0',
                          width: size.width,
                          fontSize: fixSize(0.0165, context),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => TuitionFee(
                                  type: 'paid',
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: TotalIncomeCard(
                          title: '${"paid".tr}${"all".tr}',
                          totalIncome: adminDashboardState
                                  .adminDashboardModel?.totalIncome ??
                              '0',
                          width: size.width,
                          fontSize: fixSize(0.0165, context),
                          backgroundColor: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => TuitionFee(
                                  type: 'debt',
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: TotalIncomeCard(
                          title: '${"outstanding_tuition_fees".tr}${"all".tr}',
                          totalIncome: (num.parse(adminDashboardState
                                      .adminDashboardModel?.totalDebt ??
                                  '0'))
                              .toString(),
                          width: size.width,
                          fontSize: fixSize(0.0165, context),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => AdminExpense(
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: TotalIncomeCard(
                          title: 'expenses',
                          totalIncome: adminDashboardState
                                  .adminDashboardModel?.totalExpense ??
                              '0',
                          width: size.width,
                          fontSize: fixSize(0.0165, context),
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TotalIncomeCard(
                        title: 'balance_income',
                        totalIncome: adminDashboardState
                                .adminDashboardModel?.totalBalance ??
                            '0',
                        width: size.width,
                        fontSize: fixSize(0.0165, context),
                        backgroundColor: AppColor().blueLight,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => ConfirmRegister(),
                              transition: Transition.fadeIn);
                        },
                        child: IncomeExpenseCard(
                          amount:
                              '${FormatPrice(price: num.parse(adminDashboardState.adminDashboardModel?.registercountman ?? '0') + num.parse(adminDashboardState.adminDashboardModel?.registercountwomen ?? '0'))} ${"people".tr}',
                          label:
                              '${"register".tr} ${"female".tr}(${FormatPrice(price: num.parse(adminDashboardState.adminDashboardModel?.registercountwomen ?? '0'))})',
                          color: Colors.deepOrangeAccent,
                          iconData: Icons.people,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => AdminStudents(
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: IncomeExpenseCard(
                          amount:
                              '${FormatPrice(price: num.parse(adminDashboardState.adminDashboardModel?.studentAll ?? '0'))} ${"people".tr}',
                          label: '${"student".tr}(${"all".tr})',
                          color: Colors.blue,
                          iconData: Icons.people,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => AdminStudents(
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: IncomeExpenseCard(
                          amount:
                              '${FormatPrice(price: num.parse(adminDashboardState.adminDashboardModel?.studentWomen ?? '0'))} ${"people".tr}',
                          label: '${"student".tr}(${"female".tr})',
                          color: Colors.red,
                          iconData: Icons.woman_rounded,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(
                              () => AdminStudents(
                                  branchId:
                                      adminDashboardState.selectSchool != null
                                          ? adminDashboardState.selectSchool!.id
                                              .toString()
                                          : ''),
                              transition: Transition.fadeIn);
                        },
                        child: IncomeExpenseCard(
                          amount:
                              '${FormatPrice(price: num.parse(adminDashboardState.adminDashboardModel?.studentMan ?? '0'))} ${"people".tr}',
                          label: '${"student".tr}(${"male".tr})',
                          color: Colors.green,
                          iconData: Icons.person,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar: GetBuilder<AdminDashboardState>(builder: (getData) {
        if (getData.adminDashboardModel == null) {
          return const SizedBox();
        }
        return SizedBox(
          height: size.height * 0.1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: getData.adminDashboardModel!.packages!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => UpdatePackage(),
                              transition: Transition.fadeIn);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: size.width,
                          alignment: Alignment.center,
                          color: AppColor().mainColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: CheckLang(
                                            nameLa: getData.adminDashboardModel!
                                                    .packages![index].nameLa ??
                                                '',
                                            nameEn: getData.adminDashboardModel!
                                                    .packages![index].nameEn ??
                                                '',
                                            nameCn: getData.adminDashboardModel!
                                                    .packages![index].nameCn ??
                                                '')
                                        .toString(),
                                    fontSize: fixSize(0.0135, context),
                                    color: AppColor().white,
                                  ),
                                  CustomText(
                                    text:
                                        '${"start_date".tr}: ${getData.adminDashboardModel!.packages![index].startDate ?? ''} - ${getData.adminDashboardModel!.packages![index].endDate ?? ''} (${getData.adminDashboardModel!.packages![index].expiryCount! >= 0 ? 'ຍັງເຫຼືອ: ${getData.adminDashboardModel!.packages![index].expiryCount}' : 'ກາຍສັນຍາ: ${getData.adminDashboardModel!.packages![index].expiryCount}'} ວັນ)',
                                    fontSize: fixSize(0.0115, context),
                                    color: AppColor().white,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColor().white,
                                    size: fixSize(0.0115, context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColor().white,
                                    size: fixSize(0.0115, context),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      }),
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
                        text: 'school',
                        fontSize: fixSize(0.0185, context),
                      ),
                      CustomDropDownWidget<String>(
                        fixSize: fixSize(1, context),
                        appColor: appColor,
                        borderRaduis: 5.0,
                        value: adminDashboardState
                            .selectSchool, // Bind the selected status
                        dropdownData: adminDashboardState
                            .schoolList, // Use the status list
                        hint: '-- ${'school'.tr} --', // Hint text
                        listMenuItems:
                            adminDashboardState.schoolList.map((item) {
                          return DropdownMenuItem<AdminSchoolsModel>(
                            value: item,
                            child: CustomText(
                              text: item.nameLa ?? '', // Display status as text
                              fontSize: fixSize(0.015, context),
                            ),
                          );
                        }).toList(),
                        onChange: (selected) {
                          adminDashboardState.selectSchoolDropdown(selected!);
                          adminDashboardState.getDashboard(
                              adminDashboardState.selectSchool?.id.toString() ??
                                  '0',
                              adminDashboardState.startDate.text,
                              adminDashboardState.endDate.text);
                        },
                      ),
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
                        style: TextStyle(fontSize:fixSize(0.0185, context)),
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey, fontSize:fixSize(0.0185, context)),
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
                          await adminDashboardState.getDashboard(
                              adminDashboardState.selectSchool?.id.toString() ??
                                  '0',
                              adminDashboardState.startDate.text,
                              adminDashboardState.endDate.text);
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
                        style: TextStyle(fontSize:fixSize(0.0185, context)),
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey, fontSize:fixSize(0.0185, context)),
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
                          await adminDashboardState.getDashboard(
                              adminDashboardState.selectSchool?.id.toString() ??
                                  '0',
                              adminDashboardState.startDate.text,
                              adminDashboardState.endDate.text);
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
                            adminDashboardState.getDashboard(
                                adminDashboardState.selectSchool?.id
                                        .toString() ??
                                    '',
                                adminDashboardState.startDate.text.toString(),
                                adminDashboardState.endDate.text.toString());
                            Get.back();
                          },
                          fontSize: fixSize(0.0185, context),
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
}

class TotalIncomeCard extends StatefulWidget {
  final String totalIncome;
  final double width;
  final double fontSize;
  final double borderRadius;
  final String title;
  final Color backgroundColor;

  const TotalIncomeCard(
      {super.key,
      required this.totalIncome,
      required this.width,
      required this.fontSize,
      this.borderRadius = 12,
      required this.title,
      required this.backgroundColor});

  @override
  // ignore: library_private_types_in_public_api
  _TotalIncomeCardState createState() => _TotalIncomeCardState();
}

class _TotalIncomeCardState extends State<TotalIncomeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${FormatPrice(price: num.parse(widget.totalIncome))} ₭ ',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          CustomText(
            text: widget.title,
            fontSize: 12,
            color: Colors.white70,
          )
        ],
      ),
    );
  }
}

class IncomeExpenseCard extends StatelessWidget {
  final String amount;
  final String label;
  final Color color;
  final IconData iconData;

  const IncomeExpenseCard(
      {super.key,
      required this.amount,
      required this.label,
      required this.color,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Icon(
              iconData,
              size: fixSize(0.05, context),
              color: color,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: amount,
                fontSize: fixSize(0.0165, context),
                color: color,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: label,
                color: AppColor().grey,
              )
            ],
          ),
        ],
      ),
    );
  }
}
