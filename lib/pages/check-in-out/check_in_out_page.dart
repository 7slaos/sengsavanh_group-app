
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pathana_school_app/pages/check-in-out/select_who_go_with.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/camera_scan_state.dart';
import '../../custom/app_color.dart';
import '../../custom/app_size.dart';
import '../../functions/determine_postion.dart';
import '../../states/about_score_state.dart';
import '../../states/checkin-out-student/check_in_out_student_state.dart';
import '../../widgets/button_widget.dart';
import '../camera_scan_page.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class CheckInOutPage extends StatefulWidget {
  const CheckInOutPage({super.key, this.type = '1'});
  final String type;
  @override
  State<CheckInOutPage> createState() => _CheckInOutPageState();
}

class _CheckInOutPageState extends State<CheckInOutPage> with SingleTickerProviderStateMixin{
  AppVerification appVerification = Get.put(AppVerification());
  CameraScanPageState cameraScanPageState = Get.put(CameraScanPageState());
  late AnimationController _controller;
  late Animation<double> _animation;
  late final CheckInOutStudentState controller;
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final aboutScoreState = Get.put(AboutScoreState());
  final searchController = TextEditingController();
  final AppColor appColor = AppColor();
  final Random random = Random();


  // Generate a random color
  Color getRandomColor() {
    return Color.fromARGB(
      255, // Full opacity
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    controller = Get.put(CheckInOutStudentState());
    if(appVerification.role==""){
      appVerification.setInitToken();
    }
    aboutScoreState.getAllMyClasses();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // fade duration
    )..repeat(reverse: true); // 🔁 repeat animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }
  getCurrentPosition () async{
    Position pos = await DeterminePosition().determinePosition();
    cameraScanPageState.updateLatLng(pos.latitude.toString(), pos.longitude.toString());
    print("Latitude: ${pos.latitude}, Longitude: ${pos.longitude}");
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set your desired range
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      if (type == 'start') {
        startDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      } else {
        endDate.text =
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      }
    }
  }

  void searchBottomDialog() {
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
                      fontSize: fixSize(0.016, context),
                    ),
                    TextField(
                      controller: startDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'd/m/Y',
                        hintStyle: TextStyle(
                          color: appColor.grey,
                          fontSize: fixSize(0.016, context),
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () {
                              _selectDate(context, 'start');
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
                      fontSize: fixSize(0.016, context),
                    ),
                    TextField(
                      controller: endDate,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'd/m/Y',
                        hintStyle: TextStyle(
                          color: appColor.grey,
                          fontSize: fixSize(0.016, context),
                        ),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () {
                              _selectDate(context, 'end');
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
                        height: size.height * 0.06,
                        borderRadius: 10,
                        backgroundColor: appColor.mainColor,
                        onPressed: () async {
                          if (startDate.text != '' && endDate.text != '') {
                            String start = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(startDate.text));
                            String end = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(endDate.text));
                            controller.applyDateFilter(start, end);
                          }
                          Get.back();
                        },
                        fontSize: fixSize(0.016, context),
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
      },
    );
  }

  void searchWhoGoWith(StudentCheckInOut item, int index) {
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
        return Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              height: size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'student', fontWeight: FontWeight.bold, fontSize: fixSize(0.017, context),),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius:
                        BorderRadius.circular(fixSize(0.01, context)),
                        boxShadow: [
                          BoxShadow(
                            color: appColor.grey.withOpacity(0.2),
                            blurRadius: fixSize(0.005, context),
                            spreadRadius: fixSize(0.002, context),
                            offset: Offset(0, fixSize(0.002, context)),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getRandomColor().withOpacity(0.9),
                          child: CustomText(
                            text: '${index}',
                            fontWeight: FontWeight.bold,
                            color: appColor.white,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '${item.firstname} ${item.lastname}',
                              fontSize: fixSize(0.015, context),
                              fontWeight: FontWeight.w500,
                            ),
                            if (item.nickname != null)
                              CustomText(
                                text: '(${item.nickname})',
                                fontSize: fixSize(0.014, context),
                                color: appColor.mainColor,
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                              '${'class_room'.tr}: ${item.myClass ?? 'N/A'}',
                              fontSize: fixSize(0.014, context),
                            ),
                            SizedBox(height: fixSize(0.005, context)),
                            CustomText(
                              text:
                              '${'check_in'.tr}: ${item.checkinDate ?? ''}',
                              color: appColor.mainColor,
                              fontSize: fixSize(0.014, context),
                            ),
                            if (item.checkoutDate != null) ...[
                              SizedBox(height: fixSize(0.005, context)),
                              CustomText(
                                text:
                                '${'check_out'.tr}: ${item.checkoutDate ?? ''}',
                                color: appColor.green,
                                fontSize: fixSize(0.014, context),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomText(text: 'who_go_with', fontWeight: FontWeight.bold, fontSize: fixSize(0.017, context),),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: controller.searchStudents,
                      onTap: (){
                        Get.to(()=> SelectWhoGoWith(branchId: ''), transition: Transition.fadeIn);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        labelText: "${'firstname'.tr} ${'or'.tr} ${'car_number'.tr}",
                        hintStyle: TextStyle(fontSize: fixSize(0.015, context)),
                        labelStyle: TextStyle(fontSize: fixSize(0.015, context)),
                        fillColor: appColor.white.withOpacity(0.98),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: appColor.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: appColor.mainColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: appColor.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: appColor.white,
                        borderRadius:
                        BorderRadius.circular(fixSize(0.01, context)),
                        boxShadow: [
                          BoxShadow(
                            color: appColor.grey.withOpacity(0.2),
                            blurRadius: fixSize(0.005, context),
                            spreadRadius: fixSize(0.002, context),
                            offset: Offset(0, fixSize(0.002, context)),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getRandomColor().withOpacity(0.9),
                          child: CustomText(
                            text: '${index}',
                            fontWeight: FontWeight.bold,
                            color: appColor.white,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '${item.firstname} ${item.lastname}',
                              fontSize: fixSize(0.015, context),
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: item.phone ?? '',
                              fontSize: fixSize(0.015, context),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        subtitle: CustomText(
                          text:
                          '${'car_number'.tr}: ${item.checkinDate ?? ''}',
                          color: appColor.mainColor,
                          fontSize: fixSize(0.014, context),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    ButtonWidget(
                        height: size.height * 0.06,
                        borderRadius: 10,
                        backgroundColor: appColor.mainColor,
                        onPressed: () async {
                          if (startDate.text != '' && endDate.text != '') {
                            String start = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(startDate.text));
                            String end = DateFormat("yyyy-MM-dd").format(
                                DateFormat("dd/MM/yyyy").parse(endDate.text));
                            controller.applyDateFilter(start, end);
                          }
                          Get.back();
                        },
                        fontSize: fixSize(0.016, context),
                        text: 'confirm'),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: AppBar(
        title: CustomText(
          text: widget.type == '1' ? 'scan-in-out' : 'request_go_home',
          color: appColor.white,
          fontSize: fixSize(0.02, context),
        ),
        centerTitle: true,
        backgroundColor: appColor.mainColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: appColor.white,
            size: fixSize(0.02, context),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.date_range, color: appColor.white),
              onPressed: () {
                setState(() {
                  startDate.text = '';
                  endDate.text = '';
                });
                searchBottomDialog();
              }),
          IconButton(
            icon: Icon(Icons.refresh, color: appColor.white),
            onPressed: () {
              setState(() {
                startDate.text = '';
                endDate.text = '';
              });
              controller.clearFilters();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      controller.setIndex(0);
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        width: size.width / 2,
                        decoration: BoxDecoration(
                            border: controller.index.value == 0
                                ? Border(
                                    bottom: BorderSide(
                                        width: 2, color: appColor.mainColor))
                                : null),
                        child: CustomText(
                          text: 'check_in',
                          fontSize: fixSize(0.015, context),
                          fontWeight: FontWeight.bold,
                          color: controller.index.value == 0
                              ? appColor.mainColor
                              : appColor.grey,
                        )),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      controller.setIndex(1);
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: controller.index.value == 1
                                ? Border(
                                    bottom: BorderSide(
                                        width: 2, color: appColor.mainColor))
                                : null),
                        child: CustomText(
                          text: 'check_out',
                          fontSize: fixSize(0.015, context),
                          fontWeight: FontWeight.bold,
                          color: controller.index.value == 1
                              ? appColor.mainColor
                              : appColor.grey,
                        )),
                  ),
                )
              ],
            );
          }),
          // Search Bar
          Padding(
            padding: EdgeInsets.all(fixSize(0.01, context)),
            child: TextField(
              controller: searchController,
              onChanged: controller.searchStudents,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                labelText: 'search'.tr,
                hintStyle: TextStyle(fontSize: fixSize(0.015, context)),
                labelStyle: TextStyle(fontSize: fixSize(0.015, context)),
                fillColor: appColor.white.withOpacity(0.98),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: appColor.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: appColor.mainColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: appColor.grey),
                ),
              ),
            ),
          ),

          // Class Filter Chips
          GetBuilder<AppVerification>(
            builder: (appVer) {
              if(appVer.role == 's'){
                return const SizedBox();
              }
              return GetBuilder<AboutScoreState>(
                builder: (aboutScore) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: appColor.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: aboutScore.allCLasseList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => controller.filterByClass(null),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: fixSize(0.016, context)),
                              alignment: Alignment.center,
                              child: Obx(() => CustomText(
                                    text: 'all'.tr,
                                    fontSize: fixSize(0.015, context),
                                    color: controller.selectedClassId.value == null
                                        ? appColor.mainColor
                                        : appColor.black,
                                    fontWeight:
                                        controller.selectedClassId.value == null
                                            ? FontWeight.bold
                                            : null,
                                  )),
                            ),
                          );
                        }

                        final classes = aboutScore.allCLasseList[index - 1];
                        return GestureDetector(
                          onTap: () => controller.filterByClass(classes.id),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: fixSize(0.016, context)),
                            alignment: Alignment.center,
                            child: Obx(() => CustomText(
                                  text: classes.name ?? '',
                                  fontSize: fixSize(0.015, context),
                                  color:
                                      controller.selectedClassId.value == classes.id
                                          ? appColor.mainColor
                                          : appColor.black,
                                  fontWeight:
                                      controller.selectedClassId.value == classes.id
                                          ? FontWeight.bold
                                          : null,
                                )),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          ),

          // Main Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: controller.errorMessage.value),
                      SizedBox(height: fixSize(0.02, context)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.mainColor,
                        ),
                        onPressed: controller.refreshData,
                        child: CustomText(
                          text: 'Refresh'.tr,
                          color: appColor.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.dataList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: fixSize(0.05, context), color: appColor.grey),
                      SizedBox(height: fixSize(0.02, context)),
                      CustomText(
                        text: 'not_found_data'.tr,
                        fontSize: fixSize(0.016, context),
                        color: appColor.grey,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.separated(
                  controller: controller.scrollController,
                  itemCount: controller.dataList.length +
                      (controller.isMoreLoading.value ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: fixSize(0.005, context)),
                  itemBuilder: (context, index) {
                    if (index >= controller.dataList.length) {
                      return Padding(
                        padding: EdgeInsets.all(fixSize(0.02, context)),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = controller.dataList[index];
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: (){
                        if(item.returnHome == 1) {
                          searchWhoGoWith(item, index +1);
                        }
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: fixSize(0.01, context),
                                vertical: fixSize(0.005, context)),
                            decoration: BoxDecoration(
                              color: appColor.white,
                              borderRadius:
                                  BorderRadius.circular(fixSize(0.01, context)),
                              boxShadow: [
                                BoxShadow(
                                  color: appColor.grey.withOpacity(0.2),
                                  blurRadius: fixSize(0.005, context),
                                  spreadRadius: fixSize(0.002, context),
                                  offset: Offset(0, fixSize(0.002, context)),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getRandomColor().withOpacity(0.9),
                                child: CustomText(
                                  text: '${index + 1}',
                                  fontWeight: FontWeight.bold,
                                  color: appColor.white,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: '${item.firstname} ${item.lastname}',
                                    fontSize: fixSize(0.015, context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  if (item.nickname != null)
                                    CustomText(
                                      text: '(${item.nickname})',
                                      fontSize: fixSize(0.014, context),
                                      color: appColor.mainColor,
                                    ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        '${'class_room'.tr}: ${item.myClass ?? 'N/A'}',
                                    fontSize: fixSize(0.014, context),
                                  ),
                                  SizedBox(height: fixSize(0.005, context)),
                                  CustomText(
                                    text:
                                        '${'time_in'.tr}: ${item.checkinDate ?? ''}',
                                    color: appColor.mainColor,
                                    fontSize: fixSize(0.014, context),
                                  ),
                                  if (item.checkoutDate != null) ...[
                                    SizedBox(height: fixSize(0.005, context)),
                                    CustomText(
                                      text:
                                          '${'time_out'.tr}: ${item.checkoutDate ?? ''}',
                                      color: appColor.green,
                                      fontSize: fixSize(0.014, context),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if(item.returnHome == 1 && item.status == 1)
                          Padding(
                            padding: const EdgeInsets.only(right: 20,top: 10),
                            child: FadeTransition(
                              opacity: _animation,
                              child: CustomText(text: 'ຂໍກັບບ້ານ',color: appColor.red,fontSize: fixSize(0.0135, context)),
                            )
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: widget.type == '1' ? FloatingActionButton(
        backgroundColor: appColor.mainColor,
        onPressed: () =>
            Get.to(() => CameraScanPage(), transition: Transition.fadeIn),
        child: Icon(Icons.qr_code_scanner, color: appColor.white),
      ) :  FloatingActionButton(
        backgroundColor: appColor.mainColor,
        onPressed: (){
          showRequestGoHome('student');
        },
        child: Icon(Icons.notifications_active, color: appColor.white),
      ),
    );
  }
  void showRequestGoHome (String type) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'request_go_home'.tr,
      desc: 'do_you_want_to_confirm'.tr,
      dismissOnTouchOutside: false,
      btnOkText: 'ok'.tr,
      btnCancelText: 'cancel'.tr,
      dismissOnBackKeyPress: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
          controller.confirmRequestGoHome(type: type);
      },
    ).show();
  }
}

