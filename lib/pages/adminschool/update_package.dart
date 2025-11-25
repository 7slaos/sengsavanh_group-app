import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/pages/adminschool/admin_payment_package.dart';
import 'package:multiple_school_app/states/adminschool/admin_dashboard_state.dart';
import 'package:multiple_school_app/states/adminschool/admin_tuition_fee_state.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class UpdatePackage extends StatefulWidget {
  const UpdatePackage({super.key});
  @override
  State<UpdatePackage> createState() => _UpdatePackageState();
}

class _UpdatePackageState extends State<UpdatePackage> {
  AdminTuitionFeeState adminTuitionFeeState = Get.put(AdminTuitionFeeState());
  final searchT = TextEditingController();
  AppColor appColor = AppColor();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Contract_renewal', color: appColor.mainColor),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: appColor.mainColor,
            )),
        centerTitle: true,
        elevation: 4,
        surfaceTintColor: appColor.white,
      ),
      body: GetBuilder<AdminDashboardState>(builder: (getD) {
        if (getD.adminDashboardModel == null) {
          return const SizedBox();
        }
        return Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.04,
                    width: 4,
                    color: appColor.mainColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    text: 'select_school',
                    fontSize: fixSize(0.0165, context),
                    color: appColor.grey,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: getD.adminDashboardModel!.packages!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          if (getD.adminDashboardModel!.packages![index]
                                  .expiryCount! <
                              0) {
                            Get.to(
                                () => AdminPaymentPackage(
                                      data: getD.adminDashboardModel!,
                                      index: index,
                                    ),
                                transition: Transition.fadeIn);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          color: (getD.adminDashboardModel!.packages![index]
                                      .expiryCount! >
                                  0)
                              ? AppColor().green
                              : (getD.adminDashboardModel!.packages![index]
                                          .expiryCount! ==
                                      0)
                                  ? AppColor().orange
                                  : Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: CheckLang(
                                            nameLa: getD.adminDashboardModel!
                                                    .packages![index].nameLa ??
                                                '',
                                            nameEn: getD.adminDashboardModel!
                                                    .packages![index].nameEn ??
                                                '',
                                            nameCn: getD.adminDashboardModel!
                                                    .packages![index].nameCn ??
                                                '')
                                        .toString(),
                                    fontSize: fixSize(0.0165, context),
                                    color: AppColor().white,
                                  ),
                                  CustomText(
                                    text:
                                        '${"start_date".tr}: ${getD.adminDashboardModel!.packages![index].startDate ?? ''} - ${getD.adminDashboardModel!.packages![index].endDate ?? ''} (${getD.adminDashboardModel!.packages![index].expiryCount! >= 0 ? 'ຍັງເຫຼືອ: ${getD.adminDashboardModel!.packages![index].expiryCount}' : 'ກາຍສັນຍາ: ${getD.adminDashboardModel!.packages![index].expiryCount}'} ວັນ)',
                                    fontSize: fixSize(0.0115, context),
                                    color: AppColor().white,
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: appColor.white,
                                size: fixSize(0.0125, context),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }
}
