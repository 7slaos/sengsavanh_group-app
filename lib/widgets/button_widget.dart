import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import '../custom/app_color.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget(
      {Key? key,
      this.fontSize,
      this.color,
      this.backgroundColor,
      required this.onPressed,
      this.width,
      this.height,
      required this.text,
      this.fontWeight,
      this.borderRadius})
      : super(key: key);

  final double? fontSize;
  final double? width;
  final double? height;
  final Color? color;
  final String text;
  final Color? backgroundColor;
  final AppColor appColor = AppColor();
  final VoidCallback onPressed;
  final FontWeight? fontWeight;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixSize = size.width + size.height;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 0.0)),
        child: CustomText(
          text: text,
          color: color ?? appColor.white,
          fontSize: fontSize ?? fixSize * 0.012,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
