import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_attempt_1/models/productmodel.dart';

import '../controllers/cartcontroller.dart';
import '../controllers/logincontroller.dart';

LoginController loginController = Get.put(LoginController());
CartController cartController = Get.put(CartController());




class ItemContainer extends StatelessWidget {
  final FoodItem foodItem;
  final String category;
  ItemContainer({required this.foodItem, required this.category});

  void addToCart(FoodItem foodItem, BuildContext context) {
    cartController.addToCart(
        foodItem.title, foodItem.id.toString(), foodItem.price.toString(), foodItem.imgUrl);
    print('Adding to cart: ${foodItem.title}, ${foodItem.id}, ${foodItem.price}, ${foodItem.imgUrl}');
    // Show SnackBar with the added food item
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${foodItem.title} added to cart'),
        backgroundColor: greenColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (foodItem.category == category) {
      return GestureDetector(
        onTap: () {
          addToCart(foodItem, context);
        },
        child: Items(
          hotel: foodItem.hotel,
          itemName: foodItem.title,
          itemPrice: foodItem.price,
          imgUrl: foodItem.imgUrl,
          leftAligned: foodItem.id % 2 == 0 ? true : false,
          category: foodItem.category,
        ),
      );
    } else {
      return Container();
    }
  }
}


class Items extends StatelessWidget {
  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final double itemPrice;
  final String hotel;
  final String category;

  Items({
    required this.leftAligned,
    required this.imgUrl,
    required this.itemName,
    required this.itemPrice,
    required this.hotel,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: leftAligned
                      ? Radius.circular(0)
                      : Radius.circular(containerBorderRadius),
                  right: leftAligned
                      ? Radius.circular(containerBorderRadius)
                      : Radius.circular(0),
                ),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                left: leftAligned ? 20 : 0,
                right: leftAligned ? 0 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          itemName,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: greenColor),
                        ),
                      ),
                      Text(
                        "KSh $itemPrice",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: whiteColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                                text: " by ",
                                style: TextStyle(color: greyWhiteColor)),
                            TextSpan(
                                text: hotel,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor))
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: containerPadding,
                  )
                ],
              ),
            )
          ]),
        )
      ],
    );
  }
}
class FoodItem {
  int id;
  String title;
  String hotel;
  double price;
  String imgUrl;
  String category;
  int quantity;

  FoodItem({
    required this.id,
    required this.title,
    required this.hotel,
    required this.price,
    required this.imgUrl,
    required this.category,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}





