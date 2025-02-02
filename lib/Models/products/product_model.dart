import 'package:admin_dashboard_v3/Models/products/variant_model.dart';

class ProductModel {
  int? productId;
  String? name;
  String? description;
  String? basePrice;
  String? thumbnail;
  String? salePrice;
  int? categoryId;
  String? productType;
  String? brand;
  bool? isPopular;
  int? stockQuantity;
  DateTime? createdAt;
  int? brandID;
  int? alertStock;
  List<ProductVariantModel>? productVariants;

  ProductModel({
    this.productId,
    this.name,
    this.description,
    this.basePrice,
    this.thumbnail,
    this.salePrice,
    this.categoryId,
    this.productType,
    this.brand,
    this.isPopular,
    this.stockQuantity,
    this.createdAt,
    this.brandID,
    this.alertStock,
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
    alertStock: 0,
    productVariants: [],
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name ?? "",
      'description': description ?? "",
      'base_price': basePrice ?? "",
      'thumbnail': thumbnail ?? "",
      'sale_price': salePrice ?? "",
      'category_id': categoryId,
      'producttype': productType ?? "",
      'brand': brand ?? "",
      'ispopular': isPopular ?? false,
      'stock_quantity': stockQuantity ?? 0,
      'created_at': createdAt?.toIso8601String(),
      'brandID': brandID,
      'alert_stock': alertStock,
    };
  }

  // Factory method to create a ProductModel from Supabase response
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int?,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      basePrice: json['base_price'] as String? ?? "",
      thumbnail: json['thumbnail'] as String? ?? "",
      salePrice: json['sale_price'] as String? ?? "",
      categoryId: json['category_id'] as int?,
      productType: json['producttype'] as String? ?? "",
      brand: json['brand'] as String? ?? "",
      isPopular: json['ispopular'] as bool? ?? false,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt:
      json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      brandID: json['brandID'] as int?,
      alertStock: json['alert_stock'] as int?,
      productVariants: json['product_variants'] != null
          ? ProductVariantModel.fromJsonList(json['product_variants'] as List)
          : null,
    );
  }
}
