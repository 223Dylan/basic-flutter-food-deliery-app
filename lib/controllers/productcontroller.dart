import 'package:get/get.dart';

import '../views/itemcontainer.dart';



class ProductController extends GetxController {
  RxList<FoodItem> productList = <FoodItem>[].obs;
  updateProductList(List<FoodItem> list) {
    productList.assignAll(list);
  }
}
