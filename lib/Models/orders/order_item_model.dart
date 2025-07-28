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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle null or malformed date safely
    String formattedDate = DateTime.now().toIso8601String();
    if (json.containsKey('order_date') && json['order_date'] != null) {
      try {
        final parsedDate = DateTime.parse(json['order_date'].toString());
        formattedDate =
            "${parsedDate.year.toString().padLeft(4, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
      } catch (_) {
        // silently fallback
      }
    }

    return OrderModel(
      orderId: json['order_id'] as int? ?? 0,
      orderDate: formattedDate,
      subTotal: (json['sub_total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      saletype: json['saletype'] as String?, // can be null
      addressId: json['address_id'] as int?,
      userId: json['user_id'] as int?, // nullable user_id
      customerId: json['customer_id'] as int?,
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      buyingPrice: (json['buying_price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0.0,
      idempotencyKey: json['idempotency_key'] as String?,
      paymentMethod: json['payment_method'] as String? ?? 'cod',
      salesmanId: json['salesman_id'] as int?, // can be null
      salesmanComission: json['salesman_comission'] as int? ?? 0,
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
