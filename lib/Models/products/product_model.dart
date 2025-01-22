import 'package:admin_dashboard_v3/Models/products/variant_model.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final int productId;
  final String name;
  final String description;
  final String basePrice;
  final String thumbnail;
  final String salePrice;
  final int? categoryId;
  final String productType;
  final String brand;
  final bool isPopular;
  final int stockQuantity;
  final DateTime? createdAt;
  final int? brandID;
  final List<ProductVariantModel>? productVariants;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.thumbnail,
    required this.salePrice,
    this.categoryId,
    required this.productType,
    required this.brand,
    required this.isPopular,
    required this.stockQuantity,
    this.createdAt,
    this.brandID,
    this.productVariants,
  });

  // Static function to create an empty product model
  static ProductModel empty() => ProductModel(
    productId: 0,
    name: "",
    description: "",
    basePrice: "",
    thumbnail: "",
    salePrice: "",
    categoryId: null,
    productType: "",
    brand: "",
    isPopular: false,
    stockQuantity: 0,
    createdAt: DateTime.now(),
    brandID: null,
    productVariants: [],
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'thumbnail': thumbnail,
      'sale_price': salePrice,
      'category_id': categoryId,
      'producttype': productType,
      'brand': brand,
      'ispopular': isPopular,
      'stock_quantity': stockQuantity,
      'created_at': createdAt?.toIso8601String(),
      'brandID': brandID,
    };
  }

  // Factory method to create a ProductModel from Supabase response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? "",
      basePrice: json['base_price'] as String? ?? "",
      thumbnail: json['thumbnail'] as String? ?? "",
      salePrice: json['sale_price'] as String? ?? "",
      categoryId: json['category_id'] as int?,
      productType: json['producttype'] as String? ?? "",
      brand: json['brand'] as String? ?? "",
      isPopular: json['ispopular'] as bool? ?? false,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      brandID: json['brandID'] as int?,
      productVariants: json['product_variants'] != null
          ? ProductVariantModel.fromJsonList(json['product_variants'] as List)
          : null,
    );
  }
}