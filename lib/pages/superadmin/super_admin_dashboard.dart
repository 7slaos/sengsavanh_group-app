import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/branch_model.dart';
import 'package:pathana_school_app/pages/adminschool/admin_profile.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/superadmin/super_admin_detail_school.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:pathana_school_app/states/superadmin/super_admin_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/drop_down_widget.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';
import 'package:shimmer/shimmer.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  ProfileState profileState = Get.put(ProfileState());
  SuperAdminState superAdminState = Get.put(SuperAdminState());
  final searchT = TextEditingController();
  @override
  void initState() {
    profileState.checkToken();
    getData();
    super.initState();
  }

  getData() {
    Future.delayed(Duration(seconds: 5));
    superAdminState.getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GetBuilder<ProfileState>(builder: (getPro) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Get.to(() => AdminProfile(), transition: Transition.fadeIn);
            },
            child: CustomText(
                text:
                    '${getPro.profiledModels?.firstname ?? ""} ${getPro.profiledModels?.lastname ?? ""}',
                color: AppColor().black,
                fontWeight: FontWeight.bold),
          );
        }),
        centerTitle: true,
        elevation: 4,
        surfaceTintColor: AppColor().white,
        leading: IconButton(
          icon:  Icon(Icons.account_circle, size: fixSize(0.025, context),),
          onPressed: () {
            Get.to(() => AdminProfile(), transition: Transition.fadeIn);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
              profileState.logouts();
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
      body: GetBuilder<LocaleState>(builder: (tran) {
        return GetBuilder<SuperAdminState>(builder: (getBran) {
          if (getBran.checkDashboard == false) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.white,
                            child: Container(
                              width: size.width,
                              height: size.height * 0.125,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          var value = getBran.branchList
              .where((e) =>
                  (e.nameLa ?? '')
                      .toLowerCase()
                      .contains(searchT.text.toLowerCase()) ||
                  (e.nameEn ?? '')
                      .toLowerCase()
                      .contains(searchT.text.toLowerCase()) ||
                  (e.nameCn ?? '')
                      .toLowerCase()
                      .contains(searchT.text.toLowerCase()))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFielWidget(
                  width: size.width,
                  height: fixSize(0.05, context),
                  icon: Icons.person,
                  hintText: 'search'.tr,
                  fixSize: fixSize(0.05, context),
                  appColor: AppColor(),
                  controller: searchT,
                  borderRaduis: 5.0,
                  margin: 0,
                  textInputType: TextInputType.text,
                  iconPrefix: Icon(
                    Icons.search,
                    size: fixSize(0.025, context),
                  ),
                  onChanged: (p0) {
                    superAdminState.update();
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColor().mainColor,
                    onRefresh: () async {
                      await getData();
                    },
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(
                                      () => SuperAdminDetailSchool(
                                          data: value[index]),
                                      transition: Transition.fadeIn);
                                },
                                child: IncomeExpenseCard(
                                  data: value[index],
                                ),
                              ),
                              value[index].status == 2
                                  ? CustomText(
                                      text: 'closed',
                                      color: AppColor().red,
                                    )
                                  : CustomText(
                                      text: 'opened',
                                      color: AppColor().green,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}

class IncomeExpenseCard extends StatefulWidget {
  final BranchModel data;

  const IncomeExpenseCard({super.key, required this.data});

  @override
  State<IncomeExpenseCard> createState() => _IncomeExpenseCardState();
}

class _IncomeExpenseCardState extends State<IncomeExpenseCard> {
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
                        text: 'status',
                        fontSize: fixSize(0.0185, context),
                        fontWeight: FontWeight.bold,
                      ),
                      CustomDropDownWidget<String>(
                        fixSize: fixSize(1, context),
                        appColor: appColor,
                        borderRaduis: 5.0,
                        value: superAdminState.status, // Should be a String
                        dropdownData: superAdminState.statusList
                            .toList(), // Map to a list of IDs
                        hint: '-- ${'status'.tr} --', // Hint text
                        listMenuItems: superAdminState.statusList.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['id'], // Ensure value is a String
                            child: CustomText(
                              text: item['name'] ??
                                  '', // Display name instead of entire map
                              fontSize: fixSize(0.015, context),
                            ),
                          );
                        }).toList(),
                        onChange: (v) {
                          superAdminState.selectStatus(v);
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'start_date',
                        fontSize: fixSize(0.0185, context),
                        fontWeight: FontWeight.bold,
                      ),
                      TextField(
                        controller: superAdminState.startDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () =>
                                superAdminState.selectDate(context, 'start'),
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
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomText(
                        text: 'end_date',
                        fontSize: fixSize(0.0185, context),
                        fontWeight: FontWeight.bold,
                      ),
                      TextField(
                        controller: superAdminState.endDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'd/m/Y',
                          hintStyle: TextStyle(color: appColor.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () =>
                                superAdminState.selectDate(context, 'end'),
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
                            if (superAdminState.status == '0' ||
                                superAdminState.startDate.text == '' ||
                                superAdminState.endDate.text == '') {
                              CustomDialogs().showToast(
                                // ignore: deprecated_member_use
                                backgroundColor:
                                    // ignore: deprecated_member_use
                                    AppColor().red.withOpacity(0.6),
                                text: 'please_enter_all'.tr,
                              );
                            } else {
                              superAdminState.updateBranch(
                                  context: context,
                                  id: superAdminState.id,
                                  status: superAdminState.status,
                                  start: superAdminState.startDate.text,
                                  end: superAdminState.endDate.text);
                            }
                          },
                          fontSize: fixSize(0.0165, context),
                          text: 'save'),
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
    return Container(
      padding: const EdgeInsets.all(8.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: CachedNetworkImage(
                  imageUrl: "${Repository().urlApi}${widget.data.logo}",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: CheckLang(
                            nameLa: widget.data.nameLa ?? '',
                            nameEn: widget.data.nameEn ?? '',
                            nameCn: widget.data.nameCn ?? '')
                        .toString(),
                    fontSize: fixSize(0.0165, context),
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text:
                        '${"start_date".tr}: ${widget.data.packageStartDate ?? ""}',
                    color: AppColor().grey,
                  ),
                  CustomText(
                    text:
                        '${"end_date".tr}: ${widget.data.packageEndDate ?? ""}',
                    color: AppColor().grey,
                  )
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                superAdminState.updateData(widget.data);
                showBottomDialog();
              },
              icon: Icon(Icons.more_horiz))
        ],
      ),
    );
  }
}
