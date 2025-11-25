import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/states/call_student_state.dart';
import 'package:multiple_school_app/states/home_state.dart';
import 'package:multiple_school_app/widgets/button_widget.dart';
import 'package:multiple_school_app/widgets/custom_circle_load.dart';
import 'package:multiple_school_app/widgets/custom_dialog.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class CallChildrenPage extends StatefulWidget {
  const CallChildrenPage({super.key});

  @override
  State<CallChildrenPage> createState() => _CallChildrenPageState();
}

class _CallChildrenPageState extends State<CallChildrenPage> {
  HomeState homeState = Get.put(HomeState());
  CallStudentState callStudentState = Get.put(CallStudentState());
  AppColor appColor = AppColor();
  final note = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (homeState.data.isNotEmpty) {
      callStudentState.isChecked =
          List.generate(homeState.data.length, (index) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'notification',
          fontSize: fixSize(0.019, context),
          // color: appColor.white,
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      body: GetBuilder<HomeState>(builder: (getData) {
        if (getData.check == false) {
          return CircleLoad();
        }
        if (getData.data.isEmpty) {
          return Center(
            child: CustomText(
              text: 'not_found_data',
              fontSize: fSize * 0.02,
              color: appColor.grey,
            ),
          );
        }

        if (callStudentState.isChecked.length != getData.data.length) {
          callStudentState.isChecked =
              List.generate(getData.data.length, (index) => false);
          callStudentState.update();
        }

        return Column(children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.all(fSize * 0.005),
            child: TextField(
              controller: note,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: appColor.mainColor)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'note'.tr,
              ),
            ),
          ),
          CustomText(
            text: 'Select_child_adopt',
            fontSize: fixSize(0.01850, context),
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: getData.data.length,
                itemBuilder: (context, i) {
                  return InkWell(
                      onTap: () {},
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(fSize * 0.005),
                            child: Container(
                              padding: EdgeInsets.all(fSize * 0.01),
                              decoration: BoxDecoration(
                                color: appColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: fixSize(0.0025, context),
                                    offset: const Offset(0, 1),
                                    color: appColor.grey,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(fSize * 0.01),
                              ),
                              child: Row(
                                children: [
                                  // Profile Image
                                  Container(
                                    width: size.width * 0.2,
                                    height: size.width * 0.2,
                                    decoration: BoxDecoration( 
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          getData.data[i].imageStudent != null
                                              ? "${getData.rep.nuXtJsUrlApi}${getData.data[i].imageStudent}"
                                              : 'https://static.vecteezy.com/system/resources/previews/025/003/261/non_2x/cute-cartoon-boy-student-character-on-transparent-background-generative-ai-png.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: fSize * 0.01),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.65,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: CustomText(
                                                text:
                                                    '${getData.data[i].firstname ?? ''} ${getData.data[i].lastname ?? ''}',
                                                color: appColor.mainColor,
                                                fontSize:
                                                    fixSize(0.0165, context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomText(
                                        text:
                                            '${'class_room'.tr}: ${getData.data[i].className?? ''}',
                                        fontSize: fixSize(0.0145, context),
                                        color: appColor.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GetBuilder<CallStudentState>(builder: (callState) {
                            return Checkbox(
                              value: callStudentState.isChecked[i],
                              activeColor: appColor.green,
                              onChanged: (bool? newValue) {
                                callStudentState.removeIndex(
                                    i,
                                    int.parse(getData.data[i].stId.toString()),
                                    newValue!);
                              },
                            );
                          })
                        ],
                      ));
                }),
          ),
        ]);
      }),
      bottomSheet: GetBuilder<CallStudentState>(builder: (getCall) {
        return ButtonWidget(
            height: size.height * 0.08,
            backgroundColor: getCall.callstudentList.isEmpty
                ? appColor.grey
                : appColor.mainColor,
            onPressed: () async {
              if (callStudentState.callstudentList.isNotEmpty) {
                callStudentState.confirmcallStudent(
                    context: context, note: note.text);
              } else {
                CustomDialogs().showMessage(text: 'ກະລຸນາເລືອກລູກກ່ອນ!');
              }
            },
            fontSize: fixSize(0.0165, context),
            text: 'call_children');
      }),
    );
  }
}
