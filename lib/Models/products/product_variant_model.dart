class ProductVariantModel {
  final int? variantId;
  final int productId;
  final String variantName;
  final double buyPrice;
  final double sellPrice;
  final bool isVisible;
  final String sku;
  final int stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariantModel({
    this.variantId,
    required this.productId,
    required this.variantName,
    required this.buyPrice,
    required this.sellPrice,
    this.isVisible = true,
    required this.sku,
    this.stock = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variant_id'],
      productId: json['product_id'],
      variantName: json['variant_name'] ?? '',
      buyPrice: (json['buy_price'] is String)
          ? double.tryParse(json['buy_price']) ?? 0.0
          : (json['buy_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sell_price'] is String)
          ? double.tryParse(json['sell_price']) ?? 0.0
          : (json['sell_price'] as num?)?.toDouble() ?? 0.0,
      isVisible: json['is_visible'] ?? true,
      sku: json['sku'] ?? '',
      stock: json['stock'] ?? 0,
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
      'variant_name': variantName,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'is_visible': isVisible,
      'sku': sku,
      'stock': stock,
    };

    if (variantId != null && isUpdate) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  ProductVariantModel copyWith({
    int? variantId,
    int? productId,
    String? variantName,
    double? buyPrice,
    double? sellPrice,
    bool? isVisible,
    String? sku,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariantModel(
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      variantName: variantName ?? this.variantName,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      isVisible: isVisible ?? this.isVisible,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ProductVariantModel empty() {
    return ProductVariantModel(
      variantId: null,
      productId: -1,
      variantName: '',
      buyPrice: 0.0,
      sellPrice: 0.0,
      isVisible: true,
      sku: '',
      stock: 0,
    );
  }

  @override
  String toString() {
    return 'ProductVariantModel(variantId: $variantId, productId: $productId, variantName: $variantName, buyPrice: $buyPrice, sellPrice: $sellPrice, isVisible: $isVisible, sku: $sku, stock: $stock)';
  }
}
