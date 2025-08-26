// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/models/follow_student_detail_model.dart';
import 'package:pathana_school_app/models/select_dropdown_model.dart';
import 'package:pathana_school_app/pages/teacher_recordes/follow_student_detail_page.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/states/dashboard_teacher_state.dart';
import 'package:pathana_school_app/states/follow_student_state.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FollowStudentPage extends StatefulWidget {
  FollowStudentDetailModels? data; // Make it non-nullable

  FollowStudentPage({super.key, this.data});

  @override
  State<FollowStudentPage> createState() => _FollowStudentPageState();
}

class _FollowStudentPageState extends State<FollowStudentPage> {
  AboutScoreState aboutScoreState = Get.put(AboutScoreState());
  FollowStudentState followStudentState = Get.put(FollowStudentState());
  DashboardTeacherState dashboardTeacherState =
      Get.put(DashboardTeacherState());
  final startDateController = TextEditingController();
  final noteController = TextEditingController();
  final scoreController = TextEditingController();
  StudentRecordDropdownModel? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  int? selectedStudentId;

  int mapStatusToNumber(String status) {
    switch (status) {
      case 'ຂາດຕອນເຊົ້າ': // Morning
        return 1;
      case 'ຂາດຕອນແລງ': // Evening
        return 2;
      case 'ຂາດໝົດມື້': // All day
        return 3;
      default:
        return 0; // Default value
    }
  }

  String mapNumberToStatus(int status) {
    switch (status) {
      case 1:
        return 'ຂາດຕອນເຊົ້າ'; // Morning
      case 2:
        return 'ຂາດຕອນແລງ'; // Evening
      case 3:
        return 'ຂາດໝົດມື້'; // All day
      default:
        return ''; // Default empty string
    }
  }

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

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    followStudentState.fetchStudentDropdown(
        id: dashboardTeacherState.data!.id.toString());

    // followStudentState.createFollowStudent(
    //   context: context,
    //   studentId: followStudentState.selectedStudent?.id.toString() ?? '',
    // );

    followStudentState.selectedStatus = null;
    //gdev
    DateTime selectedDate = DateTime.now();
    setState(() {
      startDateController.text =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    });
    if (widget.data != null) {
      setState(() {
        // Find and set the selected student object based on widget data

        final student = followStudentState.allStudentRecords.firstWhere(
          (student) =>
              student.firstname == widget.data?.firstname &&
              student.lastname == widget.data?.lastname,
        );
        if (student.id != null) {
          // print('9999999999999999999999999999');
          // print(followStudentState.allStudentRecords);
          setState(() {
            // textEditingController.text =
            //     '${student.firstname} ${student.lastname}';
            selectedStudentId = student.id;

            // ✅ Set the selected dropdown value to match the student
            selectedValue = followStudentState.allStudentRecords.firstWhere(
              (item) => item.id == student.id,
              // orElse: () => null, // Prevent error if no match is found
            );
          });
        }

        // Convert widget.data?.type (int?) to String using mapNumberToStatus
        String? statusString = widget.data?.type != null
            ? mapNumberToStatus(widget.data!.type!)
            : null;

        // Find the matching status
        followStudentState.selectedStatus = statusString != null
            ? followStudentState.statusList.firstWhere(
                (status) => status == statusString,
                // orElse: () => null,
              )
            : null;

        // Update text controllers
        startDateController.text = widget.data?.dated?.toString() ?? '';
        scoreController.text = widget.data?.score?.toString() ?? '';
        noteController.text = widget.data?.note?.toString() ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: appColor.mainColor,
        title: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: appColor.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, color: appColor.mainColor),
              ),
              CustomText(
                text: 'Track_absences',
                fontWeight: FontWeight.bold,
                color: appColor.mainColor,
                fontSize: fSize * 0.02,
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => const FollowStudentDetailPage(),
                      transition: Transition.leftToRight);
                },
                icon: Icon(Icons.menu, color: appColor.mainColor),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: GetBuilder<FollowStudentState>(
            builder: (getState) {
              final items = followStudentState.allStudentRecords;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'select_student',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: size.height * 0.01),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<StudentRecordDropdownModel>(
                      isExpanded: true,
                      hint: CustomText(
                        text: 'select_student',
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                      items: items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  '${item.firstname} ${item.lastname}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                      value:
                          selectedValue, // ✅ Make sure this is updated in setState
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                          selectedStudentId = value?.id;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                          color: appColor.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: fixSize(0.0025, context),
                              offset: const Offset(0, 1),
                              color: appColor.grey,
                            ),
                          ],
                        ),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: size.height * 0.06,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'ຄົ້ນຫານັກຮຽນ...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return '${item.value!.firstname} ${item.value!.lastname}'
                              .toLowerCase()
                              .contains(searchValue.toLowerCase());
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  const CustomText(
                    text: 'select_type',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: size.height * 0.01),
                  // In your widget:
                  CustomDropDownWidget<String>(
                    fixSize: fSize,
                    appColor: appColor,
                    borderRaduis: 5.0,
                    height: size.height * 0.07,
                    value: followStudentState
                        .selectedStatus, // Bind the selected status
                    dropdownData:
                        followStudentState.statusList, // Use the status list
                    hint: '-- ${'select_type'.tr} --', // Hint text
                    listMenuItems: followStudentState.statusList.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: CustomText(
                          text: status, // Display status as text
                          fontSize: fSize * 0.015,
                        ),
                      );
                    }).toList(),
                    onChange: (selected) {
                      followStudentState
                          .updateStatus(selected!); // Update selected status
                    },
                  ),

                  SizedBox(height: size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const CustomText(
                              text: 'dated',
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                              height: size.height * 0.07,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(8, 169, 169, 169)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: startDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'dd/mm/yyyy',
                                  hintStyle: TextStyle(color: appColor.grey),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.date_range),
                                    onPressed: () => selectDate(context),
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
                            ),
                          ],
                        ),
                      ),
                      // Second column remains unchanged
                      SizedBox(width: size.width * 0.01),
                      Expanded(
                        child: Column(
                          children: [
                            const CustomText(
                              text: 'score_cut_out',
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                              height: size.height * 0.07,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(8, 169, 169, 169)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: scoreController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  filled: true,
                                  fillColor: appColor.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: size.height * 0.02),

                  SizedBox(height: size.height * 0.02),
                  const CustomText(
                    text: 'note',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(8, 169, 169, 169)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(
                              3, 3), // Changes the position of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: noteController,
                      maxLines: 5, // Allows 5 lines of text
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),

                        hintText: '${'note'.tr}...',
                        hintStyle: TextStyle(color: appColor.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal:
                                16), // Padding Adds padding inside the text area
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: size.height * 0.07, // Set the height
                        width: size.width / 2.5, // Set the width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                appColor.blueLight, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(40), // Rounded corners
                            ),
                          ),
                          onPressed: () async {
                            followStudentState.update();
                            followStudentState.clearData();
                            setState(() {
                              selectedStudentId = null;
                              textEditingController.text = '';
                              // startDateController.text = '';
                              scoreController.text = '';
                              noteController.text = '';
                            });
                          },
                          child: CustomText(
                            text: 'cancel',
                            color: appColor.white,
                            fontSize: fixSize(0.0156, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      widget.data != null
                          ? SizedBox(
                              height: size.height * 0.07, // Set the height
                              width: size.width / 2.5, // Set the width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.amber, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40), // Rounded corners
                                  ),
                                ),
                                onPressed: () async {
                                  if (startDateController.text.isEmpty) {
                                    CustomDialogs().showToast(
                                      backgroundColor:
                                          Colors.red.withOpacity(0.5),
                                      text: 'date_is_required'.tr,
                                    );
                                    return;
                                  }

                                  try {
                                    followStudentState.updateListFollowStudent(
                                      id: int.parse(widget.data!.id.toString()),
                                      studentId: selectedStudentId,
                                      typeId: mapStatusToNumber(
                                          followStudentState.selectedStatus!),
                                      date: startDateController.text
                                          .trim(), // Pass the date from the controller
                                      score: scoreController.text.trim(),
                                      note: noteController.text.trim(),
                                    );
                                  } catch (e) {
                                    // print('Error: $e');
                                  }
                                },
                                child: CustomText(
                                  text: 'edit',
                                  color: appColor.white,
                                  fontSize: fixSize(0.0156, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: size.height * 0.07, // Set the height
                              width: size.width / 2.5, // Set the width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      appColor.green, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        40), // Rounded corners
                                  ),
                                ),
                                onPressed: () async {
                                  bool success = await confirm();

                                  if (success) {
                                    // // Refresh the data
                                    // await followStudentState
                                    //     .getListStudents(); // Call your function to refresh data
                                    // Reset form fields
                                    followStudentState.update();
                                    selectedStudentId = null;
                                    followStudentState.selectedStatus = null;
                                    startDateController.text = '';
                                    scoreController.text = '';
                                    noteController.text = '';
                                  }
                                },
                                child: CustomText(
                                  text: 'save',
                                  color: appColor.white,
                                  fontSize: fixSize(0.0156, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),

                  // Additional widgets can be added here
                ],
              );
            },
          ),
        ),
      ),
    );
  }

//  add data follow student
  confirm() async {
    if (selectedStudentId == null ||
        followStudentState.selectedStatus == null ||
        followStudentState.selectedStatus!.isEmpty ||
        scoreController.text.trim().isEmpty) {
      CustomDialogs().showToast(
        backgroundColor: Colors.amber.withOpacity(0.5),
        text: 'please_enter_complete_information'.tr,
      );
      return;
    }
    // Map status to numeric value
    int statusNumber = mapStatusToNumber(followStudentState.selectedStatus!);
    // Call API
    followStudentState.createFollowStudent(
      context: context,
      studentId: selectedStudentId.toString(), // Use the selected student ID
      type: statusNumber.toString(),
      date: startDateController.text.trim(),
      score: scoreController.text.trim(),
      note: noteController.text.trim(),
    );
  }
}
