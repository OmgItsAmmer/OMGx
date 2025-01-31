// import 'order_item_model.dart';
//
// class OrderModel {
//   final int orderId;
//   final DateTime orderDate;
//   final double totalPrice;
//   final String status;
//   final String saletype;
//   final int? addressId;
//   final int? userId;
//   final int? salesmanId;
//   final double? paidAmount;
//   final int? customerId;
//   final List<OrderItemModel>? orderItems; // To include related order items
//
//   OrderModel({
//     required this.orderId,
//     required this.orderDate,
//     required this.totalPrice,
//     required this.status,
//     required this.saletype,
//     this.addressId,
//     this.userId,
//     this.salesmanId,
//     this.paidAmount,
//     this.customerId,
//     this.orderItems,
//   });
//
//   // Static function to create an empty order model
//   static OrderModel empty() => OrderModel(
//     orderId: 0,
//     orderDate: DateTime.now(), // Default to current time
//     totalPrice: 0.0, // Default to 0 for total price
//     status: "", // Default to an empty string
//     saletype: "", // Default to an empty string
//     addressId: null, // Optional field remains null
//     userId: null, // Optional field remains null
//     salesmanId: null, // Optional field remains null
//     paidAmount: null, // Optional field remains null
//     customerId: null, // Optional field remains null
//     orderItems: [], // Initialize with an empty list
//   );
//
//   // Convert model to JSON for database insertion
//   Map<String, dynamic> toJson() {
//     return {
//       'order_id': orderId,
//       'order_date': orderDate.toIso8601String(),
//       'total_price': totalPrice,
//       'status': status,
//       'saletype': saletype,
//       'address_id': addressId,
//       'user_id': userId,
//       'salesman_id': salesmanId,
//       'paid_amount': paidAmount,
//       'customer_id': customerId,
//     };
//   }
//
//   // Factory method to create an OrderModel from Supabase response
//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       orderId: json['order_id'] as int,
//       orderDate: DateTime.parse(json['order_date']),
//       totalPrice: (json['total_price'] as num).toDouble(),
//       status: json['status'] as String,
//       saletype: json['saletype'] as String,
//       addressId: json['address_id'] as int?,
//       userId: json['user_id'] as int?,
//       salesmanId: json['salesman_id'] as int?,
//       paidAmount: (json['paid_amount'] as num?)?.toDouble(),
//       customerId: json['customer_id'] as int?,
//       orderItems: json['order_items'] != null
//           ? OrderItemModel.fromJsonList(json['order_items'] as List)
//           : null,
//     );
//   }
// }
