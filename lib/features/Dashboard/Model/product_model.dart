import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String idProduct;
  final String title;
  final String sellerId;
  String description;
  String imageUrl;
  int price;
  int stock;
  final DateTime createdAt;

  ProductModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.idProduct,
    required this.sellerId,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
      idProduct: id,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      sellerId: json['sellerId'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
     createdAt: (json['createdAt'] as Timestamp).toDate(),

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'idProduct': idProduct,
      'sellerId': sellerId,
      'price': price,
      'stock': stock,
      'createdAt': createdAt,
    };
  }
}
