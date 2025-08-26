import 'dart:io';

import 'package:pathana_school_app/states/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleState extends GetxController {
  GetStorage getStorage = GetStorage();
  List<String> valueLang = [];

  setInitValueLang() {
    var newList = getStorage.read('valueLang') ?? [];
    List<String> newValue = [];
    for (var element in newList) {
      newValue.add(element.toString());
    }
    valueLang = newValue;
    update();
  }

  setAddValueLang({required String text}) async {
    if (text.length >= 50) {
      return;
    }
    List<String> newValue = [];
    var check = valueLang.firstWhereOrNull((element) => element == text);
    for (var element in Translate().keys['en_US']!.keys) {
      if (element.trim() == text.trim()) {
        return;
      }
    }
    if (check == null) {
      newValue.add(text);
      newValue.addAll(valueLang);
      await getStorage.write('valueLang', newValue);
      valueLang = getStorage.read('valueLang') ?? [];
      update();
    }
  }

  @override
  void onInit() {
    setInitValueLang();
    super.onInit();
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.textOverflow = TextOverflow.ellipsis, // ✅ default ไม่ต้องส่งก็ได้
    this.textDecoration,
    this.shadows,
  });

  final String text;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final List<Shadow>? shadows;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final TextOverflow textOverflow; // ✅ ไม่เป็น nullable แล้ว

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocaleState>(builder: (localeUpdate) {
      localeUpdate.setAddValueLang(text: text);
      return Text(
        text.tr,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: textOverflow,
        style: TextStyle(
          fontSize: Platform.isAndroid ? fontSize : fontSize,
          color: color,
          shadows: shadows,
          fontFamily: "Noto Sans Lao",
          fontWeight: fontWeight,
          decoration: textDecoration,
        ),
      );
    });
  }
}
