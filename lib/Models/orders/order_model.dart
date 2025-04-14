import 'order_item_model.dart';

class OrderModel {
  final int orderId;
  final DateTime orderDate;
  final double totalPrice;
  final String status;
  final String? saletype;
  final int? addressId;
  final int? userId;
  final int? salesmanId;
  final double? paidAmount;
  final int? customerId;
  final double? buyingPrice;
  final double discount;
  final double tax;
  final double shippingFee;
  final int salesmanComission;
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
    this.discount = 0.0,
    this.tax = 0.0,
    this.shippingFee = 0.0,
    this.salesmanComission = 0,
    this.orderItems,
  });

  // Static function to create an empty order model
  static OrderModel empty() => OrderModel(
        orderId: 0,
        orderDate: DateTime.now(),
        totalPrice: 0.0,
        status: "",
        saletype: "",
        addressId: null,
        userId: null,
        salesmanId: null,
        paidAmount: null,
        customerId: null,
        buyingPrice: null,
        discount: 0.0,
        tax: 0.0,
        shippingFee: 0.0,
        salesmanComission: 0,
        orderItems: [],
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'order_date': orderDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'saletype': saletype,
      'address_id': addressId,
      'user_id': userId,
      'salesman_id': salesmanId,
      'paid_amount': paidAmount,
      'customer_id': customerId,
      'buying_price': buyingPrice,
      'discount': discount,
      'tax': tax,
      'shipping_fee': shippingFee,
      'salesman_comission': salesmanComission,
    };

    if (!isUpdate) {
      data['order_id'] = orderId;
    }

    return data;
  }

  // Factory method to create an OrderModel from Supabase response
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] as int,
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : DateTime.now(),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      saletype: json['saletype'] as String?,
      addressId: json['address_id'] as int?,
      userId: json['user_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      customerId: json['customer_id'] as int?,
      buyingPrice: (json['buying_price'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0.0,
      salesmanComission: json['salesman_comission'] as int? ?? 0,
      orderItems: json['order_items'] != null
          ? OrderItemModel.fromJsonList(json['order_items'] as List)
          : null,
    );
  }

  // CopyWith method
  OrderModel copyWith({
    int? orderId,
    DateTime? orderDate,
    double? totalPrice,
    String? status,
    String? saletype,
    int? addressId,
    int? userId,
    int? salesmanId,
    double? paidAmount,
    int? customerId,
    double? buyingPrice,
    double? discount,
    double? tax,
    double? shippingFee,
    int? salesmanComission,
    List<OrderItemModel>? orderItems,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      saletype: saletype ?? this.saletype,
      addressId: addressId ?? this.addressId,
      userId: userId ?? this.userId,
      salesmanId: salesmanId ?? this.salesmanId,
      paidAmount: paidAmount ?? this.paidAmount,
      customerId: customerId ?? this.customerId,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shippingFee: shippingFee ?? this.shippingFee,
      salesmanComission: salesmanComission ?? this.salesmanComission,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}
