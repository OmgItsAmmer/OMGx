class VariantBatchesModel {
  final int? variantId;
  final int quantity;
  final int availableQuantity;
  final double buyPrice;
  final double sellPrice;
  final String? vendor;
  final DateTime? purchaseDate;
  final String batchId;

  VariantBatchesModel({
    this.variantId,
    required this.quantity,
    required this.availableQuantity,
    required this.buyPrice,
    required this.sellPrice,
    this.vendor,
    this.purchaseDate,
    required this.batchId,
  });

  // Add a getter to determine if the variant batch is sold
  bool get isSold => availableQuantity == 0;

  factory VariantBatchesModel.fromJson(Map<String, dynamic> json) {
    return VariantBatchesModel(
      variantId: json['variant_id'],
      quantity: json['quantity'],
      availableQuantity: json['available_quantity'],
      buyPrice: (json['buy_price'] is String)
          ? double.tryParse(json['buy_price']) ?? 0.0
          : (json['buy_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sell_price'] is String)
          ? double.tryParse(json['sell_price']) ?? 0.0
          : (json['sell_price'] as num?)?.toDouble() ?? 0.0,
      vendor: json['vendor'],
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'])
          : null,
      batchId: json['batch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variant_id': variantId,
      'quantity': quantity,
      'available_quantity': availableQuantity,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'vendor': vendor,
      'purchase_date': purchaseDate?.toIso8601String(),
      'batch_id': batchId,
    };
  }

  VariantBatchesModel copyWith({
    int? variantId,
    int? quantity,
    int? availableQuantity,
    double? buyPrice,
    double? sellPrice,
    String? vendor,
    DateTime? purchaseDate,
    String? batchId,
  }) {
    return VariantBatchesModel(
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      vendor: vendor ?? this.vendor,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      batchId: batchId ?? this.batchId,
    );
  }

  static VariantBatchesModel empty() {
    return VariantBatchesModel(
      variantId: -1,
      quantity: 0,
      availableQuantity: 0,
      buyPrice: 0.0,
      sellPrice: 0.0,
      vendor: null,
      purchaseDate: null,
      batchId: '',
    );
  }

  @override
  String toString() {
    return 'VariantBatchesModel(variantId: $variantId, quantity: $quantity, availableQuantity: $availableQuantity, buyPrice: $buyPrice, sellPrice: $sellPrice, vendor: $vendor, purchaseDate: $purchaseDate, batchId: $batchId)';
  }
}
