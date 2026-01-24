
class ProductVariantModel {
  final int? variantId;
  final int productId;
  final String variantName;
  final bool isVisible;
  final String? sku;

  ProductVariantModel({
    this.variantId,
    required this.productId,
    this.variantName = '',
    this.isVisible = false,
    this.sku,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variant_id'],
      productId: json['product_id'],
      variantName: json['variant_name'] ?? '',
      isVisible: json['is_visible'] ?? false,
      sku: json['sku'],
    );
  }

  Map<String, dynamic> toJson({bool isInsert = false}) {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'variant_name': variantName,
      'is_visible': isVisible,
      'sku': sku,
    };

    if (!isInsert) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  ProductVariantModel copyWith({
    int? variantId,
    int? productId,
    String? variantName,
    bool? isVisible,
    String? sku,
  }) {
    return ProductVariantModel(
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      variantName: variantName ?? this.variantName,
      isVisible: isVisible ?? this.isVisible,
      sku: sku ?? this.sku,
    );
  }

  static ProductVariantModel empty() {
    return ProductVariantModel(
      variantId: null,
      productId: -1,
      variantName: '',
      isVisible: false,
      sku: null,
    );
  }

  @override
  String toString() {
    return 'ProductVariantModel(variantId: $variantId, productId: $productId, variantName: $variantName, isVisible: $isVisible, sku: $sku)';
  }
}
