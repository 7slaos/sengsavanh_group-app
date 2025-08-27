import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/pages/parent_recordes/call_children_page.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/call_student_state.dart';
import 'package:pathana_school_app/widgets/custom_app_bar.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class TakeChildrenPage extends StatefulWidget {
  const TakeChildrenPage({super.key});

  @override
  State<TakeChildrenPage> createState() => _TakeChildrenPageState();
}

class _TakeChildrenPageState extends State<TakeChildrenPage>
    with SingleTickerProviderStateMixin {
  final searchT = TextEditingController();
  AppVerification appVerification = Get.put(AppVerification());
  CallStudentState callStudentState = Get.put(CallStudentState());
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  AppColor appColor = AppColor();
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
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    if (appVerification.role == '') {
      appVerification.setInitToken();
    }
    getData();
    addListen();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        callStudentState.updatePage();
        getData();
      }
    });
  }

  getData() async {
    await callStudentState.getData('${tabController.index + 1}', 'all');
  }

  addListen() {
    tabController.addListener(() {
      callStudentState.update();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fixSizes = size.width + size.height;
    return Scaffold(
        // ignore: deprecated_member_use
        backgroundColor: Colors.white.withOpacity(0.95),
        appBar: CustomAppBar(
            leading: InkWell(
              onTap: () => {Get.back()},
              child: Icon(
                Icons.arrow_back,
                color: appColor.white,
              ),
            ),
            orientation: orientation,
            height: size.height,
            color: appColor.white,
            title: "take_children"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  text: "new".tr,
                ),
                Tab(
                  text: "called".tr,
                ),
                Tab(
                  text: "success".tr,
                ),
              ],
              onTap: (index) {
                if (index == 2) {
                  callStudentState.cleargetData();
                }
                getData();
              },
              dividerHeight: 0.0,
              labelColor: appColor.mainColor,
              indicatorColor: appColor.mainColor,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: appColor.mainColor, // Color of the indicator line
                  width: 2.0, // Thickness of the line
                ),
                insets: EdgeInsets.symmetric(
                  horizontal: size.width / 4, // Make it 50% of the screen width
                ),
              ),
              unselectedLabelStyle: TextStyle(
                  fontSize: fixSize(0.0165, context),
                  fontFamily: 'Noto Sans Lao'),
              labelStyle: TextStyle(
                  fontSize: fixSize(0.0175, context),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Noto Sans Lao'),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchT, // Attach the controller
                onChanged: (value) => {callStudentState.update()},
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
            GetBuilder<CallStudentState>(builder: (getCall) {
              if (getCall.check == false && getCall.data.isEmpty) {
                return Expanded(child: Center(child: CircleLoad()));
              }
              if (getCall.data.isEmpty && getCall.check == true) {
                return Expanded(
                  child: Center(
                    child: CustomText(
                      text: 'not_found_data',
                      fontSize: fixSizes * 0.0165,
                      color: appColor.grey,
                    ),
                  ),
                );
              }
              var value = getCall.data
                  .where(
                      (e) => e.pCarnumber!.toLowerCase().contains(searchT.text))
                  .toList();
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tabController.index != 2
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: CustomText(
                              text:
                                  '${"all".tr}: ${getCall.data.length} ${"items".tr}',
                              color: appColor.grey,
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: RefreshIndicator(
                        color: appColor.mainColor,
                        onRefresh: () async {
                          if (tabController.index != 2) {
                            getData();
                          }
                        },
                        child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.only(bottom: size.height * 0.15),
                          itemCount: tabController.index == 2
                              ? value.length + 1
                              : value.length,
                          itemBuilder: (context, index) {
                            if (tabController.index == 2) {
                              if (index < value.length) {
                                return GetBuilder<AppVerification>(
                                    builder: (getRole) {
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () => {
                                      if (value[index].status != 3)
                                        {
                                          AwesomeDialog(
                                            // ignore: use_build_context_synchronously
                                            context: context,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.scale,
                                            title: value[index].status == 2
                                                ? 'send_students'.tr
                                                : 'confirm'.tr,
                                            desc: 'do_you_want_to_confirm'.tr,
                                            dismissOnTouchOutside: false,
                                            btnOkText: 'Ok',
                                            dismissOnBackKeyPress: false,
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              callStudentState
                                                  .tearchconfirmcallStudent(
                                                      context: context,
                                                      id: value[index]
                                                          .id
                                                          .toString(),
                                                      status: getRole.role ==
                                                              'p'
                                                          ? '3'
                                                          : ((value[index]
                                                                      .status! +
                                                                  1)
                                                              .toString()));
                                            },
                                          ).show()
                                        }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      margin: EdgeInsets.only(
                                          top: fixSize(0.008, context)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: size.width,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: appColor.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius:
                                                      fixSize(0.0025, context),
                                                  offset: const Offset(0, 1),
                                                  color: appColor.grey,
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                value[index].pCarnumber != ''
                                                    ? CustomText(
                                                        text:
                                                            "${'car_number'.tr}: ${value[index].pCarnumber ?? ''}",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            appColor.mainColor,
                                                        fontSize: fixSize(
                                                            0.0165, context),
                                                      )
                                                    : const SizedBox(),
                                                if (value[index].items !=
                                                        null &&
                                                    value[index]
                                                        .items!
                                                        .isNotEmpty)
                                                  ...value[index]
                                                      .items!
                                                      .map((item) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundColor: getCall
                                                                              .data[
                                                                                  index]
                                                                              .status ==
                                                                          1
                                                                      ? appColor
                                                                          .grey
                                                                          // ignore: deprecated_member_use
                                                                          .withOpacity(
                                                                              0.6)
                                                                      : getCall.data[index].status ==
                                                                              2
                                                                          ? appColor
                                                                              .mainColor
                                                                              // ignore: deprecated_member_use
                                                                              .withOpacity(0.6)
                                                                          : appColor.green
                                                                              // ignore: deprecated_member_use
                                                                              .withOpacity(0.6),
                                                                  child:
                                                                      CustomText(
                                                                    text:  (item.firstname.toString() !='' && item.firstname.toString() !='null') ?  item
                                                                        .firstname
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            1) : '',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: appColor
                                                                        .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CustomText(
                                                                      text:
                                                                          '${item.firstname ?? ""} ${item.lastname ?? ""}',
                                                                      fontSize: fixSize(
                                                                          0.0145,
                                                                          context),
                                                                    ),
                                                                    CustomText(
                                                                        text:
                                                                            '${'class_room'.tr}: ${item.myClass}',
                                                                        fontSize: fixSize(
                                                                            0.0145,
                                                                            context),
                                                                        color: value[index].status ==
                                                                                1
                                                                            ? appColor.red
                                                                                // ignore: deprecated_member_use
                                                                                .withOpacity(0.65)
                                                                            : appColor.green
                                                                                // ignore: deprecated_member_use
                                                                                .withOpacity(0.65)),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                (getRole.role == 't' &&
                                                        value[index].note !=
                                                            null)
                                                    ? CustomText(
                                                        text:
                                                            value[index].note ??
                                                                '',
                                                        color: appColor
                                                            .mainColor
                                                            // ignore: deprecated_member_use
                                                            .withOpacity(0.8),
                                                        fontSize: fixSize(
                                                            0.0145, context),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              value[index].status == 3
                                                  ? CustomText(
                                                      text: getCall.data[index]
                                                              .date ??
                                                          '',
                                                      color: appColor.grey,
                                                      fontSize:
                                                          fixSizes * 0.0135,
                                                    )
                                                  : Container(
                                                      width: size.width * 0.15,
                                                      height: fixSize(
                                                          0.0195, context),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            appColor.mainColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(fixSize(
                                                                        0.004,
                                                                        context))),
                                                      ),
                                                      child: Center(
                                                        child: CustomText(
                                                          text: '${index + 1}',
                                                          color: appColor.white,
                                                          fontSize:
                                                              fixSizes * 0.0145,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              } else {
                                return Center(
                                  child: getCall.isLoading
                                      ? CircleLoad()
                                      : const SizedBox(),
                                );
                              }
                            } else {
                              return GetBuilder<AppVerification>(
                                  builder: (getRole) {
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () => {
                                    if (value[index].status != 3)
                                      {
                                        AwesomeDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.scale,
                                          title: value[index].status == 2
                                              ? 'send_students'.tr
                                              : 'confirm'.tr,
                                          desc: 'do_you_want_to_confirm'.tr,
                                          dismissOnTouchOutside: false,
                                          btnOkText: 'ok'.tr,
                                          btnCancelText: 'cancel'.tr,
                                          dismissOnBackKeyPress: false,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            callStudentState
                                                  .tearchconfirmcallStudent(
                                                      context: context,
                                                      id: value[index]
                                                          .id
                                                          .toString(),
                                                      status: getRole.role ==
                                                              'p'
                                                          ? '3'
                                                          : ((value[index]
                                                                      .status! +
                                                                  1)
                                                              .toString()));
                                          },
                                        ).show()
                                      }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    margin: EdgeInsets.only(
                                        top: fixSize(0.008, context)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: size.width,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: appColor.white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius:
                                                    fixSize(0.0025, context),
                                                offset: const Offset(0, 1),
                                                color: appColor.grey,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getRole.role == 'p'
                                                  ? CustomText(
                                                      text: value[index].date ??
                                                          '',
                                                      color: appColor.mainColor
                                                          // ignore: deprecated_member_use
                                                          .withOpacity(0.8),
                                                      fontSize: fixSize(
                                                          0.0145, context),
                                                    )
                                                  : value[index].pCarnumber !=
                                                          ''
                                                      ? CustomText(
                                                          text:
                                                              "${'car_number'.tr}: ${value[index].pCarnumber ?? ''}",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: appColor
                                                              .mainColor,
                                                          fontSize: fixSize(
                                                              0.0165, context),
                                                        )
                                                      : const SizedBox(),
                                              if (value[index].items != null &&
                                                  value[index]
                                                      .items!
                                                      .isNotEmpty)
                                                ...value[index]
                                                    .items!
                                                    .map((item) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: getCall
                                                                            .data[
                                                                                index]
                                                                            .status ==
                                                                        1
                                                                    ? appColor
                                                                        .grey
                                                                        // ignore: deprecated_member_use
                                                                        .withOpacity(
                                                                            0.6)
                                                                    : getCall.data[index].status ==
                                                                            2
                                                                        ? appColor
                                                                            .mainColor
                                                                            // ignore: deprecated_member_use
                                                                            .withOpacity(
                                                                                0.6)
                                                                        : appColor
                                                                            .green
                                                                            // ignore: deprecated_member_use
                                                                            .withOpacity(0.6),
                                                                child:
                                                                    CustomText(
                                                                  text: (item.firstname.toString() !='' && item.firstname.toString() !='null') ? item
                                                                      .firstname
                                                                      .toString()
                                                                      .substring(
                                                                          0, 1) : '',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: appColor
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CustomText(
                                                                    text:
                                                                        '${item.firstname ?? ""} ${item.lastname ?? ""}',
                                                                    fontSize: fixSize(
                                                                        0.0145,
                                                                        context),
                                                                  ),
                                                                  CustomText(
                                                                      text:
                                                                          '${'class_room'.tr}: ${item.myClass}',
                                                                      fontSize: fixSize(
                                                                          0.0145,
                                                                          context),
                                                                      color: value[index].status ==
                                                                              1
                                                                          ? appColor
                                                                              .red
                                                                              // ignore: deprecated_member_use
                                                                              .withOpacity(0.65)
                                                                          : value[index].status == 2
                                                                              ? appColor.mainColor
                                                                                  // ignore: deprecated_member_use
                                                                                  .withOpacity(0.65)
                                                                              : appColor.green
                                                                                  // ignore: deprecated_member_use
                                                                                  .withOpacity(0.65)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                              (getRole.role == 't' &&
                                                      value[index].note != null)
                                                  ? CustomText(
                                                      text: value[index].note ??
                                                          '',
                                                      color: appColor.mainColor
                                                          // ignore: deprecated_member_use
                                                          .withOpacity(0.8),
                                                      fontSize: fixSize(
                                                          0.0145, context),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            value[index].status == 3
                                                ? CustomText(
                                                    text: getCall
                                                            .data[index].date ??
                                                        '',
                                                    color: appColor.grey,
                                                    fontSize: fixSizes * 0.0135,
                                                  )
                                                : Container(
                                                    width: size.width * 0.15,
                                                    height: fixSize(
                                                        0.0195, context),
                                                    decoration: BoxDecoration(
                                                      color: appColor.mainColor,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(fixSize(
                                                                      0.004,
                                                                      context))),
                                                    ),
                                                    child: Center(
                                                      child: CustomText(
                                                        text: '${index + 1}',
                                                        color: appColor.white,
                                                        fontSize:
                                                            fixSizes * 0.0145,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        floatingActionButton: GetBuilder<AppVerification>(builder: (getRole) {
          if (getRole.role == 'p') {
            return InkWell(
              onTap: () {
                callStudentState.clearcallStudent();
                Get.to(() => CallChildrenPage(), transition: Transition.zoom);
              },
              child: Container(
                width: fixSizes * 0.065,
                height: fixSizes * 0.065,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: appColor.mainColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: fixSizes * 0.01,
                      )
                    ]),
                child: Icon(
                  Icons.add,
                  color: appColor.white,
                  size: fixSizes * 0.025,
                ),
              ),
            );
          }
          return const SizedBox();
        }));
  }
}
