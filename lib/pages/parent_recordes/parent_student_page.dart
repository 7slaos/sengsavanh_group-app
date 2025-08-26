import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/pages/student_records/profile_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/address_state.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/widgets/custom_circle_load.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class ParentStudentPage extends StatefulWidget {
  const ParentStudentPage({super.key});

  @override
  State<ParentStudentPage> createState() => _ParentStudentPageState();
}

class _ParentStudentPageState extends State<ParentStudentPage> {
  HomeState homeState = Get.put(HomeState());
  AddressState addressState = Get.put(AddressState());
  AppColor appColor = AppColor();
  @override
  void initState() {
    homeState.getHomeParentAndStudentList();
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
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'student',
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
          return Expanded(
            child: Center(
              child: CustomText(
                text: 'not_found_data',
                fontSize: fSize * 0.02,
                color: appColor.grey,
              ),
            ),
          );
        }
        return Column(children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
            child: RefreshIndicator(
              color: appColor.mainColor,
              onRefresh: () async {
                homeState.getHomeParentAndStudentList();
              },
              child: ListView.builder(
                  itemCount: getData.data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                        onTap: () {
                          addressState.clearData();
                          Get.to(
                              () => StudentProfilePage(
                                  type: 't', data: getData.data[i]),
                              transition: Transition.fadeIn);
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(fSize * 0.005),
                              child: Container(
                                padding: EdgeInsets.all(8),
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
                                    Container(
                                      width: size.width * 0.25,
                                      height: size.width *
                                          0.25, // Ensure a perfect circle
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3,
                                            color: appColor.mainColor),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Repository().urlApi}${getData.data[i].imageStudent}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                              color: appColor.white),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              '${'label_code'.tr}: ${(getData.data[i].admissionNumber != null && getData.data[i].admissionNumber != '') ? getData.data[i].admissionNumber : 'XXXXXX'}',
                                          color: appColor.mainColor,
                                          fontSize: fixSize(0.0145, context),
                                        ),
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
                                                      fixSize(0.0145, context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomText(
                                          text:
                                              '${'birtdaydate'.tr}: ${getData.data[i].birtdayDate ?? ''}',
                                          fontSize: fixSize(0.0145, context),
                                        ),
                                        CustomText(
                                          text:
                                              '${'class_room'.tr}: ${getData.data[i].className ?? ""}',
                                          fontSize: fixSize(0.0145, context),
                                          // ignore: deprecated_member_use
                                          color:
                                              appColor.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: appColor.mainColor,
                              child: CustomText(
                                text: '${i + 1}',
                                color: appColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ));
                  }),
            ),
          ),
        ]);
      }),
    );
  }
}
