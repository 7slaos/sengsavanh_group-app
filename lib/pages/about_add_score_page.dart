// ignore_for_file: deprecated_member_use

import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/models/my_classe_model.dart';
import 'package:pathana_school_app/models/subject_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/states/date_picker_state.dart';
import 'package:pathana_school_app/widgets/button_icon_widget.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_dialog.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AboutAddScorePage extends StatefulWidget {
  AboutAddScorePage({super.key, required this.data});
  MyClasseModels? data;

  @override
  State<AboutAddScorePage> createState() => _AboutAddScorePageState();
}

class _AboutAddScorePageState extends State<AboutAddScorePage> {
  AboutScoreState aboutScoreState = Get.put(AboutScoreState());
  final qtyScoreController = TextEditingController();
  DatePickerState datePickerState = Get.put(DatePickerState());
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    Future.delayed(Duration.zero);
    aboutScoreState.getSubjectDropdown(id: widget.data!.id.toString());
    aboutScoreState.getStudentList(
      id: widget.data!.id.toString(),
      // subjectId: aboutScoreState.updateSubject?.id.toString(),
    );
    aboutScoreState.selectSubject();
    datePickerState.setCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: widget.data!.name.toString(), fontSize: fSize * 0.02),
        backgroundColor: AppColor().mainColor,
        centerTitle: true,
        foregroundColor: AppColor().white,

      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.01),
        child: GetBuilder<DatePickerState>(
          builder: (getDate) {
            return GetBuilder<AboutScoreState>(
              builder: (state) {
                // Loading State
                if (state.checkStudenScore == false) {
                  return Center(
                    child: CircleLoad(), // Show a loading indicator
                  );
                } else if (state.studentScoreList.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'please_add_information',
                      fontSize: fSize * 0.02,
                      color: appColor.mainColor,
                    ),
                  );
                }

                // Data Loaded State
                return Column(
                  children: [
                    TextField(
                      onTap: () async {
                        await datePickerState.selectDATE(context: context);
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (context) =>
                        //       const Center(child: CircularProgressIndicator()),
                        // );
                        await aboutScoreState.getStudentList(
                          id: widget.data!.id.toString(),
                          subjectId:
                              aboutScoreState.updateSubject?.id.toString(),
                          date: datePickerState.calDate.text,
                        );
                        // Get.back();
                      },
                      controller: datePickerState.date,
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: fSize * 0.01,
                          horizontal: fSize * 0.01,
                        ),
                        hintText: 'dd/mm/YYYY',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: appColor.grey),
                          borderRadius: BorderRadius.circular(fSize * 0.01),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: appColor.mainColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: appColor.mainColor),
                          borderRadius: BorderRadius.circular(fSize * 0.005),
                        ),
                      ),
                    ),
                    SizedBox(height: fSize * 0.005),
                    CustomDropDownWidget<SubjectModels>(
                      fixSize: fSize,
                      appColor: appColor,
                      borderRaduis: 5.0,
                      value: state.updateSubject,
                      dropdownData: state.allsubjects,
                      hint: 'select_subject'.tr,
                      listMenuItems:
                          state.allsubjects.map((SubjectModels items) {
                        return DropdownMenuItem<SubjectModels>(
                          value: items,
                          child: CustomText(
                            text: items.name ?? '',
                            fontSize: fSize * 0.015,
                          ),
                        );
                      }).toList(),
                      onChange: (v) async {
                        aboutScoreState.updateDropDownSubjects(v);
                        await aboutScoreState.getStudentList(
                          id: widget.data!.id.toString(),
                          subjectId: state.updateSubject?.id.toString(),
                          date: datePickerState.calDate.text,
                        );
                      },
                    ),
                    SizedBox(height: fSize * 0.01),
                    Padding(
                      padding: EdgeInsets.only(
                          left: fSize * 0.02, right: fSize * 0.025),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'student',
                            fontSize: fixSize(0.0130, context),
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: 'score',
                            fontSize: fixSize(0.0130, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: size.height * 0.01),
                    const Divider(),
                    Expanded(
                      child: state.studentScoreList.isEmpty
                          ? Center(
                              child: CustomText(
                                text: 'add_information', // Add data
                                fontSize: fixSize(0.0160, context),
                                color: appColor.grey,
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.studentScoreList.length,
                              itemBuilder: (context, index) {
                                final student = state.studentScoreList[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: student.profileImage !=
                                            null
                                        ? NetworkImage(
                                            '${Repository().urlApi}${student.profileImage}')
                                        : const AssetImage(
                                                'assets/images/istockphoto-587805078-612x612.jpg')
                                            as ImageProvider,
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Ensure the text widget uses TextOverflow.ellipsis
                                      Expanded(
                                        child: CustomText(
                                          text:
                                              '${student.firstname ?? ''} ${student.lastname ?? ''}',
                                          // textOverflow: TextOverflow
                                          //     .ellipsis, // Adds ellipsis to overflow
                                          // maxLines:
                                          //     1, // Restricts text to a single line
                                          fontSize: fixSize(0.0140, context),
                                        ),
                                      ),
                                      SizedBox(
                                          width: size.width *
                                              0.02), // Add spacing between text and TextField
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: TextField(
                                          controller: aboutScoreState
                                              .qtyControllers[index],
                                          keyboardType: TextInputType
                                              .number, // Allows only numeric input
                                          textInputAction: TextInputAction
                                              .done, // Action button (e.g., Done)
                                          decoration: InputDecoration(
                                            hintText: '0',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      fSize * 0.01),
                                            ),
                                          ),

                                          onChanged: (value) {
                                            // Update the qty value for the respective student in the studentQtyData list
                                            aboutScoreState
                                                        .studentQtyData[index]
                                                    ['qty'] =
                                                value; // Save the updated qty
                                            // Update the UI
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          ButtonIconWidget(
            height: size.height * 0.08,
            width: size.width,
            color: appColor.white.withOpacity(0.95),
            backgroundColor: appColor.mainColor.withOpacity(0.8),
            fontSize: fixSize(0.0185, context),
            fontWeight: FontWeight.bold,
            borderRadius: fSize * 0.002,
            onPressed: () async {
              await saveDataScore();
            },
            icon: Icons.check,
            text: 'save',
          ),
        ],
      ),
    );
  }

  saveDataScore() async {
    if (aboutScoreState.updateSubject == null) {
      CustomDialogs().showToast(
        backgroundColor: AppColor().black.withOpacity(0.8),
        text: 'please_select_subject_first'.tr,
      );
      return;
    }
    await aboutScoreState.saveScoreStudent(
        context: context,
        subjectId: aboutScoreState.updateSubject?.id.toString() ?? '',
        date: datePickerState.date.text,
        myClassId: widget.data!.id.toString());
  }
}
