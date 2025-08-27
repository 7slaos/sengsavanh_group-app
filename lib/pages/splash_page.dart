import 'package:pathana_school_app/custom/app_color.dart';
import 'package:pathana_school_app/pages/adminschool/admin_school_dashboard.dart';
import 'package:pathana_school_app/pages/login_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/home_page.dart';
import 'package:pathana_school_app/pages/student_records/dashboard_page.dart';
import 'package:pathana_school_app/pages/superadmin/super_admin_dashboard.dart';
import 'package:pathana_school_app/pages/teacher_recordes/dashboard_page.dart';
import 'package:pathana_school_app/states/appverification.dart';
import 'package:pathana_school_app/states/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/states/profile_student_state.dart';
import 'package:pathana_school_app/states/profile_teacher_state.dart';
import 'package:pathana_school_app/states/register_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppVerification appVerification = Get.put(AppVerification());
  RegisterState registerState = Get.put(RegisterState());
  ProfileState profileState = Get.put(ProfileState());
  ProfileStudentState profileStudentState = Get.put(ProfileStudentState());
  ProfileTeacherState profileTeacherState = Get.put(ProfileTeacherState());
  int changeSize = 0;
  AppColor appColor = AppColor();
  @override
  void initState() {
    super.initState();
    registerState.getSchools();
    appVerification.setInitToken();
    getProfile();
    //initSplash();
  }

  getProfile() async {
    if (appVerification.token != "") {
      if (appVerification.role == 'p' ||
          appVerification.role == '1' ||
          appVerification.role == '2' ||
          appVerification.role == '3') {
        await profileState.checkToken();
      } else if (appVerification.role == 's') {
        await profileStudentState.checkToken();
      } else if (appVerification.role == 't') {
        await profileTeacherState.checkToken();
      }
    }
    initSplash();
  }

  initSplash() async {
    await Future.delayed(const Duration(milliseconds: 300)).then((value) {
      setState(() {
        changeSize = 50;
      });
    }).then((value) async {
      await Future.delayed(const Duration(milliseconds: 300)).then((value) {
        setState(() {
          changeSize = 100;
        });
      });
    }).then((value) async {
      if (appVerification.token != '') {
        if (appVerification.role == 's') {
          Get.off(() => const DashboardPage(),
              duration: const Duration(milliseconds: 500));
        } else if (appVerification.role == 'p') {
          Get.off(() => const HomePage(),
              duration: const Duration(milliseconds: 500));
        } else if (appVerification.role == 't') {
          Get.off(() => const TeacherDashboardPage(),
              duration: const Duration(milliseconds: 500));
        } else if (appVerification.role == '1') {
          Get.off(() => const SuperAdminDashboard(),
              duration: const Duration(milliseconds: 500));
        } else if (appVerification.role == '2' || appVerification.role == '3') {
          Get.off(() => const AdminSchoolDashboard(),
              duration: const Duration(milliseconds: 500));
        } else {
          Get.offAll(() => const LoginPage(),
              duration: const Duration(milliseconds: 500));
        }
      } else {
        Get.off(() => const LoginPage(),
            duration: const Duration(milliseconds: 500));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // double fixSize = size.width + size.height;
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
          )
        ],
      ),
    );
  }
}
