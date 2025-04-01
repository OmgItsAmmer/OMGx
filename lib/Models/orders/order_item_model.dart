class OrderItemModel {
  final int quantity;
  final double price;
  final int variantId;
  final String unit;
  final int? orderId;
  final String? variantName;
  final String? image;

  OrderItemModel({
    required this.quantity,
    required this.price,
    required this.variantId,
    required this.unit,
    this.orderId,
    this.variantName,
    this.image,
  });

  // Static function to create an empty order item model
  static OrderItemModel empty() => OrderItemModel(
    quantity: 0,
    price: 0.0,
    variantId: 0,
    unit: "",
    orderId: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'price': price,
      'variant_id': variantId,
      'order_id': orderId,
      'unit': unit,
      'variationDescription': variantName,
      'variant_image': image,
    };
  }

  // Factory method to create an OrderItemModel from Supabase response
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productVariants = json['product_variants'] as Map<String, dynamic>?;

    return OrderItemModel(
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      variantId: json['variant_id'] as int,
      orderId: json['order_id'] as int?,
      unit: json['unit'] as String,
      variantName:
      productVariants != null ? productVariants['variant_name'] as String? : null,
      image: productVariants != null ? productVariants['variant_image'] as String? : null,
    );
  }

  static List<OrderItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderItemModel.fromJson(json)).toList();
  }
}

class OrderModel {
  final int orderId;
  final String orderDate;
  final double totalPrice;
  final String status;
  final String? saletype;
  final int? addressId;
  final int? userId;
  final int? salesmanId;
  final double? paidAmount;
  final int? customerId;
  final double? buyingPrice; // New field
  List<OrderItemModel>? orderItems;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    this.saletype,
    this.addressId,
    this.userId,
    this.salesmanId,
    this.paidAmount,
    this.customerId,
    this.buyingPrice,
    this.orderItems,
  });

  // Static function to create an empty order model
  static OrderModel empty() => OrderModel(
    orderId: 0,
    orderDate: DateTime.now().toIso8601String(),
    totalPrice: 0.0,
    status: "",
    saletype: "",
    addressId: null,
    userId: null,
    salesmanId: null,
    paidAmount: null,
    customerId: null,
    buyingPrice: null,
    orderItems: [],
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'order_date': orderDate,
      'total_price': totalPrice,
      'status': status,
      'saletype': saletype,
      'address_id': addressId,
      'user_id': userId,
      'salesman_id': salesmanId,
      'paid_amount': paidAmount,
      'customer_id': customerId,
      'buying_price': buyingPrice,
    };

    if (!isUpdate) {
      data['order_id'] = orderId;
    }

    return data;
  }

  // Factory method to create an OrderModel from Supabase response
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // ✅ **Keeping your original orderDate logic**
    DateTime fullDate = DateTime.parse(json['order_date']);
    String formattedDate =
        "${fullDate.year.toString().padLeft(4, '0')}-${fullDate.month.toString().padLeft(2, '0')}-${fullDate.day.toString().padLeft(2, '0')}";

    return OrderModel(
      orderId: json['order_id'] as int,
      orderDate: formattedDate, // ✅ **Unchanged orderDate logic**
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      saletype: json['saletype'] as String?,
      addressId: json['address_id'] as int?,
      userId: json['user_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      customerId: json['customer_id'] as int?,
      buyingPrice: (json['buying_price'] as num?)?.toDouble(), // ✅ **New field handled properly**
      orderItems: json['order_items'] != null
          ? OrderItemModel.fromJsonList(json['order_items'] as List)
          : null,
    );
  }
}
