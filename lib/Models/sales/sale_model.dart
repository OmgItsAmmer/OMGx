import 'package:flutter/material.dart';

class SaleModel {
  final int productId;
  final String name;
  final String salePrice;
  final String unit;
  final String quantity;
  final String totalPrice;

  SaleModel({
    required this.productId,
    required this.name,
    required this.salePrice,
    required this.unit,
    required this.quantity,
    required this.totalPrice,
  });

  // Static function to create an empty sale model
  static SaleModel empty() => SaleModel(
    productId: 0,
    name: "",
    salePrice: "",
    unit: "",
    quantity: "",
    totalPrice: "",
  );

  // Convert model to JSON for database insertion or network requests
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'sale_price': salePrice,
      'unit': unit,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }

  // Factory method to create a SaleModel from a JSON object
  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      salePrice: json['sale_price'] as String? ?? "",
      unit: json['unit'] as String? ?? "",
      quantity: json['quantity'] as String? ?? "",
      totalPrice: json['total_price'] as String? ?? "",
    );
  }
}
