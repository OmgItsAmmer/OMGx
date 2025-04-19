class SalesmanRecoveryModel {
  int? salesmanId;
  String? salesmanName;
  double? totalSales;
  double? totalRecovered;
  double? outstandingAmount;
  double? recoveryPercentage;
  double? onTimeRecovery;
  double? delayedRecovery;
  double? aging0To30Days;
  double? aging31To60Days;
  double? aging61To90Days;
  double? agingAbove90Days;

  SalesmanRecoveryModel({
    this.salesmanId,
    this.salesmanName,
    this.totalSales,
    this.totalRecovered,
    this.outstandingAmount,
    this.recoveryPercentage,
    this.onTimeRecovery,
    this.delayedRecovery,
    this.aging0To30Days,
    this.aging31To60Days,
    this.aging61To90Days,
    this.agingAbove90Days,
  });

  // Static function to create an empty Salesman Recovery report model
  static SalesmanRecoveryModel empty() => SalesmanRecoveryModel(
        salesmanId: 0,
        salesmanName: "",
        totalSales: 0.0,
        totalRecovered: 0.0,
        outstandingAmount: 0.0,
        recoveryPercentage: 0.0,
        onTimeRecovery: 0.0,
        delayedRecovery: 0.0,
        aging0To30Days: 0.0,
        aging31To60Days: 0.0,
        aging61To90Days: 0.0,
        agingAbove90Days: 0.0,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'salesman_id': salesmanId ?? 0,
      'salesman_name': salesmanName ?? "",
      'total_sales': totalSales ?? 0.0,
      'total_recovered': totalRecovered ?? 0.0,
      'outstanding_amount': outstandingAmount ?? 0.0,
      'recovery_percentage': recoveryPercentage ?? 0.0,
      'on_time_recovery': onTimeRecovery ?? 0.0,
      'delayed_recovery': delayedRecovery ?? 0.0,
      'aging_0_30_days': aging0To30Days ?? 0.0,
      'aging_31_60_days': aging31To60Days ?? 0.0,
      'aging_61_90_days': aging61To90Days ?? 0.0,
      'aging_above_90_days': agingAbove90Days ?? 0.0,
    };
  }

  // Factory method to create a SalesmanRecoveryModel from Supabase response
  factory SalesmanRecoveryModel.fromJson(Map<String, dynamic> json) {
    return SalesmanRecoveryModel(
      salesmanId: json['salesman_id'] as int?,
      salesmanName: json['salesman_name'] as String?,
      totalSales: (json['total_sales'] as num?)?.toDouble(),
      totalRecovered: (json['total_recovered'] as num?)?.toDouble(),
      outstandingAmount: (json['outstanding_amount'] as num?)?.toDouble(),
      recoveryPercentage: (json['recovery_percentage'] as num?)?.toDouble(),
      onTimeRecovery: (json['on_time_recovery'] as num?)?.toDouble(),
      delayedRecovery: (json['delayed_recovery'] as num?)?.toDouble(),
      aging0To30Days: (json['aging_0_30_days'] as num?)?.toDouble(),
      aging31To60Days: (json['aging_31_60_days'] as num?)?.toDouble(),
      aging61To90Days: (json['aging_61_90_days'] as num?)?.toDouble(),
      agingAbove90Days: (json['aging_above_90_days'] as num?)?.toDouble(),
    );
  }
}

// This is the model used in the SalesmanReportPage
class RecoveryReportModel {
  final int orderId;
  final String salesmanName;
  final String customerName;
  final DateTime orderDate;
  final double salePrice;
  final String orderType;
  final double commissionPercent;
  final double commissionInRs;

  RecoveryReportModel({
    required this.orderId,
    required this.salesmanName,
    required this.customerName,
    required this.orderDate,
    required this.salePrice,
    required this.orderType,
    required this.commissionPercent,
    required this.commissionInRs,
  });

  // Static function to create an empty Recovery Report model
  static RecoveryReportModel empty() => RecoveryReportModel(
        orderId: 0,
        salesmanName: "",
        customerName: "",
        orderDate: DateTime.now(),
        salePrice: 0.0,
        orderType: "",
        commissionPercent: 0.0,
        commissionInRs: 0.0,
      );

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'salesman_name': salesmanName,
      'customer_name': customerName,
      'order_date': orderDate.toIso8601String(),
      'sale_price': salePrice,
      'order_type': orderType,
      'commission_percent': commissionPercent,
      'commission_in_rs': commissionInRs,
    };
  }

  // Factory method to create a RecoveryReportModel from JSON
  factory RecoveryReportModel.fromJson(Map<String, dynamic> json) {
    return RecoveryReportModel(
      orderId: json['order_id'] as int? ?? 0,
      salesmanName: json['salesman_name'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      orderDate: json['order_date'] != null
          ? DateTime.tryParse(json['order_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      salePrice: (json['sale_price'] == null)
          ? 0.0
          : (json['sale_price'] as num).toDouble(),
      orderType: json['order_type'] as String? ?? '',
      commissionPercent: (json['commission_percent'] == null)
          ? 0.0
          : (json['commission_percent'] as num).toDouble(),
      commissionInRs: (json['commission_in_rs'] == null)
          ? 0.0
          : (json['commission_in_rs'] as num).toDouble(),
    );
  }
}
