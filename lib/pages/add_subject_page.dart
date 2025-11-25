import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/states/get_dropdown_state.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  GetDropdownState dropdownState = Get.put(GetDropdownState());

  @override
    void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Add Subject'),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.01),
        child: Column(
          children: [
            // CustomDropDownWidget<SubjectModels>(
            //   fixSize: fSize,
            //   appColor: appColor,
            //   borderRaduis: 5.0,
            //   value: state.updateSubject,
            //   dropdownData: state.allsubjects,
            //   hint: 'select_subject'.tr,
            //   listMenuItems: state.allsubjects.map((SubjectModels items) {
            //     return DropdownMenuItem<SubjectModels>(
            //       value: items,
            //       child: CustomText(
            //         text: items.name ?? '',
            //         fontSize: fSize * 0.015,
            //       ),
            //     );
            //   }).toList(),
            //   onChange: (v) async {
            //     state.updateDropDownSubjects(v);
            //     await aboutScoreState.getStudentList(
            //       id: widget.data!.id.toString(),
            //       subjectId: state.updateSubject?.id.toString(),
            //       date: datePickerState.calDate.text,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
