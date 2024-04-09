import '../views/itemcontainer.dart';

class ProductModel {
  var id;
  var cartegory;
  var pname;
  var hotel;
  var image_url;
  var price;

  ProductModel({
    required this.id,
    required this.cartegory,
    required this.pname,
    required this.hotel,
    required this.image_url,
    required this.price,
  });

  factory ProductModel.fromJSON(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id'].toString()),
      cartegory: json['cartegory'],
      pname: json['pname'],
      hotel: json['hotel'],
      image_url: json['image_url'],
      price: double.parse(json['price'].toString()),
    );
  }

  FoodItem toFoodItem() {
    return FoodItem(
      id: id,
      title: pname,
      hotel: hotel,
      price: price.toDouble(),
      imgUrl: image_url,
      category: cartegory,
    );
  }
}
