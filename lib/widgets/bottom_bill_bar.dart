
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/student_records/dashboard_page.dart';
import '../pages/teacher_recordes/dashboard_page.dart';

class BottomPillBar extends StatelessWidget {
  const BottomPillBar({
    required this.scale,
    required this.isTablet,
    required this.teal,
    required this.type,
    this.rightIcon,
    this.rightTap
  });

  final double scale;
  final bool isTablet;
  final Color teal;
  final String type;
  final IconData? rightIcon;
  final Function()? rightTap;

  @override
  Widget build(BuildContext context) {
    final barH = (isTablet ? 64 : 56) * scale;
    final outer = (isTablet ? 58 : 54) * scale;
    final ring = 4.0 * scale;

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: 18 * scale,
            right: 18 * scale,
            bottom: 10 * scale,
            child: Container(
              height: barH,
              decoration: BoxDecoration(
                color: teal,
                borderRadius: BorderRadius.circular(18 * scale),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 22 * scale,
            bottom: 10 * scale,
            child: RingedCircleBtn(
              outerSize: outer,
              ringWidth: ring,
              fillColor: teal,
              icon: Icons.arrow_back_rounded,
              onTap: () => {
                Get.back()
              },
            ),
          ),
          Positioned(
            right: 22 * scale,
            bottom: 10 * scale,
            child: RingedCircleBtn(
              outerSize: outer,
              ringWidth: ring,
              fillColor: teal,
              icon: rightIcon ?? Icons.eject_rounded,
              onTap: rightTap ?? () {
                if(type == 't') {
                  Get.off(() => TeacherDashboardPage(), transition: Transition.fadeIn);
                }else if(type == 's'){
                  Get.off(() => DashboardPage(), transition: Transition.fadeIn);
                }else {
                  Get.back();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class RingedCircleBtn extends StatelessWidget {
  const RingedCircleBtn({
    required this.outerSize,
    required this.ringWidth,
    required this.fillColor,
    required this.icon,
    this.iconColor = Colors.white,
    this.onTap,
  });

  final double outerSize;
  final double ringWidth;
  final Color fillColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: outerSize,
          height: outerSize,
          decoration: const BoxDecoration(
            color: Colors.white, // ring
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(ringWidth),
          child: Container(
            decoration: BoxDecoration(color: fillColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: outerSize * 0.46),
          ),
        ),
      ),
    );
  }
}