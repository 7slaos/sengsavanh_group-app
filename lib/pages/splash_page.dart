import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/pages/adminschool/admin_school_dashboard.dart';
import 'package:multiple_school_app/pages/login_page.dart';
import 'package:multiple_school_app/pages/parent_recordes/home_page.dart';
import 'package:multiple_school_app/pages/student_records/dashboard_page.dart';
import 'package:multiple_school_app/pages/superadmin/super_admin_dashboard.dart';
import 'package:multiple_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:multiple_school_app/states/appverification.dart';
import 'package:multiple_school_app/states/profile_state.dart';
import 'package:multiple_school_app/states/profile_student_state.dart';
import 'package:multiple_school_app/states/profile_teacher_state.dart';
import 'package:multiple_school_app/states/register_state.dart';
import '../states/auth_login_register.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Dev toggle: when true (and in debug), always show LoginPage to inspect UI
  static const bool kAlwaysShowLoginDuringDev = false;
  final AppVerification appVerification = Get.put(AppVerification());
  final RegisterState registerState = Get.put(RegisterState());
  final ProfileState profileState = Get.put(ProfileState());
  final ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  final ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  final AuthLoginRegister authLoginRegister = Get.put(AuthLoginRegister());

  final AppColor appColor = AppColor();
  int changeSize = 0;

  @override
  void initState() {
    super.initState();

    // Do non-UI init immediately
    registerState.getSchools();
    appVerification.setInitToken();

    // Defer anything that shows dialogs / navigates until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _boot();
    });
  }

  Future<void> _boot() async {
    // 1) Try auto-login if "remember me" is set
    await _maybeAutoLogin();

    // 2) If already have token, validate token for the role
    await _maybeValidateExistingToken();

    // 3) Animate splash
    await _animateLogo();

    // 4) Route based on role/token
    if (!mounted) return;
    _routeByRole();
  }

  Future<void> _maybeAutoLogin() async {
    final remember = appVerification.rememberMe == true;
    final phone = appVerification.phone;
    final pass = appVerification.password;

    if (remember && phone.isNotEmpty && pass.isNotEmpty) {
      // Safe to show dialogs now (post-frame)
      await authLoginRegister.login(
        context: Get.context ?? context,
        phone: phone,
        password: pass,
      );
      // login should persist token/role inside AppVerification
    }
  }

  Future<void> _maybeValidateExistingToken() async {
    if (appVerification.token.isEmpty) return;

    final role = appVerification.role;
    if (role == 'p' || role == '1' || role == '2' || role == '3') {
      await profileState.checkToken();
    } else if (role == 's') {
      await profileStudentState.checkToken();
    } else if (role == 't') {
      await profileTeacherState.checkToken();
    }
  }

  Future<void> _animateLogo() async {
    // simple step animation like your original code
    setState(() => changeSize = 50);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => changeSize = 100);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _routeByRole() {
    if (kAlwaysShowLoginDuringDev && kDebugMode) {
      Get.off(() => const LoginPage(), duration: const Duration(milliseconds: 500));
      return;
    }
    final token = appVerification.token;
    final role = appVerification.role;

    if (token.isEmpty) {
      Get.off(() => const LoginPage(), duration: const Duration(milliseconds: 500));
      return;
    }

    if (role == 's') {
      Get.off(() => const DashboardPage(), duration: const Duration(milliseconds: 500));
    } else if (role == 'p') {
      Get.off(() => const HomePage(), duration: const Duration(milliseconds: 500));
    } else if (role == 't') {
      Get.off(() => const TeacherDashboardPage(), duration: const Duration(milliseconds: 500));
    } else if (role == '1') {
      Get.off(() => const SuperAdminDashboard(), duration: const Duration(milliseconds: 500));
    } else if (role == '2' || role == '3') {
      Get.off(() => const AdminSchoolDashboard(), duration: const Duration(milliseconds: 500));
    } else {
      Get.off(() => const LoginPage(), duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appColor.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            width: size.width,
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
