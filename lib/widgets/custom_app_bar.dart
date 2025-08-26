
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import '../custom/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key,
      required this.height,
      this.leading,
      this.title,
      this.color,
      this.titleSize,
      this.actions,
      this.backgroundColor,
      required this.orientation,
      this.centerTitle});
  final double height;
  final Color? backgroundColor;
  final AppColor appColors = AppColor();
  final Widget? leading;
  final String? title;
  final double? titleSize;
  final List<Widget>? actions;
  final Orientation? orientation;
  final Color? color;
  final bool? centerTitle;
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;
    double fixSize = size.width + size.height;
    return AppBar(
      backgroundColor: backgroundColor ?? appColors.mainColor,
      centerTitle: centerTitle ?? false,
      leading: leading ??
          BackButton(
            color: appColors.white,
          ),
      title: CustomText(
        text: title ?? "",
        fontSize: titleSize ??
            (orientation == Orientation.portrait
                ? fixSize * 0.02
                : fixSize * 0.0165),
        color: color ?? appColors.white,
        fontWeight: FontWeight.w500,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        height * (orientation == Orientation.portrait ? 0.075 : 0.1),
      );
}
