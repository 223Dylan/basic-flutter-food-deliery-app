import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/views/customtext.dart';

class custombutton extends StatelessWidget {
  final String label;
  final VoidCallback? action;
  const custombutton({
    super.key,
    required this.label,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      minWidth: double.infinity,
      child: customtext(
        label: label,
        labelFontsize: 16,
      ),
      color: greenColor,
    );
  }
}
