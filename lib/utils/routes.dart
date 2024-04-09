import 'package:flutter_attempt_1/views/home.dart';
import 'package:flutter_attempt_1/views/login.dart';
import 'package:flutter_attempt_1/views/registration.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static var routes = [
    GetPage(name: "/", page: () => Login()),
    GetPage(name: "/registration", page: () => Registration()),
    GetPage(name: "/home", page: () => Home()),
  ];
}
