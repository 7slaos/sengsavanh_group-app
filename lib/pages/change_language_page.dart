import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/widgets/custom_app_bar.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  LocaleState localeState = Get.put(LocaleState());
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    AppColor appColor = AppColor();
    return Scaffold(
      backgroundColor: appColor.white,
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () => {Get.back()},
          icon: Icon(
            Icons.arrow_back,
            color: appColor.white,
            size: fSize * 0.02,
          ),
        ),
        orientation: orientation,
        height: size.height,
        color: appColor.white,
        centerTitle: true,
        title: "change_language",
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Get.locale = const Locale('la', 'LA');
              localeState.update();
              Get.back();
            },
            title: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  height: size.width *
                      0.15, // Set the height equal to the width for a perfect circle
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_lao.png"),
                      fit: BoxFit
                          .cover, // Ensures the image fits within the circle
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                CustomText(
                  text: 'lao',
                  fontSize: fSize * 0.0165,
                )
              ],
            ),
            trailing: Get.locale == const Locale('la', 'LA')
                ? Icon(
                    Icons.radio_button_checked,
                    color: appColor.green,
                    size: fSize * 0.02,
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: appColor.grey,
                    size: fSize * 0.02,
                  ),
          ),
          ListTile(
            onTap: () {
              Get.locale = const Locale('en', 'US');
              localeState.update();
              Get.back();
            },
            title: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  height: size.width *
                      0.15, // Set the height equal to the width for a perfect circle
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_en.png"),
                      fit: BoxFit
                          .cover, // Ensures the image fits within the circle
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                CustomText(
                  text: 'english',
                  fontSize: fSize * 0.0165,
                )
              ],
            ),
            trailing: Get.locale == const Locale('en', 'US')
                ? Icon(
                    Icons.radio_button_checked,
                    color: appColor.green,
                    size: fSize * 0.02,
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: appColor.grey,
                    size: fSize * 0.02,
                  ),
          ),
          ListTile(
            onTap: () {
              Get.locale = const Locale('la', 'CN');
              localeState.update();
              Get.back();
            },
            title: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  height: size.width *
                      0.15, // Set the height equal to the width for a perfect circle
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_cn.png"),
                      fit: BoxFit
                          .cover, // Ensures the image fits within the circle
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                CustomText(
                  text: 'cn',
                  fontSize: fSize * 0.0165,
                )
              ],
            ),
            trailing: Get.locale == const Locale('la', 'CN')
                ? Icon(Icons.radio_button_checked,
                    size: fSize * 0.02, color: appColor.green)
                : Icon(
                    Icons.radio_button_unchecked,
                    color: appColor.grey,
                    size: fSize * 0.02,
                  ),
          ),
        ],
      ),
    );
  }
}
