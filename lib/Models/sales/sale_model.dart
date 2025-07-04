import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class SaleModel {
  final int productId;
  final String name;
  final String salePrice;
  final double buyPrice; // Changed to double
  final String unit;
  final String quantity;
  final String totalPrice;
  final int? variantId; // New field for serialized products

  SaleModel({
    required this.productId,
    required this.name,
    required this.salePrice,
    required this.buyPrice, // Updated type
    required this.unit,
    required this.quantity,
    required this.totalPrice,
    this.variantId, // Optional parameter for variant_id
  });

  // Static function to create an empty sale model
  static SaleModel empty() => SaleModel(
        productId: 0,
        name: "",
        salePrice: "",
        buyPrice: 0.0, // Default value for double
        unit: "",
        quantity: "",
        totalPrice: "",
        variantId: null,
      );

  // Convert model to JSON for database insertion or network requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'name': name,
      'sale_price': salePrice,
      'buy_price': buyPrice, // Double value
      'unit': unit,
      'quantity': quantity,
      'total_price': totalPrice,
    };

    // Only include variantId if it's not null
    if (variantId != null) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  // Factory method to create a SaleModel from a JSON object
  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      salePrice: json['sale_price'] as String? ?? "",
      buyPrice: (json['buy_price'] as num?)?.toDouble() ??
          0.0, // Convert to double safely
      unit: json['unit'] as String? ?? "",
      quantity: json['quantity'] as String? ?? "",
      totalPrice: json['total_price'] as String? ?? "",
      variantId: json['variant_id'] as int?,
    );
  }
}
