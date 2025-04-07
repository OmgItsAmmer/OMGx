import 'package:flutter/material.dart';

class BrandModel {
  final String? bname;
  final bool isVerified;
  final bool? isFeatured;
  final int brandID;
  final int? productsCount;

  BrandModel({
    this.bname,
    this.isVerified = false,
    this.isFeatured,
    required this.brandID,
    this.productsCount,
  });

  // Static function to create an empty brand model
  static BrandModel empty() => BrandModel(
    brandID: -1,
    bname: null,
    isVerified: false,
    isFeatured: null,
    productsCount: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'bname': bname,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'brandID': brandID,
      'products_count': productsCount,
    };
  }

  // Factory method to create a BrandModel from Supabase response
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      bname: json['bname'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool?,
      brandID: json['brandID'] as int,
      productsCount: json['products_count'] as int?,
    );
  }
}
