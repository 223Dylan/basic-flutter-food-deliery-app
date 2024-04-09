import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/logincontroller.dart';
import 'package:flutter_attempt_1/utils/sharedpreferences.dart';
import 'package:flutter_attempt_1/views/custombutton.dart';
import 'package:flutter_attempt_1/views/customtext.dart';
import 'package:flutter_attempt_1/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

MySharedPreferences mySharedPreferences = MySharedPreferences();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
LoginController loginController = Get.put(LoginController());


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    mySharedPreferences.getValue("Username").then((value) {
      email.text = value;
      password.text = value;
    });
    return Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          title: const Text("Welcome Back!"),
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
                      width: 200),
                  SizedBox(
                    height: 50,
                  ),
                  customtextfield(
                    hint: "example@mail.com",
                    labelText: "Email",
                    prefixIcon: Icons.email,
                    labelColor: whiteColor,
                    prefixIconColor: whiteColor,
                    hintColor: greyWhiteColor,
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: custombutton(
                      label: "Login",
                      action: remoteLogin,
                    ),
                    /*MaterialButton(
                    onPressed: () => Get.toNamed("/registration"),
                    color: greenColor,
                    height: 50,
                    minWidth: 300,
                    child: Text(
                      "Login",
                      style: TextStyle(color: blackColor),
                    ),
                  )*/
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customtext(
                        label: "Don't have an account?",
                        labelFontsize: 18,
                        labelFontWeight: FontWeight.normal,
                        labelColor: whiteColor,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: customtext(
                          label: "Sign up",
                          labelFontsize: 20,
                          labelColor: lighterGreenColor,
                        ),
                        onTap: registration,
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}

void login() {
  Get.toNamed("/home");
}

void registration() {
  mySharedPreferences.writeValue("Username", email.text);
  Get.toNamed("/registration");
}


Future<void> remoteLogin() async {
  http.Response response;
  final Uri uri = Uri.parse("http://acs314flutter.xyz/dylan_students/signin.php?email=${email.text.trim()}&password=${password.text.trim()}");
  try {
    response = await http.get(uri);
    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int signedUp = serverResponse['success'];
      if (signedUp == 1) {
        var userData = serverResponse['userdata'][0]; // Fetch the first user data
        var email = userData['email'];
        var first_name= userData['first_name'];
        var last_name = userData['last_name'];
        loginController.updateEmail(email);
        loginController.updateFirstName(first_name);
        loginController.updateLastName(last_name);
        // Show success message
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Login successful'),
            backgroundColor: greenColor,
          ),
        );
        login();
      } else {
        // Show error message
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${serverResponse['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('HTTP Error: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
