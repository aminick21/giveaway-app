import 'package:give_away/models/location_model.dart';

class ProductModel{

  final String id;
  final String title;
  final String category;
  final int productAge;
  final String imageUrl;
  final String uid;
  final String condition;
  final String productDescription;
  final LocationModel location;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.productAge,
    required this.imageUrl,
    required this.uid,
    required this.condition,
    required this.productDescription,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'category': this.category,
      'productAge': this.productAge,
      'imageUrl': this.imageUrl,
      'uid': this.uid,
      'condition': this.condition,
      'productDescription': this.productDescription,
      'location': this.location,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      productAge: map['productAge'] as int,
      imageUrl: map['imageUrl'] as String,
      uid: map['userId'] as String,
      condition: map['condition'] as String,
      productDescription: map['productDescription'] as String,
      location:LocationModel.fromMap(map['location']),
    );
  }


}