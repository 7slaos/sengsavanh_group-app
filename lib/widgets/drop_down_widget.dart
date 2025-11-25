import 'package:multiple_school_app/custom/app_color.dart';
import 'package:flutter/material.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  const CustomDropDownWidget(
      {super.key,
      required this.fixSize,
      required this.appColor,
      required this.value,
      required this.dropdownData,
      required this.hint,
      required this.listMenuItems,
      required this.onChange,
      this.borderRaduis,
      this.margin,
      this.height});

  final double fixSize;
  final AppColor appColor;
  final dynamic value;
  final List<dynamic> dropdownData;
  final String hint;
  final Function(dynamic) onChange;
  final List<DropdownMenuItem> listMenuItems;
  final double? borderRaduis;
  // final EdgeInsetsGeometry? margin;
  final double? margin;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin ?? fixSize * 0.001),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRaduis ?? 999),
          color: appColor.white,
          boxShadow: [
            BoxShadow(
                blurRadius: fixSize * 0.0025,
                offset: const Offset(0, 1),
                color: appColor.grey)
          ]),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   border: Border.all(width: 0.6, color: appColor.grey),
      //   color: appColor.white,
      // ),
      // margin:
      //     margin ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: value,
                  isExpanded: true,
                  items: listMenuItems,
                  onChanged: onChange,
                  hint: Text(
                    hint,
                    style: TextStyle(fontSize: fixSize * 0.0145),
                  ),
                  // hint: CustomText(
                  //   text: hint,
                  //   fontSize: fixSize * 0.0145,
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
