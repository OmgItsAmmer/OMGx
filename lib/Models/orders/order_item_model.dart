class OrderItemModel {
  final int quantity;
  final double price;
  final int variantId;
  final int? orderId;

  OrderItemModel({
    required this.quantity,
    required this.price,
    required this.variantId,
    this.orderId,
  });

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'price': price,
      'variant_id': variantId,
      'order_id': orderId,
    };
  }

  // Factory method to create an OrderItemModel from Supabase response
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      variantId: json['variant_id'] as int,
      orderId: json['order_id'] as int?,
    );
  }

  static List<OrderItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderItemModel.fromJson(json)).toList();
  }
}
