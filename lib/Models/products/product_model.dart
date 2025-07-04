import 'package:ecommerce_dashboard/Models/products/variant_model.dart';

class ProductModel {
  int? productId;
  String name;
  String? description;
  String? basePrice;
  String? salePrice;
  int? categoryId;
  int? stockQuantity;
  DateTime? createdAt;
  int? brandID;
  int? alertStock;
  bool hasSerialNumbers;

  ProductModel({
    this.productId,
    required this.name,
    this.description,
    this.basePrice,
    this.salePrice,
    this.categoryId,
    this.stockQuantity,
    this.createdAt,
    this.brandID,
    this.alertStock,
    this.hasSerialNumbers = false,
  });

  // Static function to create an empty product model
  static ProductModel empty() => ProductModel(
        productId: null,
        name: "",
        description: "",
        basePrice: "",
        salePrice: "",
        categoryId: null,
        stockQuantity: 0,
        createdAt: null,
        brandID: null,
        alertStock: null,
        hasSerialNumbers: false,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false, bool isSerial = false}) {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description ?? "",
      'base_price': basePrice ?? "",
      'sale_price': salePrice ?? "",
      'category_id': categoryId,
      if (!isSerial) 'stock_quantity': stockQuantity,
      'brandID': brandID,
      'alert_stock': alertStock,
      'has_serial_numbers': hasSerialNumbers,
    };

    if (isUpdate && productId != null) {
      data['product_id'] = productId; // Include product_id for update
    }

    return data;
  }

  // Factory method to create a ProductModel from Supabase response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String? ?? "",
      basePrice: json['base_price'] as String? ?? "",
      salePrice: json['sale_price'] as String? ?? "",
      categoryId: json['category_id'] as int?,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      brandID: json['brandID'] as int?,
      alertStock: json['alert_stock'] as int?,
      hasSerialNumbers: json['has_serial_numbers'] as bool? ?? false,
    );
  }

  // CopyWith method
  ProductModel copyWith({
    int? productId,
    String? name,
    String? description,
    String? basePrice,
    String? salePrice,
    int? categoryId,
    int? stockQuantity,
    DateTime? createdAt,
    int? brandID,
    int? alertStock,
    bool? hasSerialNumbers,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      salePrice: salePrice ?? this.salePrice,
      categoryId: categoryId ?? this.categoryId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      brandID: brandID ?? this.brandID,
      alertStock: alertStock ?? this.alertStock,
      hasSerialNumbers: hasSerialNumbers ?? this.hasSerialNumbers,
    );
  }
}
