import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/productcontroller.dart';
import 'package:flutter_attempt_1/models/productmodel.dart';
import 'package:flutter_attempt_1/views/categorylistitem.dart';
import 'package:flutter_attempt_1/views/customtext.dart';
import 'package:flutter_attempt_1/views/itemcontainer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

ProductController productController = Get.put(ProductController());

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            customtext(
              label: "Welcome!",
              labelColor: greenColor,
              labelFontsize: 32.0,
            ),
            SizedBox(height: 16.0),
            CategoriesWidget(),
            SizedBox(height: 16.0),
            _buildFoodItemList(),
          ],
        ),
      ),
    );
  }

  /*Widget _buildFoodItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: fooditemList.foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = fooditemList.foodItems[index];
        return ItemContainer(foodItem: foodItem);
      },
    );
  }*/

  Widget _buildFoodItemList() {
    getProducts();
    return Obx(() {
      String selectedCategory = categoryController.selectedCategory.value;
      List<FoodItem> filteredFoodItems = productController.productList
          .where((foodItem) => foodItem.category == selectedCategory)
          .toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: productController.productList.length,
        itemBuilder: (context, index) {
          if (index < 0 || index >= filteredFoodItems.length) {
            return SizedBox(); // Return an empty widget if index is out of range
          }
          final foodItem = filteredFoodItems[index];
          return ItemContainer(foodItem: foodItem, category: selectedCategory);
        },
      );
    });
  }

  Future<void> getProducts() async {
    http.Response response;
    response = await http.get(Uri.parse("http://acs314flutter.xyz/dylan_students/get_products.php"));
    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      var productResponse = serverResponse['products'] as List<dynamic>;
      var productList = productResponse.map((product) => FoodItem(
        id: int.parse(product['id'].toString()),
        title: product['pname'],
        hotel: product['hotel'],
        price: double.parse(product['price'].toString()),
        imgUrl: product['image_url'],
        category: product['cartegory'],
      )).toList();
      productController.updateProductList(productList);
    } else {
      print("Error occurred");
    }
  }


}
