import 'package:get/get.dart';

class CartController extends GetxController{
  var cartItems = <Map<String, dynamic>>[].obs;
  var postTitle=''.obs;
  var postId=''.obs;
  var postPrice=''.obs;
  var whattheitems=''.obs;
  var itemUrl=''.obs;
  //var postImg=''.obs;
  addTitle(title){
    postTitle.value = title;
  }
  addID(id){
    postId.value = id;
  }
  addPrice(price){
    postPrice.value = price;
  }
  addToCart(title, id, price, imgUrl) {
    var existingItem = cartItems.indexWhere((item) => item['id'] == id);
    if (existingItem != -1) {
      cartItems[existingItem]['quantity'] += 1;
    } else {
      var item = {
        'title': title,
        'id': id,
        'price': price,
        'imgUrl': imgUrl,
        'quantity': 1,
      };
      cartItems.add(item);
    }}
    removeFromCart(id) {
      cartItems.removeWhere((item) => item['id'] == id);
    }
    double calculateTotalPrice() {
      double totalPrice = 0;
      for (var item in cartItems) {
        totalPrice += double.parse(item['price'].toString()) * item['quantity'];
      }
      return totalPrice;
    }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      cartItems.removeAt(index);
    } else {
      cartItems[index]['quantity'] = newQuantity;
    }
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    cartItems.refresh();
  }

  }