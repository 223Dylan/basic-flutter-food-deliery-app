import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxString selectedCategory = "Burgers".obs;

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
}
