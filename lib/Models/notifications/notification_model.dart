import 'package:get/get.dart';

class NotificationModel {
  final int notificationId;
  final DateTime createdAt;
  final String? description;
  final String? subDescription;
   RxBool isRead;
  final String? notificationType;
  final DateTime? expiresAt;
  final int? orderId;
  final int? installmentPlanId;
  final int? productId; // New field added to match the schema

  NotificationModel({
    required this.notificationId,
    required this.createdAt,
    this.description,
    this.subDescription,
    required this.isRead,
    this.notificationType,
    this.expiresAt,
    this.orderId,
    this.installmentPlanId,
    this.productId, // New field added to match the schema
  });

  // Factory constructor to create an empty notification
  static NotificationModel empty() => NotificationModel(
    notificationId: 0,
    createdAt: DateTime.now(),
    description: null,
    subDescription: null,
    isRead: false.obs, // Default is false, using RxBool
    notificationType: null,
    expiresAt: DateTime.now().add(Duration(days: 10)), // Default 10 days expiry
    orderId: null,
    installmentPlanId: null,
    productId: null, // Default is null
  );

  // Convert model to JSON for database operations
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'created_at': createdAt.toIso8601String(),
      'description': description,
      'sub_description': subDescription,
      'isRead': isRead.value, // Convert RxBool to regular bool
      'NotificationType': notificationType,
      'expires_at': expiresAt?.toIso8601String(),
      'order_id': orderId,
      'installment_plan_id': installmentPlanId,
      'product_id': productId, // Include product_id in the JSON
    };

    if (!isUpdate) {
      data['notification_id'] = notificationId;
    }

    return data;
  }

  // Factory method to create a NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
      subDescription: json['sub_description'] as String?,
      isRead: (json['isRead'] as bool?)?.obs ?? false.obs, // Using RxBool
      notificationType: json['NotificationType'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      orderId: json['order_id'] as int?,
      installmentPlanId: json['installment_plan_id'] as int?,
      productId: json['product_id'] as int?, // Map product_id
    );
  }

  // Method to create a list of NotificationModel from a JSON list
  static List<NotificationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // CopyWith method to create a modified copy of the model
  NotificationModel copyWith({
    int? notificationId,
    DateTime? createdAt,
    String? description,
    String? subDescription,
    RxBool? isRead,
    String? notificationType,
    DateTime? expiresAt,
    int? orderId,
    int? installmentPlanId,
    int? productId,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      subDescription: subDescription ?? this.subDescription,
      isRead: isRead ?? this.isRead,
      notificationType: notificationType ?? this.notificationType,
      expiresAt: expiresAt ?? this.expiresAt,
      orderId: orderId ?? this.orderId,
      installmentPlanId: installmentPlanId ?? this.installmentPlanId,
      productId: productId ?? this.productId,
    );
  }
}
