import 'package:flutter/foundation.dart';

class ProductVariantModel {
  final int? variantId;
  final int productId;
  final String serialNumber;
  final double purchasePrice;
  final double sellingPrice;
  final bool isSold;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariantModel({
    this.variantId,
    required this.productId,
    required this.serialNumber,
    required this.purchasePrice,
    required this.sellingPrice,
    this.isSold = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variant_id'],
      productId: json['product_id'],
      serialNumber: json['serial_number'] ?? '',
      purchasePrice: (json['purchase_price'] is String)
          ? double.tryParse(json['purchase_price']) ?? 0.0
          : (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['selling_price'] is String)
          ? double.tryParse(json['selling_price']) ?? 0.0
          : (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      isSold: json['is_sold'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'serial_number': serialNumber,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'is_sold': isSold,
    };

    if (variantId != null && isUpdate) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  ProductVariantModel copyWith({
    int? variantId,
    int? productId,
    String? serialNumber,
    double? purchasePrice,
    double? sellingPrice,
    bool? isSold,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariantModel(
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      serialNumber: serialNumber ?? this.serialNumber,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      isSold: isSold ?? this.isSold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ProductVariantModel empty() {
    return ProductVariantModel(
      variantId: null,
      productId: -1,
      serialNumber: '',
      purchasePrice: 0.0,
      sellingPrice: 0.0,
      isSold: false,
    );
  }

  @override
  String toString() {
    return 'ProductVariantModel(variantId: $variantId, productId: $productId, serialNumber: $serialNumber, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, isSold: $isSold)';
  }
}
