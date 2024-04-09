import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/cartcontroller.dart';
import 'package:flutter_attempt_1/views/customtext.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
CartController cartController = Get.put(CartController());


class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        color: Colors.black, // Set background color to black
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),

            customtext(
              label: 'My Cart',
              labelColor: greenColor,
              labelFontsize: 30,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = cartController.cartItems[index];
                  return ListTile(
                    leading: Image.network(
                      item['imgUrl'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: customtext(
                      label: item['title'],
                      labelColor: greenColor,
                      labelFontsize: 16,
                    ),
                    subtitle: customtext(
                      label: 'KSh ${item['price']} x ${item['quantity']}',
                      labelColor: greenColor,
                      labelFontsize: 15,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () =>
                              cartController.updateQuantity(index, item['quantity'] - 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: greenColor),
                          onPressed: () =>
                              cartController.updateQuantity(index, item['quantity'] + 1),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Check if the cart is not empty
                      if (cartController.cartItems.isNotEmpty) {
                        // Show confirmation dialog
                        bool confirmOrder = await showConfirmationDialog(context);
                        if (confirmOrder) {
                          await checkout(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Your cart is empty'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: greenColor),
                    child: Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20, color: whiteColor),
                    ),
                  ),
                  Text(
                    'Total: KSh ${cartController.calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(color: whiteColor, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<bool> showConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Order'),
        content: Text('Are you sure you want to place the order?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Dismiss dialog and return false
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Dismiss dialog and return true
            },
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}

Future<void> checkout(BuildContext context) async {
  await createreceipt();
  cartController.clearCart();
  // Show SnackBar to inform the user and thank them for ordering
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Thank you for ordering from us'),
      backgroundColor: Colors.green,
    ),
  );
}

Future<void> createorder() async {
  http.Response response;

  var userEmail = loginController.email.value;

  // Accessing cartItems from the CartController
  var cartItems = List.from(cartController.cartItems);

  for (var item in cartItems) {
    var body = {
      'productID': item['id'],
      'amount': item['price'],
      'userID': userEmail,
    };

    response = await http.post(
      Uri.parse("http://acs314flutter.xyz/dylan_students/createorder.php"),
      body: body,
    );

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int signedUp = serverResponse['success'];
      if (signedUp == 1) {
        print("Order created for ${item['title']}");
      } else {
        print("Order failed for ${item['title']}");
      }
    }
  }
}

Future<void> createreceipt() async {
  http.Response response;
  var body = {
    'user_id': loginController.email.value,
    'amount': cartController.calculateTotalPrice().toStringAsFixed(2),
  };
  response = await http.post(
      Uri.parse("http://acs314flutter.xyz/dylan_students/receipt.php"),
      body: body);
  if (response.statusCode == 200) {
    var serverResponse = json.decode(response.body);
    int signedUp = serverResponse['success'];
    if (signedUp == 1) {
      print("Receipt created");
      createorder();

    }
  }
}
