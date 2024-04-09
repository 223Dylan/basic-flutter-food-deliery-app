import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/homecontroller.dart';
import 'package:flutter_attempt_1/views/cart.dart';
import 'package:flutter_attempt_1/views/dashboard.dart';
import 'package:flutter_attempt_1/views/profile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

var screens = [Dashboard(), Cart(), ProfilePage()];
HomeController homeController = Get.put(HomeController());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(
            Icons.house,
            color: blackColor,
          ),
          Icon(
            Icons.person,
            color: blackColor,
          ),
          Icon(
            Icons.trolley,
            color: blackColor,
          ),
        ],
        color: greenColor,
        backgroundColor: blackColor,
        buttonBackgroundColor: greenColor,
        onTap: (index) {
          homeController.updateSelectedPage(index);
        },
      ),
      body:
          Obx(() => Center(child: screens[homeController.selectedPage.value])),
    );
  }
}
