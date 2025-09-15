import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:pathana_school_app/pages/change_language_page.dart';
import 'package:pathana_school_app/pages/select_school.dart';
import 'package:pathana_school_app/states/auth_login_register.dart';
import 'package:pathana_school_app/states/register_state.dart';
import 'package:pathana_school_app/widgets/button_widget.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:pathana_school_app/widgets/text_field_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositorys/repository.dart';
import '../widgets/custom_circle_load.dart';
import '../widgets/custom_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  AppColor appColors = AppColor();
  TextEditingController telephone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;
  bool obscureTextPasseord = true;
  String version = '';
  @override
  void initState() {
    super.initState();
    checkversion();
    getAppVersion();
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String v = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      version = '$v+$buildNumber';
    }); // Build number
  }

  checkversion() async {
    final newVer = NewVersionPlus(
        androidId: "com.pathana.school.app",
        iOSId: "com.pathana.sSchool.App",
        iOSAppStoreCountry: 'LA');
    final status = await newVer.getVersionStatus();
    if (status != null && status.canUpdate) {
      await Get.dialog(Builder(builder: (context) {
        Size size = MediaQuery.of(context).size;
        double fSize = size.width + size.height;
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () => Future.value(true),
          child: AlertDialog(
            backgroundColor: appColors.white,
            title: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(999)),
              child: Image.asset(
                'assets/images/logo.png',
                width: fSize * 0.095,
                height: fSize * 0.095,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: 'new_version_update_available',
                  fontSize: fSize * 0.0185,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text:
                      '${'please_update_this_app_version'.tr} ${status.storeVersion}',
                  fontSize: fSize * 0.0165,
                ),
              ],
            ),
            actions: [
              Center(
                child: InkWell(
                  onTap: () => newVer.launchAppStore(status.appStoreLink,
                      launchMode: LaunchMode.externalApplication),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: fSize * 0.015,
                      vertical: fSize * 0.0075,
                    ),
                    decoration: BoxDecoration(
                        color: appColors.mainColor,
                        borderRadius: BorderRadius.circular(999)),
                    child: CustomText(
                      text: 'update',
                      fontSize: fSize * 0.0165,
                      color: appColors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }), barrierDismissible: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fsize = size.width + size.height;
    return Scaffold(
        backgroundColor: appColors.white,
        body: GetBuilder<LocaleState>(builder: (getLang) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height,
              ),
              child: GetBuilder<RegisterState>(builder: (getS) {
final item = getS.schoolList.firstWhereOrNull((_) => true);
if (item == null) {
  return Center(
    child: ElevatedButton(
      onPressed: () => Get.to(() => const SelectSchool(), transition: Transition.fadeIn),
      child: Text('select_school'.tr),
    ),
  );
}
// use `item` safely here

                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: fsize * 0.02,
                          right: fsize * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "${Repository().urlApi}${item.logo}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/logo.png",
                                width: fsize * 0.18,
                              ),
                            ),
                            CustomText(
                              text: 'welcome',
                              fontSize: fixSize(0.0225, context),
                              // fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: fsize * 0.01,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: fsize * 0.05,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: appColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: fsize * 0.0025,
                                            offset: const Offset(0, 1),
                                            color: appColors.grey)
                                      ]),
                                  child: CustomText(
                                      text: '+856 20',
                                      fontSize: fsize * 0.0165),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFielWidget(
                                    height: fsize * 0.05,
                                    icon: Icons.person,
                                    hintText: 'XXXXXXXX'.tr,
                                    fixSize: fsize,
                                    appColor: appColors,
                                    controller: telephone,
                                    borderRaduis: 5.0,
                                    maxLength: 8,
                                    margin: 0,
                                    fontSize: fsize * 0.0165,
                                    contentPadding: EdgeInsets.only(left: 5),
                                    textInputType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: fsize * 0.025,
                            ),
                            TextFielWidget(
                              width: size.width,
                              height: fsize * 0.05,
                              icon: Icons.lock,
                              hintText: 'password'.tr,
                              fixSize: fsize,
                              appColor: appColors,
                              controller: password,
                              borderRaduis: 5.0,
                              margin: 0,
                              fontSize: fsize * 0.0165,
                              iconPrefix: Icon(
                                Icons.lock,
                                size: fsize * 0.025,
                              ),
                              textInputType: TextInputType.visiblePassword,
                              obscureText: obscureTextPasseord,
                              iconSuffix: IconButton(
                                icon: Icon(
                                  obscureTextPasseord
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (obscureTextPasseord) {
                                      obscureTextPasseord = false;
                                    } else {
                                      obscureTextPasseord = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: fsize * 0.025,
                            ),
                            ButtonWidget(
                                height: fsize * 0.05,
                                width: fsize * 0.5,
                                color: appColors.white,
                                // ignore: deprecated_member_use
                                backgroundColor:
                                    appColors.mainColor.withOpacity(0.8),
                                fontSize: fsize * 0.0185,
                                fontWeight: FontWeight.bold,
                                borderRadius: 5,
                                onPressed: () async {
                                  if (telephone.text.trim().isEmpty ||
                                      password.text.trim().isEmpty) {
                                    CustomDialogs().showToast(
                                        // ignore: deprecated_member_use
                                        backgroundColor:
                                            // ignore: deprecated_member_use
                                            appColors.black.withOpacity(0.6),
                                        text:
                                            'please_enter_complete_information'
                                                .tr);
                                    return;
                                  }

                                  loginRegister.login(
                                    context: context,
                                    phone: '20${telephone.text}',
                                    password: password.text,
                                  );
                                },
                                text: 'login'),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  loginRegister.login(
                                    context: context,
                                    phone: '2077778888',
                                    password: '123456789',
                                  );
                                },
                                child: Text("Continue as Guest",
                                    style: TextStyle(
                                        fontSize: fsize * 0.013,
                                        color: appColors.grey)),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Get.to(() => SelectSchool(),
                                      transition: Transition.fadeIn);
                                },
                                child: CustomText(
                                  text: 'register',
                                  fontSize: fsize * 0.0145,
                                  color: appColors.mainColor,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        }),
        floatingActionButton: GetBuilder<LocaleState>(builder: (lang) {
          return Column(
            children: [
              FloatingActionButton(
                backgroundColor: appColors.white,
                elevation: 4,
                shape: CircleBorder(),
                onPressed: () {
                  Get.to(() => ChangeLanguagePage(),
                      transition: Transition.fadeIn);
                },
                child: Container(
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: Get.locale == const Locale('en', 'US')
                          ? AssetImage("assets/images/logo_en.png")
                          : Get.locale == const Locale('la', 'CN')
                              ? AssetImage("assets/images/logo_cn.png")
                              : AssetImage("assets/images/logo_lao.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CustomText(
                  text: Get.locale == const Locale('en', 'US')
                      ? 'english'
                      : Get.locale == const Locale('la', 'CN')
                          ? 'cn'
                          : 'lao')
            ],
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Version: $version',
                style: TextStyle(color: appColors.grey),
              ),
            ),
          ],
        ));
  }
}
