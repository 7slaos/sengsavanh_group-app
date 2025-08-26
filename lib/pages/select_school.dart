import 'dart:math';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/pages/register_page.dart';
import 'package:pathana_school_app/pages/register_school.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';

class SelectSchool extends StatefulWidget {
  const SelectSchool({super.key});

  @override
  State<SelectSchool> createState() => _SelectSchoolState();
}

class _SelectSchoolState extends State<SelectSchool> {
  final searchT = TextEditingController();
  AppColor appColors = AppColor();
  RegisterState registerState = Get.put(RegisterState());
  AddressState addressState = Get.put(AddressState());
  final Random _random = Random();
  // Generate a random color
  Color getRandomColor() {
    return Color.fromARGB(
      255, // Set alpha to full opacity
      _random.nextInt(256), // Red
      _random.nextInt(256), // Green
      _random.nextInt(256), // Blue
    );
  }

  @override
  void initState() {
    registerState.getSchools();
    registerState.getPackages();
    addressState.getReligion();
    addressState.getNationality();
    addressState.geteducationLevel();
    addressState.getlanguageGroup();
    addressState.getEthinicity();
    addressState.getSpecialHealth();
    addressState.getResidence();
    addressState.getBloodGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fsize = size.width + size.height;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: appColors.white,
          elevation: 4,
          surfaceTintColor: appColors.white,
          title: CustomText(
            text: 'register',
            color: appColors.mainColor,
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: appColors.mainColor,
            ),
          ),
        ),
        body: GetBuilder<RegisterState>(builder: (getRis) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    size.height * 0.07, // Match the height for proper layout
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => {
                          registerState.updateIndex(0),
                          registerState.getSchools()
                        },
                        child: Container(
                          height: double
                              .infinity, // Ensure it covers the full height

                          decoration: BoxDecoration(
                              color: appColors.white,
                              border: Border(
                                  bottom: registerState.index == 0
                                      ? BorderSide(
                                          width: 2, color: appColors.mainColor)
                                      : BorderSide.none)),
                          child: Center(
                            child: CustomText(
                              text: 'student',
                              color: registerState.index == 0
                                  ? appColors.mainColor
                                  : appColors.grey,
                              fontSize: fixSize(0.0185, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // registerState.updateIndex(1);
                          // registerState.getPackages();
                          registerState.cleardropdownList();
                          Get.to(() => RegisterSchool(packageId: '1'),
                              transition: Transition.fadeIn);
                        },
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              border: Border(
                                  bottom: registerState.index == 1
                                      ? BorderSide(
                                          width: 2, color: appColors.mainColor)
                                      : BorderSide.none)),
                          child: Center(
                            child: CustomText(
                              text: 'school',
                              color: registerState.index == 1
                                  ? appColors.mainColor
                                  : appColors.grey,
                              fontSize: fixSize(0.0185, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      width: 4,
                      color: appColors.mainColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    registerState.index == 0
                        ? CustomText(
                            text: 'select_school',
                            fontSize: fsize * 0.0165,
                            color: appColors.grey,
                          )
                        : CustomText(
                            text: 'select_package',
                            fontSize: fsize * 0.0165,
                            color: appColors.grey,
                          )
                  ],
                ),
              ),
              registerState.index == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFielWidget(
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
                          registerState.update();
                        },
                      ),
                    )
                  : SizedBox(height: 8.0),
              GetBuilder<RegisterState>(builder: (getData) {
                if (getData.checkSchool == false) {
                  return SizedBox(
                    height: fsize * 0.4,
                    child: Center(child: CircleLoad()),
                  );
                }
                if (getData.schoolList.isEmpty && getData.index == 0) {
                  return SizedBox(
                    height: fsize * 0.4,
                    child: Center(
                      child: CustomText(
                        text: 'No_information_yet',
                        fontSize: fsize * 0.0185,
                      ),
                    ),
                  );
                }
                if (getData.packageList.isEmpty && getData.index == 1) {
                  return SizedBox(
                    height: fsize * 0.4,
                    child: Center(
                      child: CustomText(
                        text: 'No_information_yet',
                        fontSize: fsize * 0.0185,
                      ),
                    ),
                  );
                }
                if (registerState.index == 0) {
                  var value = getData.schoolList
                      .where((e) =>
                          (e.nameLa ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()) ||
                          (e.nameEn ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()) ||
                          (e.nameCn ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()) ||
                          (e.addressLa ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()) ||
                          (e.addressEn ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()) ||
                          (e.addressCn ?? '')
                              .toLowerCase()
                              .contains(searchT.text.toLowerCase()))
                      .toList();
                  return Expanded(
                    child: RefreshIndicator(
                      color: appColors.mainColor,
                      onRefresh: () async {
                        registerState.getSchools();
                      },
                      child: ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                registerState.cleardropdownList();
                                Get.to(
                                    () => RegisterPage(
                                          data: value[index],
                                        ),
                                    transition: Transition.fadeIn);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  color: appColors.white,
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: CheckLang(
                                                      nameLa:
                                                          value[index].nameLa ??
                                                              '',
                                                      nameEn:
                                                          value[index].nameEn ??
                                                              '',
                                                      nameCn:
                                                          value[index].nameCn ??
                                                              '')
                                                  .toString(),
                                              color: appColors.mainColor,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.85,
                                              child: CustomText(
                                                text:
                                                    '${"village".tr} ${value[index].addressLa ?? ""},${value[index].addressEn ?? ""},${value[index].addressCn ?? ""}',
                                                color: appColors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: appColors.mainColor,
                                          size: fsize * 0.0125,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }
                if (registerState.index == 1) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: getData.packageList.length,
                      itemBuilder: (context, index) {
                        final package = getData.packageList[index];

                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            registerState.cleardropdownList();
                            Get.to(
                              () => RegisterSchool(
                                data: package,
                              ),
                              transition: Transition.fadeIn,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border(
                                  top: BorderSide(
                                      width: 2, color: appColors.mainColor),
                                  bottom: BorderSide(
                                      width: 2, color: appColors.mainColor),
                                ),
                              ),
                              child: ListTile(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: package.name ?? '',
                                    color: appColors.mainColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (package.items !=
                                        null) // Check if items is not null
                                      for (var i = 0;
                                          i < package.items!.length;
                                          i++)
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.radio_button_checked,
                                                  color: appColors.green,
                                                ),
                                                CustomText(
                                                  text: package.items![i].des ??
                                                      '',
                                                  color: appColors.mainColor,
                                                ),
                                              ],
                                            ),
                                            if (package.items![i].childs !=
                                                null) // Check if childs is not null
                                              for (var a = 0;
                                                  a <
                                                      package.items![i].childs!
                                                          .length;
                                                  a++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: appColors.green,
                                                      ),
                                                      CustomText(
                                                        text: package
                                                                .items![i]
                                                                .childs![a]
                                                                .des ??
                                                            '',
                                                        color:
                                                            appColors.mainColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: 'select',
                                        fontSize: fsize * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              })
            ],
          );
        }));
  }
}
