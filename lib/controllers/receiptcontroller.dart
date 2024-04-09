import 'package:get/get.dart';
import 'package:flutter_attempt_1/models/transactionmodel.dart';

class ReceiptController extends GetxController {
  var receiptList = <TransactionModel>[].obs;
  var totalAmountSpent = 0.0.obs;

  void updateReceiptList(List<TransactionModel> newList) {
    receiptList.assignAll(newList);
    _updateTotalAmountSpent();
  }
  void removeReceipt(String receiptId) {
    receiptList.removeWhere((receipt) => receipt.rec_id == receiptId);
    _updateTotalAmountSpent();
  }
  void _updateTotalAmountSpent() {
    totalAmountSpent.value = receiptList.fold(0, (sum, item) => sum + double.parse(item.amount));
  }
}
