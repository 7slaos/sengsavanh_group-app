// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathana_school_app/states/home_state.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class BottomnavigattionbarWidget extends StatefulWidget {
  const BottomnavigattionbarWidget({super.key});

  @override
  State<BottomnavigattionbarWidget> createState() => _BottomnavigattionbarWidgetState();
}

class _BottomnavigattionbarWidgetState extends State<BottomnavigattionbarWidget> {
  HomeState homeState = Get.put(HomeState());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fSize = size.width + size.height;
    return GetBuilder<HomeState>(builder: (getHome) {
      return GetBuilder<LocaleState>(
        builder: (getLang) {
          return Stack(
            children: [
              BottomNavigationBar(
                backgroundColor: const Color.fromARGB(255, 6, 25, 136),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                selectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedIconTheme: const IconThemeData(color: Colors.white60),
                selectedFontSize: fSize * 0.016,
                iconSize: fSize * 0.03,
                unselectedFontSize: fSize * 0.015,
                type: BottomNavigationBarType.fixed,
                currentIndex: homeState.currentpage,
                onTap: (index) {
                  homeState.setCurrentPage(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.feed_outlined),
                    label: 'score'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school_outlined),
                    label: 'Tuition_fees'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'setting'.tr,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: (MediaQuery.of(context).size.width / 4) * homeState.currentpage,
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 3,
                  color: Colors.white, // Change the color as needed
                ),
              ),
            ],
          );
        }
      );
    });
  }
}
