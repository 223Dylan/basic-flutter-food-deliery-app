import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/receiptcontroller.dart';
import 'package:flutter_attempt_1/models/transactionmodel.dart';
import 'package:flutter_attempt_1/views/customtext.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

ReceiptController receiptController = Get.put(ReceiptController());

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              customtext(
                label: "Profile",
                labelColor: greenColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile icon
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      customtext(
                        label:
                        'Name: ${loginController.first_name} ${loginController.last_name}',
                        labelFontsize: 13,
                        labelColor: whiteColor,
                      ),
                      SizedBox(height: 8.0),
                      customtext(
                        label: 'Email: ${loginController.email}', // Random ID
                        labelFontsize: 13.0,
                        labelColor: whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Transaction summary
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                    label: 'Transaction Summary:',
                    labelFontsize: 20.0,
                    labelColor: greenColor,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          customtext(
                            label: 'Total Amount Spent:', // Dummy total amount
                            // spent
                            labelFontsize: 16.0,
                            labelColor: greyWhiteColor,
                            labelFontWeight: FontWeight.normal,
                          ),
                          customtext(
                            label:
                            'KSh ${receiptController.totalAmountSpent.toStringAsFixed(2)}', // Dummy total amount spent
                            labelFontsize: 16.0,
                            labelColor: whiteColor,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          customtext(
                            label: 'Total Items Bought:', // Dummy total items
                            // bought
                            labelFontsize: 16.0,
                            labelColor: greyWhiteColor,
                            labelFontWeight: FontWeight.normal,
                          ),
                          // Fetch and display the total number of items bought
                          FutureBuilder<int>(
                            future: getTotalItemsBought(), // Use FutureBuilder to await the result
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int totalItemsBought =
                                    snapshot.data ?? 0; // Get total items bought from snapshot data
                                return customtext(
                                  label: '$totalItemsBought', // Display the fetched value
                                  labelFontsize: 16.0,
                                  labelColor: whiteColor,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              customtext(
                label: 'Transactions:',
                labelFontsize: 20.0,
                labelColor: greenColor,
              ),
              SizedBox(height: 8.0),
              // List of active transactions
              _buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTransactionList() {
    // Fetch receipts when the page is built
    getReceipts();
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: receiptController.receiptList.length,
      itemBuilder: (context, index) {
        final receipt = receiptController.receiptList[index];
        final etaDateTime = DateTime.parse(receipt.ta);
        final now = DateTime.now();
        final etaElapsed = now.isAfter(etaDateTime);

        return ListTile(
          title: customtext(
            label: 'ID: ${receipt.rec_id}',
            labelFontsize: 16,
            labelColor: greenColor,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customtext(
                label: 'ETA: ${receipt.ta}',
                labelFontsize: 16,
                labelColor: whiteColor,
              ),
              customtext(
                label: etaElapsed ? 'Status: Completed' : 'Status: Active',
                labelFontsize: 16,
                labelColor: etaElapsed ? greenColor : Colors.red,
              ),
            ],
          ),
          trailing: etaElapsed
              ? null
              : IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => _showCancelConfirmationDialog(context, receipt.rec_id),
          ),
        );
      },
    ));
  }

  Future<void> getReceipts() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "http://acs314flutter.xyz/dylan_students/get_receipt.php?email=${loginController.email.value}"));

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      var productResponse = serverResponse['receipts'];
      var receiptList =
      <TransactionModel>[]; // Create an empty list of TransactionModel

      for (var receiptJson in productResponse) {
        // Convert each JSON object to a TransactionModel object
        var receipt = TransactionModel.fromJSON(receiptJson);
        receiptList.add(receipt); // Add the converted TransactionModel to the list
      }

      // Update the receipt list in the controller
      receiptController.updateReceiptList(receiptList);
    } else {
      print("Error occurred");
    }
  }

  Future<void> cancelReceipt(String receiptId) async {
    http.Response response;
    var body = {'receipt_id': receiptId};

    response = await http.post(
      Uri.parse(
          "http://acs314flutter.xyz/dylan_students/cancel.php"),
      body: body,
    );

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      int canceled = serverResponse['success'];
      if (canceled == 1) {
        print("Receipt $receiptId canceled successfully");
        receiptController.removeReceipt(receiptId);
      } else {
        print("Failed to cancel receipt $receiptId");
      }
    } else {
      print("Error occurred while canceling receipt $receiptId");
    }
  }

  Future<double> getTotalAmountSpent() async {
    double totalAmount = 0;

    http.Response response;
    response = await http.get(Uri.parse(
        "http://acs314flutter.xyz/dylan_students/get_receipt.php?email=${loginController.email.value}"));

    if (response.statusCode == 200) {
      var serverResponse = json.decode(response.body);
      var productResponse = serverResponse['receipts'];

      for (var receiptJson in productResponse) {
        // Assuming there's a key 'amount' in each receipt JSON object
        var amount = double.parse(receiptJson['amount']);
        totalAmount += amount;
      }
    } else {
      print("Error occurred");
    }

    return totalAmount;
  }

  Future<int> getTotalItemsBought() async {
    int totalItems = 0;

    try {
      http.Response response = await http.get(Uri.parse(
          "http://acs314flutter.xyz/dylan_students/get_total_orders.php?email=${loginController.email.value}"));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse.containsKey('count')) {
          totalItems = int.parse(serverResponse['count']);
        } else {
          print("Key 'count' not found in response");
        }
      } else {
        print("Failed to get total items bought. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error occurred: $error");
    }

    return totalItems;
  }


  Future<void> _showCancelConfirmationDialog(BuildContext context, String receiptId) async {
    bool? confirmed = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss dialog and return false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss dialog and return true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      await cancelReceipt(receiptId);

      // Show SnackBar directly using GlobalKey
      final scaffoldKey = ScaffoldMessenger.of(context);
      scaffoldKey.showSnackBar(
        SnackBar(
          content: Text('Order $receiptId canceled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

}

