class RecoveryReportModel {
  final int? id; // Nullable, similar to customerId
  final String salesmanName;
  final String salesmanArea;
  final int orderId;
  final String customerName;
  final DateTime orderDate;
  final double salePrice;
  final String orderType;
  final int commissionPercent;
  final double commissionInRs;

  RecoveryReportModel({
    this.id,
    required this.salesmanName,
    required this.salesmanArea,
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.salePrice,
    required this.orderType,
    required this.commissionPercent,
    required this.commissionInRs,
  });

  // Create an empty model
  static RecoveryReportModel empty() => RecoveryReportModel(
    id: null,
    salesmanName: '',
    salesmanArea: '',
    orderId: 0,
    customerName: '',
    orderDate: DateTime.now(),
    salePrice: 0.0,
    orderType: '',
    commissionPercent: 0,
    commissionInRs: 0.0,
  );

  // Convert model to JSON
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = <String, dynamic>{
      'salesman_name': salesmanName,
      'salesman_area': salesmanArea,
      'order_id': orderId,
      'customer_name': customerName,
      'order_date': orderDate.toIso8601String(),
      'sale_price': salePrice,
      'order_type': orderType,
      'commission_percent': commissionPercent,
      'commission_in_rs': commissionInRs,
    };

    if (!isUpdate && id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Factory constructor from JSON
  factory RecoveryReportModel.fromJson(Map<String, dynamic> json) {
    return RecoveryReportModel(
      id: json['id'] as int?,
      salesmanName: json['salesman_name'] ?? '',
      salesmanArea: json['salesman_area'] ?? '',
      orderId: json['order_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      orderDate: DateTime.parse(json['order_date'] as String? ?? ''),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      orderType: json['order_type'] ?? '',
      commissionPercent: json['commission_percent'] ?? 0,
      commissionInRs: (json['commission_in_rs'] ?? 0).toDouble(),
    );
  }


  // Create list of models from JSON list
  static List<RecoveryReportModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RecoveryReportModel.fromJson(json)).toList();
  }
}
