import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/pages/about_add_score_page.dart';
import 'package:pathana_school_app/states/about_score_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectMyclassePage extends StatefulWidget {
  const SelectMyclassePage({super.key});

  @override
  State<SelectMyclassePage> createState() => _SelectMyclassePageState();
}

class _SelectMyclassePageState extends State<SelectMyclassePage> {
  AboutScoreState scoreState = Get.put(AboutScoreState());
  final indexController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Future.delayed(Duration.zero);
    scoreState.getMyClasses();
  }

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'select_classe',fontSize: fSize * 0.02),
        backgroundColor: AppColor().mainColor,
        centerTitle: true,
        foregroundColor: AppColor().white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(fSize * 0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<AboutScoreState>(
                builder: (getList) {
                  if (getList.checkClasse == false) {
                    return SizedBox(
                        height: size.height * 0.65, child: CircleLoad());
                  } else if (getList.classeList.isEmpty &&
                      getList.checkClasse == true) {
                    return SizedBox(
                      height: size.height * 0.8,
                      child: Center(
                        child: CustomText(
                          text: 'No_information_yet', // Add data
                          fontSize: fixSize(0.0185, context),
                          color: appColor.grey,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await getData();
                    },
                    child: SizedBox(
                      height:
                          size.height * 0.9, // Define a height for the ListView
                      child: ListView.builder(
                        itemCount: getList.classeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              scoreState.clearSubject();
                              Get.to(
                                  () => AboutAddScorePage(
                                        data: getList.classeList[index],
                                      ),
                                  transition: Transition.fadeIn);
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: fSize * 0.005),
                              height: size.height * 0.08,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(fSize * 0.01),
                              ),
                              child: CustomText(
                                text: getList.classeList[index].name.toString(),
                                color: AppColor().mainColor,
                                fontSize: fixSize(0.0161, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
