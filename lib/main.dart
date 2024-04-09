import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/controllers/cartcontroller.dart';
import 'package:flutter_attempt_1/utils/routes.dart';
import 'package:flutter_attempt_1/views/login.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    home: Login(),
    initialRoute: "/",
    getPages: Routes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
