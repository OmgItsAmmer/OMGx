import 'package:flutter/material.dart';

class BrandModel {
  final String? bname;
  final String? logoUrl;
  final bool isVerified;
  final bool? isFeatured;
  final int brandID;
  final int? productsCount;

  BrandModel({
    this.bname,
    this.logoUrl,
    this.isVerified = false,
    this.isFeatured,
    required this.brandID,
    this.productsCount,
  });

  // Static function to create an empty brand model
  static BrandModel empty() => BrandModel(
    bname: null,
    logoUrl: null,
    isVerified: false,
    isFeatured: null,
    brandID: 0,
    productsCount: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'bname': bname,
      'logo_url': logoUrl,
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
      logoUrl: json['logo_url'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool?,
      brandID: json['brandID'] as int,
      productsCount: json['products_count'] as int?,
    );
  }
}