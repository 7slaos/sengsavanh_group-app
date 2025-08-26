import 'package:get/get.dart';
import 'package:pathana_school_app/custom/app_size.dart';
import 'package:flutter/material.dart';
import 'package:pathana_school_app/widgets/custom_text_widget.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const SubjectCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<LocaleState>(builder: (localeUpdate) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: fixSize(0.040, context)),
              SizedBox(height: size.height * 0.01),
              Text(
                title.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fixSize(0.0125, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
