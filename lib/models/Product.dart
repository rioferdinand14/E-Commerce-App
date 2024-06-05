import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://192.168.238.143/yonsei/api.php'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}


class Product {
  final String id;
  final String images;
  // final List<Color> colors;
  final String title;
  final String price;
  // final String description;
  // final double rating;
  // final bool isFavourite;
  //  bool isPopular = true;

  Product({
    required this.id,
    required this.images,
    // required this.colors,
    required this.title,
    required this.price,
    // required this.description,
    // this.rating = 0.0,
    // this.isFavourite = false,
    // this.isPopular = true
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_produk'],
      title: json['nama_produk'],
      price: json['harga_produk'],
      images: json['img']
      // Map other properties from JSON here
    );
  }
}

