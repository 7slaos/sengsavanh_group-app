import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/models/check_student_model.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/states/payment_state.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class CheckStudentSuccess extends StatefulWidget {
  final CheckStudentModel data;
  const CheckStudentSuccess({super.key, required this.data});
  @override
  State<CheckStudentSuccess> createState() => _CheckStudentSuccessState();
}

class _CheckStudentSuccessState extends State<CheckStudentSuccess> {
  PaymentState paymentState = Get.put(PaymentState());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppColor appColor = AppColor();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'success',
          fontSize: fixSize(0.019, context),
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
      ),
      backgroundColor: appColor.mainColor,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: appColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GetBuilder<PaymentState>(builder: (getPay) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.data.profileImage != null ?
                  Center(
                    child: CircleAvatar(
                      radius: fixSize(0.065, context),
                      backgroundImage: 
                          NetworkImage(
                              '${Repository().urlApi}${widget.data.profileImage}',
                            ),
                    ),
                  ) : const SizedBox(),
                  const Divider(),
                  CustomText(
                    text: 'label_code',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.admissionNumber ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'firstname',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.firstname ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'lastname',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.lastname ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'birtdaydate',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.birtdayDate ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'age',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.age ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'phone',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.phone ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'class',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.myClass ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'village',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.village ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'district',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.district ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                  CustomText(
                    text: 'province',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.grey,
                  ),
                  CustomText(
                    text: widget.data.province ?? '',
                    fontSize: fixSize(0.0165, context),
                  ),
                  const Divider(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
