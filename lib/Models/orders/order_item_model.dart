class OrderItemModel {
  final int productId;
  final double price;
  final int quantity;
  final int orderId;
  final String? unit;
  final double? totalBuyPrice;
  final DateTime? createdAt;
  final int? variantId;

  OrderItemModel({
    required this.productId,
    required this.price,
    required this.quantity,
    required this.orderId,
    this.unit,
    this.totalBuyPrice,
    this.createdAt,
    this.variantId,
  });

  // Static function to create an empty order item model
  static OrderItemModel empty() => OrderItemModel(
        productId: 0,
        price: 0.0,
        quantity: 0,
        orderId: 0,
        unit: null,
        totalBuyPrice: 0.0,
        createdAt: DateTime.now(),
        variantId: null,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'order_id': orderId,
      'unit': unit,
      'total_buy_price': totalBuyPrice,
    };

    if (variantId != null) {
      data['variant_id'] = variantId;
    }

    return data;
  }

  // Factory method to create an OrderItemModel from JSON response
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] as int,
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'] as int,
      orderId: json['order_id'] as int,
      unit: json['unit'] as String?,
      totalBuyPrice: json['total_buy_price'] != null
          ? (json['total_buy_price'] is num)
              ? (json['total_buy_price'] as num).toDouble()
              : double.tryParse(json['total_buy_price'].toString()) ?? 0.0
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      variantId: json['variant_id'] as int?,
    );
  }

  // Method to handle a list of OrderItemModel from JSON
  static List<OrderItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderItemModel.fromJson(json)).toList();
  }

  // CopyWith method
  OrderItemModel copyWith({
    int? productId,
    double? price,
    int? quantity,
    int? orderId,
    String? unit,
    double? totalBuyPrice,
    DateTime? createdAt,
    int? variantId,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      orderId: orderId ?? this.orderId,
      unit: unit ?? this.unit,
      totalBuyPrice: totalBuyPrice ?? this.totalBuyPrice,
      createdAt: createdAt ?? this.createdAt,
      variantId: variantId ?? this.variantId,
    );
  }
}

class OrderModel {
  final int orderId;
  final String orderDate;
  final double subTotal;
  final String status;
  final String? shippingMethod;
  final String? saletype;
  final int? addressId;
  final int? userId;
  final int? customerId;
  final double? paidAmount;
  final double? buyingPrice;
  final double discount;
  final double tax;
  final double shippingFee;
  final String? idempotencyKey;
  final String paymentMethod;
  final int? salesmanId; // not in DB schema
  final int? salesmanComission; // not in DB schema
  List<OrderItemModel>? orderItems;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.subTotal,
    required this.status,
    this.shippingMethod,
    this.saletype,
    this.addressId,
    this.userId,
    this.customerId,
    this.paidAmount,
    this.buyingPrice,
    this.discount = 0.0,
    this.tax = 0.0,
    this.shippingFee = 0.0,
    this.idempotencyKey,
    this.paymentMethod = 'cod',
    this.salesmanId,
    this.salesmanComission = 0,
    this.orderItems,
  });

  static OrderModel empty() => OrderModel(
        orderId: 0,
        orderDate: DateTime.now().toIso8601String(),
        subTotal: 0.0,
        status: "pending",
        shippingMethod: null,
        saletype: null,
        addressId: null,
        userId: null,
        customerId: null,
        paidAmount: null,
        buyingPrice: null,
        discount: 0.0,
        tax: 0.0,
        shippingFee: 0.0,
        idempotencyKey: null,
        paymentMethod: 'cod',
        salesmanId: null,
        salesmanComission: 0,
        orderItems: [],
      );

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = {
      'order_date': orderDate,
      'sub_total': subTotal,
      'status': status,
      'shipping_method': shippingMethod,
      'saletype': saletype,
      'address_id': addressId,
      'user_id': userId,
      'customer_id': customerId,
      'paid_amount': paidAmount,
      'buying_price': buyingPrice,
      'discount': discount,
      'tax': tax,
      'shipping_fee': shippingFee,
      'idempotency_key': idempotencyKey,
      'payment_method': paymentMethod,
      // Optional: include these only if your Supabase accepts them
      // 'salesman_id': salesmanId,
      // 'salesman_comission': salesmanComission,
    };

    if (!isUpdate) {
      data['order_id'] = orderId;
    }

    return data;
  }

  static double _asDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }

  static double? _asNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String _formatOrderDate(dynamic value) {
    if (value == null) {
      final now = DateTime.now();
      return '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
    }
    try {
      final parsed = DateTime.parse(value.toString());
      return '${parsed.year.toString().padLeft(4, '0')}-'
          '${parsed.month.toString().padLeft(2, '0')}-'
          '${parsed.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return value.toString();
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: _asNullableInt(json['order_id']) ?? 0,
      orderDate: _formatOrderDate(json['order_date']),
      subTotal: _asDouble(json['sub_total']),
      status: _asString(json['status']) ?? 'pending',
      shippingMethod: _asString(json['shipping_method']),
      saletype: _asString(json['saletype']),
      addressId: _asNullableInt(json['address_id']),
      userId: _asNullableInt(json['user_id']),
      customerId: _asNullableInt(json['customer_id']),
      paidAmount: _asNullableDouble(json['paid_amount']),
      buyingPrice: _asNullableDouble(json['buying_price']),
      discount: _asDouble(json['discount']),
      tax: _asDouble(json['tax']),
      shippingFee: _asDouble(json['shipping_fee']),
      idempotencyKey: _asString(json['idempotency_key']),
      paymentMethod: _asString(json['payment_method']) ?? 'cod',
      salesmanId: _asNullableInt(json['salesman_id']),
      salesmanComission: _asNullableInt(json['salesman_comission']) ?? 0,
      orderItems: json['order_items'] != null
          ? OrderItemModel.fromJsonList(json['order_items'] as List)
          : null,
    );
  }

  OrderModel copyWith({
    int? orderId,
    String? orderDate,
    double? subTotal,
    String? status,
    String? shippingMethod,
    String? saletype,
    int? addressId,
    int? userId,
    int? customerId,
    double? paidAmount,
    double? buyingPrice,
    double? discount,
    double? tax,
    double? shippingFee,
    String? idempotencyKey,
    String? paymentMethod,
    int? salesmanId,
    int? salesmanComission,
    List<OrderItemModel>? orderItems,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      subTotal: subTotal ?? this.subTotal,
      status: status ?? this.status,
      shippingMethod: shippingMethod ?? this.shippingMethod,
        saletype: saletype ?? this.saletype,
      addressId: addressId ?? this.addressId,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      paidAmount: paidAmount ?? this.paidAmount,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shippingFee: shippingFee ?? this.shippingFee,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      salesmanId: salesmanId ?? this.salesmanId,
      salesmanComission: salesmanComission ?? this.salesmanComission,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}
