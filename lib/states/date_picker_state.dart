import 'package:multiple_school_app/functions/format_date.dart';
import 'package:multiple_school_app/functions/format_month.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerState extends GetxController {
  final date = TextEditingController();
  final month = TextEditingController();
  final calDate = TextEditingController();
  final calMonth = TextEditingController();
  DateTime? getDate;
  DateTime? getMonth;
  // DateTime? selectedDate;

  selectDATE({required BuildContext context}) async {
    var selectDate = await showDatePicker(
      context: context,
      initialDate: getDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (selectDate != null) {
      getDate = selectDate;
      calDate.text =
          "${selectDate.year}-${selectDate.month.toString().padLeft(2, '0')}-${selectDate.day.toString().padLeft(2, '0')}";
      date.text =
          "${selectDate.day}/${selectDate.month.toString().padLeft(2, '0')}/${selectDate.year.toString().padLeft(2, '0')}";
      update();
    } else {
      // Optionally handle if user cancels date selection
      // print('No date selected');
    }
  }

  Future<void> selectMonth({required BuildContext context}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Update the selected month in the format 'MM/YYYY'
      date.text = "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      month.text = "${picked.month}/${picked.year.toString().padLeft(2, '0')}";
      calMonth.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
      update(); // Notify GetX of the state change
    }
  }

  setCurrentMonth() {
    getMonth = DateTime.now();
    month.text = FormatMonth(month: getMonth.toString()).toString();
    date.text = FormatDate(date: getMonth.toString()).toString();
    update();
  }
}
