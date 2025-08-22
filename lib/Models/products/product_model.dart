import 'package:ecommerce_dashboard/Models/products/variant_model.dart';
import '../../utils/constants/enums.dart'; // Assuming ProductTag is defined here

class ProductModel {
  int? productId;
  String name;
  String? description;
  String? priceRange;
  String? basePrice;
  String? salePrice;
  int? categoryId;
  int? stockQuantity;
  DateTime? createdAt;
  int? brandID;
  int? alertStock;
  ProductTag? productTag;
  bool? isPopular;
  bool? isVisible;

  ProductModel({
    this.productId,
    required this.name,
    this.description,
    this.priceRange,
    this.basePrice,
    this.salePrice,
    this.categoryId,
    this.stockQuantity,
    this.createdAt,
    this.brandID,
    this.alertStock,
    this.productTag,
    this.isPopular,
    this.isVisible,
  });

  // Static function to create an empty product model
  static ProductModel empty() => ProductModel(
        productId: null,
        name: "",
        description: "",
        priceRange: "",
        basePrice: "",
        salePrice: "",
        categoryId: null,
        stockQuantity: 0,
        createdAt: null,
        brandID: null,
        alertStock: null,
        productTag: null,
        isPopular: false,
        isVisible: false,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description ?? "",
      'price_range': priceRange ?? "",
      'base_price': basePrice ?? "",
      'sale_price': salePrice ?? "",
      'category_id': categoryId,
      'stock_quantity': stockQuantity,
      'brandID': brandID,
      'alert_stock': alertStock,
      'tag': productTag?.name.toUpperCase(), // Convert enum to string
      'ispopular': isPopular,
      'isVisible': isVisible,
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
      priceRange: json['price_range'] as String? ?? "",
      basePrice: json['base_price'] as String? ?? "",
      salePrice: json['sale_price'] as String? ?? "",
      categoryId: json['category_id'] as int?,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      brandID: json['brandID'] as int?,
      alertStock: json['alert_stock'] as int?,
      productTag: json['tag'] != null && json['tag'].toString().isNotEmpty
          ? _parseProductTag(json['tag'].toString())
          : null,
      isPopular: json['ispopular'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? false,
    );
  }

  // CopyWith method
  ProductModel copyWith({
    int? productId,
    String? name,
    String? description,
    String? priceRange,
    String? basePrice,
    String? salePrice,
    int? categoryId,
    int? stockQuantity,
    DateTime? createdAt,
    int? brandID,
    int? alertStock,
    ProductTag? productTag,
    bool? isPopular,
    bool? isVisible,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      priceRange: priceRange ?? this.priceRange,
      basePrice: basePrice ?? this.basePrice,
      salePrice: salePrice ?? this.salePrice,
      categoryId: categoryId ?? this.categoryId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      brandID: brandID ?? this.brandID,
      alertStock: alertStock ?? this.alertStock,
      productTag: productTag ?? this.productTag,
      isPopular: isPopular ?? this.isPopular,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  // Helper method to safely parse ProductTag from string
  static ProductTag? _parseProductTag(String tagString) {
    try {
      return ProductTag.values.firstWhere(
        (e) => e.name.toUpperCase() == tagString.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
