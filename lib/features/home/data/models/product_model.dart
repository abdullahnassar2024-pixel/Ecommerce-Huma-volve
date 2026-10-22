
import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';

class ProductModel {
  static Product fromJson(Map<String, dynamic> json) {
    final images = json['images'];

    String imageUrl = '';

    if (images is List && images.isNotEmpty) {
      imageUrl = images.first.toString();
    }

    return Product(
      id: json['id'].toString(),
      name: json['title']?.toString() ?? 'Unknown Product',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: imageUrl,
      colors: [Colors.black, Colors.white, Colors.grey],
      sizes: ['S', 'M', 'L', 'XL'],
      categoryName:
      (json['category'] as Map?)?['name']?.toString() ?? '',
    );
  }
}
