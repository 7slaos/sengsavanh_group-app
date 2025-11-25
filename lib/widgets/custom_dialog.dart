import 'package:multiple_school_app/custom/app_color.dart';
import 'package:multiple_school_app/custom/app_size.dart';
import 'package:multiple_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialogs {
  AppColor appColor = AppColor();
  dialogLoading() async {
    await Get.dialog(
      Builder(builder: (context) {
        Size size = MediaQuery.of(context).size;
        double fixSize = size.width + size.height;
        return SizedBox(
          height: fixSize * 0.04,
          width: fixSize * 0.04,
          child: Center(
            child: CircularProgressIndicator(
              color: appColor.mainColor,
            ),
          ),
        );
      }),
      barrierDismissible: false,
    );
  }

  dialogShowMessage({
    required String message,
    IconData? icon,
    Color? colorsIcon,
    Color? colorButton,
  }) async {
    await Get.dialog(
      Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          double fixSize = size.width + size.height;
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon ?? Icons.warning,
                  color: colorsIcon ?? appColor.mainColor,
                  size: fixSize * 0.045,
                ),
                SizedBox(
                  height: fixSize * 0.01,
                ),
                CustomText(
                  text: message,
                  color: Colors.black,
                  fontSize: fixSize * 0.0185,
                )
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => colorButton ?? appColor.mainColor)),
                      onPressed: () {
                        Get.back();
                      },
                      child: CustomText(
                        text: 'ok',
                        fontSize: fixSize * 0.0185,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<bool> yesAndNoDialogWithText(BuildContext context, String? text,
      {double? fontSize,
      String? cancelText,
      String? confirmText,
      Color? color,
      IconData? iconData}) async {
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        actionsPadding: const EdgeInsets.only(bottom: 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: Icon(
                iconData ?? Icons.question_mark,
                size: fixSize(0.08, context),
                color: appColor.mainColor,
              ),
            ),
            SizedBox(
              height: fixSize(0.008, context),
            ),
            Center(
              child: Text(
                (text ?? "").tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color ?? appColor.mainColor,
                  fontSize: fontSize ?? fixSize(0.0175, context),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => {Get.back(result: false)},
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: appColor.grey,
                    ),
                    child: CustomText(
                      text: cancelText ?? "cancel",
                      color: appColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fixSize(0.0165, context),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => {Get.back(result: true)},
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: appColor.mainColor,
                    ),
                    child: CustomText(
                      text: cancelText ?? "confirm",
                      fontWeight: FontWeight.bold,
                      color: appColor.white,
                      fontSize: fixSize(0.0165, context),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<bool> LogoutyesAndNoDialogWithText(BuildContext context, String? text,
      {double? fontSize,
      String? cancelText,
      String? confirmText,
      Color? color,
      IconData? iconData}) async {
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actionsPadding: const EdgeInsets.only(bottom: 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "logout".tr,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize ?? fixSize(0.02, context)),
              ),
            ),
            SizedBox(
              height: fixSize(0.008, context),
            ),
            Center(
              child: Text(
                (text ?? "").tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color ?? appColor.mainColor,
                  fontSize: fontSize ?? fixSize(0.0175, context),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => {Get.back(result: false)},
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: appColor.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: CustomText(
                      text: cancelText ?? "cancel".tr,
                      color: appColor.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: fixSize(0.0165, context),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => {Get.back(result: true)},
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: appColor.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: CustomText(
                      text: cancelText ?? "ok".tr,
                      fontWeight: FontWeight.w500,
                      color: appColor.blueLight,
                      fontSize: fixSize(0.0165, context),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  showToast({
    String? text,
    double? fontSize,
    Color? backgroundColor,
    ToastGravity? gravity,
  }) async {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: (text ?? "").tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor?.withOpacity(0.75) ??
            appColor.mainColor.withOpacity(0.75),
        textColor: Colors.white,
        fontSize: fontSize ?? 16.0);
  }

  showMessage({
    String? text,
    double? fontSize,
    Color? backgroundColor,
    ToastGravity? gravity,
  }) async {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: (text ?? "").tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor?.withOpacity(0.75) ??
            appColor.mainColor.withOpacity(0.75),
        textColor: Colors.white,
        fontSize: fontSize ?? 16.0);
  }
  showToastWithIcon({required BuildContext context,required String message,IconData? icon, Color? iconColor, Color? backgroundColor}) {
    final fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor ?? appColor.mainColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         Icon(icon ?? Icons.check, color: iconColor ?? Colors.white),
          const SizedBox(width: 12.0),
          Text(message.tr, style: TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

}
