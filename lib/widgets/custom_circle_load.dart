import 'package:pathana_school_app/custom/app_color.dart';
import 'package:flutter/material.dart';

class CircleLoad extends StatelessWidget {
  CircleLoad({Key? key, this.color, this.circleSize}) : super(key: key);
  final AppColor appColors = AppColor();
  final Color? color;
  final double? circleSize;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixSize = size.width + size.height;
    return Center(
      child: SizedBox(
        height: circleSize ?? fixSize * 0.04,
        width: circleSize ?? fixSize * 0.04,
        child: Center(
          child: CircularProgressIndicator(color: color ?? appColors.mainColor),
        ),
      ),
    );
  }
}