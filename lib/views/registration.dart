import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/views/custombutton.dart';
import 'package:flutter_attempt_1/views/customtext.dart';
import 'package:flutter_attempt_1/views/customtextfield.dart';
import 'package:flutter_attempt_1/views/home.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TextEditingController fName = TextEditingController();
TextEditingController lName = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class Registration extends StatelessWidget {
  const Registration({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: const Text("Sign-up"),
        backgroundColor: greenColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("assets/images/logo-no-background.png"),
                height: 200,
                width: 200,
              ),
              SizedBox(height: 50),
              customtextfield(
                labelText: "First Name",
                prefixIcon: Icons.person,
                labelColor: whiteColor,
                prefixIconColor: whiteColor,
                hintColor: greyWhiteColor,
                controller: fName,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              customtextfield(
                labelText: "Last Name",
                prefixIcon: Icons.person,
                labelColor: whiteColor,
                prefixIconColor: whiteColor,
                hintColor: greyWhiteColor,
                controller: lName,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              customtextfield(
                hint: "example@mail.com",
                labelText: "Email",
                prefixIcon: Icons.email,
                labelColor: whiteColor,
                prefixIconColor: whiteColor,
                hintColor: greyWhiteColor,
                controller: email,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              customtextfield(
                hint: "Enter Password",
                labelText: "Password",
                labelColor: whiteColor,
                prefixIcon: Icons.lock,
                isPassword: true,
                prefixIconColor: whiteColor,
                hintColor: greyWhiteColor,
                controller: password,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: custombutton(
                  label: "Sign-Up",
                  action: () => serverSignup(context),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customtext(
                    label: "Already have an account?",
                    labelFontsize: 17,
                    labelFontWeight: FontWeight.normal,
                    labelColor: whiteColor,
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    child: customtext(
                      label: "Sign In",
                      labelFontsize: 20,
                      labelColor: lighterGreenColor,
                    ),
                    onTap: login,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void login() {
  Get.toNamed("/");
}

Future<void> serverSignup(BuildContext context) async {
  // Check if any of the required fields are empty
  if (fName.text.isEmpty || lName.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
    // Show error message if any required field is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill out all required fields'),
        backgroundColor: Colors.red,
      ),
    );
    return; // Exit the function early
  }

  // Proceed with sign-up
  http.Response response;
  var body = {
    'first_name': fName.text.trim(),
    'last_name': lName.text.trim(),
    'email': email.text.trim(),
    'password': password.text.trim(),
  };
  response = await http.post(
    Uri.parse("http://acs314flutter.xyz/dylan_students/signup.php"),
    body: body,
  );
  if (response.statusCode == 200) {
    var serverResponse = json.decode(response.body);
    int signedUp = serverResponse['success'];
    if (signedUp == 1) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful'),
          backgroundColor: greenColor,
        ),
      );
      login();
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration failed'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


