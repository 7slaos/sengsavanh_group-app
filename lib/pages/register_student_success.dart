import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/functions/check_lang.dart';
import 'package:pathana_school_app/models/register_student_mode.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/repositorys/repository.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

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
                CustomText(
                  text: 'religion',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.religionLa ?? '', nameEn: widget.data.religionEn ?? '', nameCn: widget.data.religionEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'nationality',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.nationalityLa ?? '', nameEn: widget.data.nationalityEn ?? '', nameCn: widget.data.nationalityEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'group_language',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.groupLanguageLa ?? '', nameEn: widget.data.groupLanguageEn ?? '', nameCn: widget.data.groupLanguageEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'ethnicity',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.ethnicityLa ?? '', nameEn: widget.data.ethnicityEn ?? '', nameCn: widget.data.ethnicityEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'special_health',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.specialHealthLa ?? '', nameEn: widget.data.specialHealthEn ?? '', nameCn: widget.data.specialHealthEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'living',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.livingLa ?? '', nameEn: widget.data.livingEn ?? '', nameCn: widget.data.livingEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
                CustomText(
                  text: 'Blood_type',
                  fontSize: fixSize(0.0135, context),
                  color: appColor.grey,
                ),
                CustomText(
                  text: CheckLang(nameLa: widget.data.bloodGroupLa ?? '', nameEn: widget.data.bloodGroupEn ?? '', nameCn: widget.data.bloodGroupEn ?? '').toString(),
                  fontSize: fixSize(0.0165, context),
                ),
                const Divider(),
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
