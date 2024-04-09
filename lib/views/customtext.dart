import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';

class customtext extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double labelFontsize;
  final FontWeight labelFontWeight;
  const customtext(
      {super.key,
      required this.label,
      this.labelColor = blackColor,
      this.labelFontsize = 35,
      this.labelFontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: labelFontsize,
        color: labelColor,
        fontWeight: labelFontWeight,
      ),
    );
  }
}
