
import 'package:gastos_app/app_globals/R.dart';
import 'package:flutter/material.dart';

class TXTextWidget extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow textOverflow;
  final TextAlign textAlign;
  final FontStyle? fontStyle;

  const TXTextWidget({
    Key? key,
    required this.text,
    this.size = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.textOverflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.fontStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color ?? Colors.white,
          fontSize: size,
          fontWeight: fontWeight,
          fontStyle: fontStyle),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
