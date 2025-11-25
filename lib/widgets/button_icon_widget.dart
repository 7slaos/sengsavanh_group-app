
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import '../custom/app_color.dart';

class ButtonIconWidget extends StatelessWidget {
  ButtonIconWidget(
      {Key? key,
      this.fontSize,
      this.color,
      this.backgroundColor,
      required this.onPressed,
      this.width,
      this.height,
      required this.text,
      this.fontWeight,
      this.borderRadius,
      this.icon})
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
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fixSize = size.width + size.height;
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 0.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color,),
            const SizedBox(
              width: 5,
            ),
            CustomText(
              text: text,
              color: color ?? appColor.white,
              fontSize: fontSize ?? fixSize * 0.012,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}
