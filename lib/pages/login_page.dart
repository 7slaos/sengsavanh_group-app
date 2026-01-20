import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/pages/change_language_page.dart';
import 'package:multiple_school_app/pages/select_school.dart';
import 'package:multiple_school_app/states/appverification.dart';
import 'package:multiple_school_app/states/auth_login_register.dart';
import 'package:multiple_school_app/states/register_state.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositorys/repository.dart';
import '../widgets/custom_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthLoginRegister loginRegister = Get.put(AuthLoginRegister());
  AppVerification appVerification = Get.put(AppVerification());
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

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String v = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      version = '$v+$buildNumber';
    }); // Build number
  }

  Future<void> checkversion() async {
    final newVer = NewVersionPlus(
        androidId: "com.sschoolapp.s_school_app",
        iOSId: "com.sschoolapp.sSchoolApp",
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
                Text(
                  'new_version_update_available'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fSize * 0.0185,
                    fontWeight: FontWeight.w600,
                    color: appColors.black,
                  ),
                ),
                SizedBox(height: fSize * 0.01),
                Text(
                  '${'please_update_this_app_version'.tr} ${status.storeVersion}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fSize * 0.0165,
                    color: appColors.grey,
                  ),
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
                    child: Text(
                      'update'.tr,
                      style: TextStyle(
                        fontSize: fSize * 0.0165,
                        color: appColors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  double _fieldFontSize(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return ((s.width + s.height) * 0.0165).clamp(16.0, 20.0);
  }

  InputDecoration _fieldDecoration({
    required BuildContext context,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    final size = MediaQuery.of(context).size;
    final fieldRadius = BorderRadius.circular(16);
    final baseTheme = Theme.of(context);
    final borderColor = baseTheme.colorScheme.outlineVariant.withOpacity(0.8);
    final fontSize = _fieldFontSize(context);

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: baseTheme.colorScheme.onSurfaceVariant,
        fontSize: fontSize,
      ),
      prefixIcon: Icon(icon),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      prefixStyle: TextStyle(
        color: baseTheme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.018,
      ),
      border: OutlineInputBorder(
        borderRadius: fieldRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: fieldRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: fieldRadius,
        borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: 1.6),
      ),
    );
  }

  Widget _gradientButton({
    required BuildContext context,
    required VoidCallback onTap,
    required String text,
    IconData? leadingIcon,
  }) {
    final size = MediaQuery.of(context).size;
    final height = (size.height * 0.062).clamp(48.0, 58.0);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
                theme.colorScheme.primary,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.22),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  leadingIcon ?? Icons.login_rounded,
                  color: Colors.white,
                  size: (size.width + size.height) * 0.020,
                ),
                SizedBox(width: size.width * 0.02),
                Text(
                  text.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: (size.width + size.height) * 0.0175,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const brandBlue = Color(0xFF0D47A1);
    const accentBlue = Color(0xFF42A5F5);
    const softBlue = Color(0xFF90CAF9);
    final baseTheme = Theme.of(context);
    final colorScheme = const ColorScheme.light(
      primary: brandBlue,
      secondary: accentBlue,
      tertiary: softBlue,
      surface: Colors.white,
    );
    final theme = ThemeData.from(colorScheme: colorScheme, useMaterial3: true).copyWith(
      textTheme: baseTheme.textTheme,
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );

    final horizontalPadding = size.width * 0.075;
    final topSpacing = (size.height * 0.08).clamp(24.0, 70.0);

    return Theme(
      data: theme,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<LocaleState>(builder: (getLang) {
            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          accentBlue.withOpacity(0.18),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.28, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -size.width * 0.22,
                  right: -size.width * 0.28,
                  child: Container(
                    width: size.width * 0.72,
                    height: size.width * 0.72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          brandBlue.withOpacity(0.22),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -size.width * 0.30,
                  left: -size.width * 0.25,
                  child: Container(
                    width: size.width * 0.85,
                    height: size.width * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          softBlue.withOpacity(0.22),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: size.height),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: topSpacing,
                          ),
                          child: GetBuilder<RegisterState>(builder: (getS) {
                            final item =
                                getS.schoolList.isNotEmpty ? getS.schoolList.first : null;
                            final logoUrl = (item != null &&
                                    item.logo != null &&
                                    item.logo!.isNotEmpty)
                                ? "${Repository().nuXtJsUrlApi}${item.logo}"
                                : null;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.75),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 24,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: logoUrl == null
                                              ? Image.asset(
                                                  "assets/images/logo.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  logoUrl,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 26,
                                                        height: 26,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: theme.colorScheme.primary,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (context, error, stackTrace) {
                                                    return Image.asset(
                                                      "assets/images/logo.png",
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.018),
                                      Text(
                                        'SV Schools',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: theme.colorScheme.onSurface,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.006),
                                      Text(
                                        'ຍິນດີຕ້ອນຮັບ',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.035),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                    child: Container(
                                      padding: EdgeInsets.all(size.width * 0.055),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.70),
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.55),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 28,
                                            offset: const Offset(0, 14),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          TextField(
                                            controller: telephone,
                                            maxLength: 8,
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                              fontSize: _fieldFontSize(context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: _fieldDecoration(
                                              context: context,
                                              hintText: 'ໃສ່ເບີໂທ 8 ໂຕເລກ',
                                              icon: Icons.phone_rounded,
                                              prefixText: '20 ',
                                            ).copyWith(counterText: ''),
                                          ),
                                          SizedBox(height: size.height * 0.018),
                                          TextField(
                                            controller: password,
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: obscureTextPasseord,
                                            textInputAction: TextInputAction.done,
                                            style: TextStyle(
                                              fontSize: _fieldFontSize(context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: _fieldDecoration(
                                              context: context,
                                              hintText: 'password'.tr,
                                              icon: Icons.lock_rounded,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (obscureTextPasseord) {
                                                      obscureTextPasseord = false;
                                                    } else {
                                                      obscureTextPasseord = true;
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  obscureTextPasseord
                                                      ? Icons.visibility_off_rounded
                                                      : Icons.visibility_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.006),
                                          GetBuilder<AppVerification>(builder: (getRe) {
                                            return Row(
                                              children: [
                                                Checkbox(
                                                  value: appVerification.rememberMe,
                                                  activeColor: theme.colorScheme.primary,
                                                  onChanged: (v) =>
                                                      appVerification.updateRemember(v),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () =>
                                                        appVerification.updateRemember(null),
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: size.height * 0.01,
                                                      ),
                                                      child: Text(
                                                        'Remember me',
                                                        style: theme.textTheme.bodyMedium
                                                            ?.copyWith(
                                                          color: theme
                                                              .colorScheme.onSurfaceVariant,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          SizedBox(height: size.height * 0.018),
                                          _gradientButton(
                                            context: context,
                                            text: 'login',
                                            leadingIcon: Icons.login_rounded,
                                            onTap: () async {
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
                                                rememberMe: appVerification.rememberMe,
                                              );
                                            },
                                          ),
                                          SizedBox(height: size.height * 0.01),
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
                                              child: Text(
                                                "Continue as Guest",
                                                style:
                                                    theme.textTheme.labelLarge?.copyWith(
                                                  color: theme
                                                      .colorScheme.onSurfaceVariant,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.004),
                                          Center(
                                            child: TextButton.icon(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    theme.colorScheme.primary,
                                                textStyle: theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(() => SelectSchool(),
                                                    transition: Transition.fadeIn);
                                              },
                                              icon: const Icon(Icons.app_registration_rounded),
                                              label: Text('register'.tr),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.04),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          floatingActionButton: GetBuilder<LocaleState>(builder: (lang) {
            return Column(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white.withOpacity(0.95),
                  elevation: 6,
                  shape: const CircleBorder(),
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
                            ? const AssetImage("assets/images/logo_en.png")
                            : Get.locale == const Locale('la', 'CN')
                                ? const AssetImage("assets/images/logo_cn.png")
                                : const AssetImage("assets/images/logo_lao.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                Text(
                  Get.locale == const Locale('en', 'US')
                      ? 'english'.tr
                      : Get.locale == const Locale('la', 'CN')
                          ? 'cn'.tr
                          : 'lao'.tr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                  'V $version',
                  style: TextStyle(
                      color: appColors.grey, fontSize: fixSize(0.01, context)),
                ),
              ),
            ],
          )),
    );
  }
}
