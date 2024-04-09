import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/logincontroller.dart';
import 'package:get/get.dart';

// Corrected the variable name to follow convention (camelCase)
LoginController loginController = Get.put(LoginController());

class customtextfield extends StatefulWidget {
  final String? labelText;
  final String? hint;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? typedColor;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Validator function

  const customtextfield({
    Key? key,
    this.labelText,
    this.hint,
    this.prefixIcon,
    this.prefixIconColor,
    this.labelColor,
    this.hintColor,
    this.typedColor = whiteColor,
    this.isPassword = false,
    this.controller,
    this.validator, // Add validator parameter
  }) : super(key: key);

  @override
  customtextfieldstate createState() => customtextfieldstate();
}

class customtextfieldstate extends State<customtextfield> {
  TextEditingController? controller;
  String? _errorText; // Track error text

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: widget.typedColor,
      ),
      controller: controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hoverColor: greenColor,
        labelText: widget.labelText,
        hintText: widget.hint,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        )
            : null,
        prefixIconColor: widget.prefixIconColor,
        labelStyle: TextStyle(
          color: widget.labelColor,
        ),
        hintStyle: TextStyle(
          color: widget.hintColor,
        ),
        errorText: _errorText, // Set error text
      ),
      // Add validator function
      onChanged: (value) {
        if (widget.validator != null) {
          setState(() {
            _errorText = widget.validator!(value); // Call the validator function
          });
        }
      },
    );
  }
}
