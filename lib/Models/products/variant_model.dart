class ProductVariantModel {
  final String color;
  final String size;
  final String price;
  final int productId;
  final String? calories;
  final String variationDescription;
  final String stockQuantity;
  final int variantId;
  final String variantImage;

  ProductVariantModel({
    required this.color,
    required this.size,
    required this.price,
    required this.productId,
    this.calories,
    required this.variationDescription,
    required this.stockQuantity,
    required this.variantId,
    required this.variantImage,
  });

  // Static function to create an empty variant model
  static ProductVariantModel empty() => ProductVariantModel(
    color: "",
    size: "",
    price: "",
    productId: 0,
    calories: null,
    variationDescription: "",
    stockQuantity: "0",
    variantId: 0,
    variantImage: "",
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'size': size,
      'price': price,
      'product_id': productId,
      'calories': calories,
      'variationDescription': variationDescription,
      'stock_quantity': stockQuantity,
      'variant_id': variantId,
      'variant_image': variantImage,
    };
  }

  // Factory method to create a ProductVariantModel from Supabase response
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      color: json['color'] as String,
      size: json['size'] as String,
      price: json['price'] as String? ?? "",
      productId: json['product_id'] as int,
      calories: json['calories'] as String?,
      variationDescription: json['variationDescription'] as String? ?? "",
      stockQuantity: json['stock_quantity'] as String? ?? "0",
      variantId: json['variant_id'] as int,
      variantImage: json['variant_image'] as String? ?? "",
    );
  }

  // Factory method to create a list of ProductVariantModels from Supabase response
  static List<ProductVariantModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductVariantModel.fromJson(json)).toList();
  }
}