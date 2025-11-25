import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/functions/check_lang.dart';
import 'package:multiple_school_app/models/register_student_mode.dart';
import 'package:multiple_school_app/pages/login_page.dart';
import 'package:multiple_school_app/repositorys/repository.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';

class RegisterStudentSuccess extends StatefulWidget {
  final RegisterStudentModel data;
  const RegisterStudentSuccess({super.key, required this.data});
  @override
  State<RegisterStudentSuccess> createState() => _RegisterStudentSuccessState();
}

class _RegisterStudentSuccessState extends State<RegisterStudentSuccess> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppColor appColor = AppColor();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'register',
          fontSize: fixSize(0.019, context),
        ),
        backgroundColor: appColor.mainColor,
        foregroundColor: appColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => LoginPage(), transition: Transition.fadeIn);
          },
          icon: Icon(
            Icons.arrow_back,
            color: appColor.white,
          ),
        ),
      ),
      backgroundColor: appColor.mainColor,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: appColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomText(
                      text: 'ກະລຸນາລໍຖ້າໂຮງຮຽນອານຸມັດ',
                      fontSize: fixSize(0.015, context),
                      color: appColor.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                    child: Icon(
                  Icons.check_circle_outline,
                  color: appColor.green,
                  size: fixSize(0.1, context),
                )),
                Center(
                  child: CustomText(
                    text: 'success',
                    fontSize: fixSize(0.0135, context),
                    color: appColor.green,
                  ),
                ),
                if (widget.data.profileImage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: Container(
                        width: size.width * 0.4,
                        height: size.width *
                            0.4, // Ensure it's a square for a perfect circle
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: appColor.mainColor),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                '${Repository().nuXtJsUrlApi}${widget.data.profileImage}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                  text: 'nick_name',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: widget.data.nickname ?? ' ',
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
                // Hidden: religion, nationality, language group, ethnicity, special health, living, blood type per request
                CustomText(
                  text: 'parent_data',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: widget.data.parentData ?? '',
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'parent_contact',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: widget.data.parentContact ?? '',
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
