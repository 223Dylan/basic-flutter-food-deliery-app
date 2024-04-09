import 'package:flutter/material.dart';
import 'package:flutter_attempt_1/configs/constants.dart';
import 'package:flutter_attempt_1/controllers/cartegorycontroller.dart';
import 'package:get/get.dart';
CategoryController categoryController = Get.put(CategoryController());
class CategoryListItem extends StatelessWidget {
  final IconData categoryIcon;
  final String categoryName;
  final int availability;
  final bool selected;
  final Function() onTap;

  const CategoryListItem({
    Key? key,
    required this.categoryIcon,
    required this.categoryName,
    required this.availability,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 30),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: selected ? greenColor : greyWhiteColor,
          border: Border.all(color: selected ? greenColor : greyWhiteColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1.5),
              ),
              child: Icon(categoryIcon, color: blackColor, size: 30),
            ),
            SizedBox(height: 10),
            Text(
              categoryName,
              style: TextStyle(fontWeight: FontWeight.w700, color: whiteColor),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 1.5,
              height: 15,
              color: blackColor,
            ),
            Text(
              availability.toString(),
              style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor),
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 181,
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryListItem(
            categoryIcon: Icons.bug_report,
            categoryName: "Burgers",
            availability: 5,
            selected: categoryController.selectedCategory.value == "Burgers",
            onTap: () {
              categoryController.setSelectedCategory("Burgers");
            },
          ),
          CategoryListItem(
            categoryIcon: Icons.bug_report,
            categoryName: "Pizza",
            availability: 5,
            selected: categoryController.selectedCategory.value == "Pizza",
            onTap: () {
              categoryController.setSelectedCategory("Pizza");
            },
          ),
          CategoryListItem(
            categoryIcon: Icons.bug_report,
            categoryName: "Sandwich",
            availability: 5,
            selected: categoryController.selectedCategory.value == "Sandwich",
            onTap: () {
              categoryController.setSelectedCategory("Sandwich");
            },
          ),
          CategoryListItem(
            categoryIcon: Icons.bug_report,
            categoryName: "Misc",
            availability: 3,
            selected: categoryController.selectedCategory.value == "Misc",
            onTap: () {
              categoryController.setSelectedCategory("Misc");
            },
          ),
          // Add more CategoryListItems here
        ],
      )),
    );
  }
}
