import 'package:pathana_school_app/custom/app_color.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Icon showIcon;
  final String title;
  final VoidCallback onchange;

  CategoryCard({
    required this.showIcon,
    required this.title,
    required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    AppColor appColor = AppColor();
    Size size = MediaQuery.of(context).size;
    double fSize = size.height + size.width;
    return GestureDetector(
      onTap: onchange,
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showIcon,
            // SizedBox(height: fSize * 0.005),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fSize * 0.0150,
                color: appColor.mainColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
