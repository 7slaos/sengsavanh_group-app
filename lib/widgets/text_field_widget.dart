import 'package:flutter/material.dart';
import '../custom/app_color.dart';

class TextFielWidget extends StatelessWidget {
  const TextFielWidget(
      {super.key,
      required this.fixSize,
      required this.appColor,
      required this.controller,
      required this.hintText,
      this.icon,
      required this.textInputType,
      this.iconSuffix,
      this.obscureText,
      this.margin,
      this.borderRaduis,
      this.maxLength,
      this.horizontal,
      this.width,
      this.height,
      this.iconPrefix,
      this.readOnly,
      this.onChanged,
      this.onSubmitted,
      this.fillColor,
      this.filled,
      this.onTap,
      this.contentPadding,
      this.fontSize});

  final double fixSize;
  final AppColor appColor;
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Widget? iconSuffix;
  final TextInputType textInputType;
  final bool? obscureText;
  final double? margin;
  final double? borderRaduis;
  final bool? readOnly;
  final int? maxLength;
  final double? horizontal;
  final double? width;
  final double? height;
  final Widget? iconPrefix;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final Color? fillColor;
  final bool? filled;
  final EdgeInsets? contentPadding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        // padding:
        //     EdgeInsets.symmetric(vertical: 2.0, horizontal: horizontal ?? 10),
        // margin: EdgeInsets.symmetric(horizontal: margin ?? fixSize * 0.015),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRaduis ?? 999),
            color: appColor.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: fixSize * 0.0025,
                  offset: const Offset(0, 1),
                  color: appColor.grey)
            ]),
        child: TextField(
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          controller: controller,
          cursorColor: appColor.mainColor,
          keyboardType: textInputType,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
              counterText: '',
              prefixIcon: iconPrefix,
              focusColor: appColor.mainColor,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: appColor.grey, fontSize: fontSize),
              fillColor: fillColor,
              filled: filled ?? false,
              contentPadding: contentPadding,
              suffixIcon: iconSuffix),
        ));
  }
}
