import 'package:flutter/foundation.dart';

class PurchaseItemModel {
  final int productId;
  final double price;
  final int quantity;
  final int purchaseId;
  final String? unit;
  final DateTime? createdAt;
  final int? variantId;

  PurchaseItemModel({
    required this.productId,
    required this.price,
    required this.quantity,
    required this.purchaseId,
    this.unit,
    this.createdAt,
    this.variantId,
  });

  // Static function to create an empty purchase item model
  static PurchaseItemModel empty() => PurchaseItemModel(
        productId: 0,
        price: 0.0,
        quantity: 0,
        purchaseId: 0,
        unit: null,
        createdAt: null,
        variantId: null,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'purchase_id': purchaseId,
      'unit': unit,
    };

    if (createdAt != null) {
      data['created_at'] = createdAt?.toIso8601String();
    }

    if (variantId != null) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  // Factory method to create an PurchaseItemModel from JSON response
  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    // Handle bigint values that might come as int or String
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return (value as num).toInt();
    }

    int? parseToIntNullable(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return (value as num).toInt();
    }

    if (kDebugMode) {
      print('🔧 [PurchaseItemModel] Parsing JSON:');
      print('   - JSON keys: ${json.keys.toList()}');
      print('   - product_id: ${json['product_id']} (type: ${json['product_id'].runtimeType})');
      print('   - purchase_id: ${json['purchase_id']} (type: ${json['purchase_id'].runtimeType})');
      print('   - variant_id: ${json['variant_id']} (type: ${json['variant_id']?.runtimeType})');
      print('   - price: ${json['price']} (type: ${json['price'].runtimeType})');
      print('   - quantity: ${json['quantity']} (type: ${json['quantity'].runtimeType})');
    }

    try {
      final productId = parseToInt(json['product_id']);
      final purchaseId = parseToInt(json['purchase_id']);
      final quantity = parseToInt(json['quantity']);
      final price = (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0;
      final variantId = parseToIntNullable(json['variant_id']);
      final unit = json['unit'] as String?;
      final createdAt = json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null;

      if (kDebugMode) {
        print('✅ [PurchaseItemModel] Parsed values:');
        print('   - productId: $productId');
        print('   - purchaseId: $purchaseId');
        print('   - quantity: $quantity');
        print('   - price: $price');
        print('   - variantId: $variantId');
        print('   - unit: $unit');
        print('   - createdAt: $createdAt');
      }

      return PurchaseItemModel(
        productId: productId,
        price: price,
        quantity: quantity,
        purchaseId: purchaseId,
        unit: unit,
        createdAt: createdAt,
        variantId: variantId,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ [PurchaseItemModel] Error parsing: $e');
        print('   Stack trace: $stackTrace');
        print('   JSON: $json');
      }
      rethrow;
    }
  }

  // Method to handle a list of PurchaseItemModel from JSON
  static List<PurchaseItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PurchaseItemModel.fromJson(json)).toList();
  }

  // CopyWith method
  PurchaseItemModel copyWith({
    int? productId,
    double? price,
    int? quantity,
    int? purchaseId,
    String? unit,
    DateTime? createdAt,
    int? variantId,
  }) {
    return PurchaseItemModel(
      productId: productId ?? this.productId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      purchaseId: purchaseId ?? this.purchaseId,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      variantId: variantId ?? this.variantId,
    );
  }
}

class PurchaseModel {
  final int purchaseId;
  final String purchaseDate;
  final double subTotal;
  final String status;
  final int? addressId;
  final int? userId;
  final double? paidAmount;
  final int? vendorId;
  final double discount;
  final double tax;
  final double shippingFee;
  List<PurchaseItemModel>? purchaseItems;

  PurchaseModel({
    required this.purchaseId,
    required this.purchaseDate,
    required this.subTotal,
    required this.status,
    this.addressId,
    this.userId,
    this.paidAmount,
    this.vendorId,
    this.discount = 0.0,
    this.tax = 0.0,
    this.shippingFee = 0.0,
    this.purchaseItems,
  });

  // Static function to create an empty purchase model
  static PurchaseModel empty() => PurchaseModel(
        purchaseId: 0,
        purchaseDate: DateTime.now().toIso8601String(),
        subTotal: 0.0,
        status: "",
        addressId: null,
        userId: null,
        paidAmount: null,
        vendorId: null,
        discount: 0.0,
        tax: 0.0,
        shippingFee: 0.0,
        purchaseItems: [],
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'purchase_date': purchaseDate,
      'sub_total': subTotal,
      'status': status,
      'address_id': addressId,
      'user_id': userId,
      'paid_amount': paidAmount,
      'vendor_id': vendorId,
      'discount': discount,
      'tax': tax,
      'shipping_fee': shippingFee,
    };

    if (!isUpdate) {
      data['purchase_id'] = purchaseId;
    }

    return data;
  }

  // Factory method to create a PurchaseModel from Supabase response
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    DateTime fullDate = DateTime.parse(json['purchase_date']);
    String formattedDate =
        "${fullDate.year.toString().padLeft(4, '0')}-${fullDate.month.toString().padLeft(2, '0')}-${fullDate.day.toString().padLeft(2, '0')}";

    return PurchaseModel(
      purchaseId: json['purchase_id'] as int,
      purchaseDate: formattedDate,
      subTotal: (json['sub_total'] as num).toDouble(),
      status: json['status'] as String,
      addressId: json['address_id'] as int?,
      userId: json['user_id'] as int?,
      paidAmount: json['paid_amount'] != null
          ? (json['paid_amount'] as num).toDouble()
          : null,
      vendorId: json['vendor_id'] as int?,
      discount:
          json['discount'] != null ? (json['discount'] as num).toDouble() : 0.0,
      tax: json['tax'] != null ? (json['tax'] as num).toDouble() : 0.0,
      shippingFee: json['shipping_fee'] != null
          ? (json['shipping_fee'] as num).toDouble()
          : 0.0,
    );
  }

  // Method to handle a list of PurchaseModel from JSON
  static List<PurchaseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PurchaseModel.fromJson(json)).toList();
  }

  // CopyWith method for creating modified copies
  PurchaseModel copyWith({
    int? purchaseId,
    String? purchaseDate,
    double? subTotal,
    String? status,
    int? addressId,
    int? userId,
    double? paidAmount,
    int? vendorId,
    double? discount,
    double? tax,
    double? shippingFee,
    List<PurchaseItemModel>? purchaseItems,
  }) {
    return PurchaseModel(
      purchaseId: purchaseId ?? this.purchaseId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      subTotal: subTotal ?? this.subTotal,
      status: status ?? this.status,
      addressId: addressId ?? this.addressId,
      userId: userId ?? this.userId,
      paidAmount: paidAmount ?? this.paidAmount,
      vendorId: vendorId ?? this.vendorId,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shippingFee: shippingFee ?? this.shippingFee,
      purchaseItems: purchaseItems ?? this.purchaseItems,
    );
  }
}


