import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/functions/format_price.dart';
import 'package:pathana_school_app/models/admin_schools_model.dart';
import 'package:pathana_school_app/models/branch_model.dart';
import 'package:pathana_school_app/states/adminschool/admin_dashboard_state.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/superadmin/super_admin_state.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/drop_down_widget.dart';

class SuperAdminDetailSchool extends StatefulWidget {
  const SuperAdminDetailSchool({super.key, this.data, this.branchid});
  final BranchModel? data;
  final String? branchid;
  @override
  State<SuperAdminDetailSchool> createState() => _SuperAdminDetailSchoolState();
}

class _SuperAdminDetailSchoolState extends State<SuperAdminDetailSchool> {
  final monthQty = TextEditingController();
  final note = TextEditingController();
  AppVerification appVerification = Get.put(AppVerification());
  SuperAdminState superAdminState = Get.put(SuperAdminState());
  AdminDashboardState adminDashboardState = Get.put(AdminDashboardState());
  final searchT = TextEditingController();
  AppColor appColor = AppColor();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    if (widget.branchid != null) {
      superAdminState.getPaymentPackage(id: widget.branchid.toString());
    } else {
      superAdminState.getPaymentPackage(id: widget.data?.id.toString() ?? '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(
          color: appColor.mainColor,
          text: widget.data != null
              ? CheckLang(
                      nameLa: widget.data?.nameLa ?? '',
                      nameEn: widget.data?.nameEn ?? '',
                      nameCn: widget.data?.nameCn ?? '')
                  .toString()
              : 'Contract_management',
          fontSize: fixSize(0.02, context),
        ),
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
      ),
      body: GetBuilder<AppVerification>(builder: (getRole) {
        return GetBuilder<SuperAdminState>(builder: (getData) {
          return Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              if (widget.data != null)
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: appColor.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "student",
                        color: appColor.mainColor,
                        fontSize: fixSize(0.0185, context),
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "all",
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse((int.parse(widget.data!.studentWoman.toString()) + int.parse(widget.data!.studentMan.toString())).toString())).toString()} ${"people".tr}',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "female",
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse(widget.data!.studentWoman.toString())).toString()} ${"people".tr}',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "male",
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                          CustomText(
                            text:
                                '${FormatPrice(price: num.parse(widget.data!.studentMan.toString())).toString()} ${"people".tr}',
                            color: appColor.mainColor,
                            fontSize: fixSize(0.0165, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (widget.branchid != null && getRole.role == '2')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetBuilder<AdminDashboardState>(builder: (getAdmin) {
                    return CustomDropDownWidget<String>(
                      fixSize: fixSize(1, context),
                      appColor: appColor,
                      borderRaduis: 5.0,
                      value: getAdmin.selectSchool, // Bind the selected status
                      dropdownData: getAdmin.schoolList, // Use the status list
                      hint: '-- ${'school'.tr} --', // Hint text
                      listMenuItems: getAdmin.schoolList.map((item) {
                        return DropdownMenuItem<AdminSchoolsModel>(
                          value: item,
                          child: CustomText(
                            text: item.nameLa ?? '', // Display status as text
                            fontSize: fixSize(0.015, context),
                          ),
                        );
                      }).toList(),
                      onChange: (selected) {
                        adminDashboardState.selectSchoolDropdown(selected);
                        superAdminState.getPaymentPackage(
                            id: selected.id.toString());
                      },
                    );
                  }),
                ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: getData.paymentPackageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text:
                                    "${FormatPrice(price: num.parse(getData.paymentPackageList[index].monthQty.toString()))} ${getData.paymentPackageList[index].type == 'm' ? 'month'.tr : 'year'.tr}",
                                fontSize: fixSize(0.0145, context),
                              ),
                              CustomText(
                                  text:
                                      "${FormatPrice(price: num.parse(getData.paymentPackageList[index].total ?? '0')).toString()} LAK",
                                  fontSize: fixSize(0.0145, context),
                                  color: getData.paymentPackageList[index]
                                              .status ==
                                          1
                                      ? appColor.red
                                      : appColor.green),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: getData
                                        .paymentPackageList[index].createdAt ??
                                    '',
                                color: AppColor().grey,
                                fontSize: fixSize(0.0145, context),
                              ),
                              CustomText(
                                text:
                                    getData.paymentPackageList[index].status ==
                                            1
                                        ? 'waiting'
                                        : 'approved',
                                color:
                                    getData.paymentPackageList[index].status ==
                                            1
                                        ? appColor.red
                                        : appColor.green,
                                fontSize: fixSize(0.0145, context),
                              ),
                            ],
                          ),
                          CustomText(
                            text: getData.paymentPackageList[index].note ?? '',
                            fontSize: fixSize(0.0145, context),
                            color: appColor.grey,
                          ),
                          CustomText(
                            text:
                                "${'LAPNet_reference_number'.tr}: ${getData.paymentPackageList[index].refPayment ?? ''}",
                            color: AppColor().grey,
                            fontSize: fixSize(0.0145, context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        });
      }),
      bottomNavigationBar: GetBuilder<SuperAdminState>(
        builder: (getSelect) {
          if (getSelect.paymentPackageList.isEmpty) {
            return const SizedBox();
          }
          num sumTotal = getSelect.paymentPackageList
              .fold(0, (sum, e) => sum + num.parse(e.total.toString()));
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: appColor.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 2,
                      color: Color.fromRGBO(213, 213, 213, 1),
                      offset: Offset(0, -2), // Moves shadow to the top
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'all',
                          fontWeight: FontWeight.bold,
                          fontSize: fixSize(0.0145, context),
                        ),
                        CustomText(
                            text:
                                '${FormatPrice(price: num.parse(superAdminState.paymentPackageList.length.toString())).toString()} ${"items".tr}',
                            fontWeight: FontWeight.bold,
                            fontSize: fixSize(0.0145, context)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            text: 'total',
                            fontWeight: FontWeight.bold,
                            fontSize: fixSize(0.0145, context)),
                        CustomText(
                            text:
                                '${FormatPrice(price: sumTotal).toString()} LAK',
                            fontSize: fixSize(0.0145, context),
                            color: appColor.green,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
