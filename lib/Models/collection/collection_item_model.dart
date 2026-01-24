class CollectionItemModel {
  final int collectionItemId;
  final int collectionId;
  final int variantId;
  final int defaultQuantity;
  final int sortOrder;
  final DateTime? createdAt;

  // Additional fields for display (from joins)
  final String? productName;
  final String? variantName;
  final int? sellPrice;
  final int? stock;
  final String? imageUrl;
  final int? productId;

  CollectionItemModel({
    required this.collectionItemId,
    required this.collectionId,
    required this.variantId,
    required this.defaultQuantity,
    required this.sortOrder,
    this.createdAt,
    this.productName,
    this.variantName,
    this.sellPrice,
    this.stock,
    this.imageUrl,
    this.productId,
  });

  factory CollectionItemModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return CollectionItemModel(
      collectionItemId: toInt(json['collection_item_id']) ?? 0,
      collectionId: toInt(json['collection_id']) ?? 0,
      variantId: toInt(json['variant_id']) ?? 0,
      defaultQuantity: toInt(json['default_quantity']) ?? 1,
      sortOrder: toInt(json['sort_order']) ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      productName: json['product_name'],
      variantName: json['variant_name'],
      sellPrice: toInt(json['sell_price']),
      stock: toInt(json['stock']),
      imageUrl: json['image_url'],
      productId: toInt(json['product_id']),
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> json = {
      'collection_id': collectionId,
      'variant_id': variantId,
      'default_quantity': defaultQuantity,
      'sort_order': sortOrder,
    };

    if (!isUpdate) {
      json['collection_item_id'] = collectionItemId;
      json['created_at'] = createdAt?.toIso8601String();
    }

    return json;
  }

  CollectionItemModel copyWith({
    int? collectionItemId,
    int? collectionId,
    int? variantId,
    int? defaultQuantity,
    int? sortOrder,
    DateTime? createdAt,
    String? productName,
    String? variantName,
    int? sellPrice,
    int? stock,
    String? imageUrl,
    int? productId,
  }) {
    return CollectionItemModel(
      collectionItemId: collectionItemId ?? this.collectionItemId,
      collectionId: collectionId ?? this.collectionId,
      variantId: variantId ?? this.variantId,
      defaultQuantity: defaultQuantity ?? this.defaultQuantity,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      sellPrice: sellPrice ?? this.sellPrice,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      productId: productId ?? this.productId,
    );
  }

  static CollectionItemModel empty() {
    return CollectionItemModel(
      collectionItemId: -1,
      collectionId: -1,
      variantId: -1,
      defaultQuantity: 1,
      sortOrder: 0,
    );
  }
}
