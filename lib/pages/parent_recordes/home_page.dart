import 'package:pathana_school_app/pages/history_payment_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/dashboard_parent_page.dart';
import 'package:pathana_school_app/pages/parent_recordes/view_score_children_page.dart';
import 'package:pathana_school_app/pages/teacher_recordes/setting_page.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/widgets/bottomNavigattionBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeState homeState = Get.put(HomeState());
  List<Widget> pages = [
    DashboardParentPage(),
    ViewScoreChildrenPage(),
    HistoryPaymentPage(type: 'p',),
    SettingPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<HomeState>(builder: (get) {
          return pages[homeState.currentpage];
        }),
        bottomNavigationBar: BottomnavigattionbarWidget());
  }
}
