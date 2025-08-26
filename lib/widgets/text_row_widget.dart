
import 'package:pathana_school_app/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';

class TextRowWidget extends StatefulWidget {
  const TextRowWidget(
      {Key? key,
      required this.title,
      required this.value,
      this.titlefontSize,
      this.valuefontSize,
      this.titleColor,
      this.valueColor,
      this.titletextAlign,
      this.valuetextAlign,
      this.titlefontWeight,
      this.valuefontWeight,
      this.titletextDecoration,
      this.valuetextDecoration,
      this.titleellipsis,
      this.valueellipsis})
      : super(key: key);
  final String title;
  final String value;
  final double? titlefontSize;
  final double? valuefontSize;
  final Color? titleColor;
  final Color? valueColor;
  final TextDecoration? titletextDecoration;
  final TextDecoration? valuetextDecoration;
  final TextAlign? titletextAlign;
  final TextAlign? valuetextAlign;
  final FontWeight? titlefontWeight;
  final FontWeight? valuefontWeight;
  final TextOverflow? titleellipsis;
  final TextOverflow? valueellipsis;

  @override
  State<TextRowWidget> createState() => _TextRowWidgetState();
}

class _TextRowWidgetState extends State<TextRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: widget.title,
          color: widget.titleColor,
          fontSize: widget.titlefontSize,
          fontWeight: widget.titlefontWeight,
          textAlign: widget.titletextAlign,
          textDecoration: widget.titletextDecoration,
          // ellipsis: widget.titleellipsis,
        ),
        CustomText(
          text: widget.value,
          color: widget.valueColor,
          fontSize: widget.valuefontSize,
          fontWeight: widget.valuefontWeight,
          textAlign: widget.valuetextAlign,
          textDecoration: widget.valuetextDecoration,
          // ellipsis: widget.valueellipsis,
        )
      ],
    );
  }
}
