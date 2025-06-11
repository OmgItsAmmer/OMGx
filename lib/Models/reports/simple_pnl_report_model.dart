



class SimplePnLReportModel {
  final String reportPeriod;
  final double totalSales;
  final double totalCogs;
  final double totalProfit;
  final double profitMarginPercent;
  final int totalOrders;
  final double totalInstallmentsPaid;
  final double totalInstallmentsPending;

  SimplePnLReportModel({
    required this.reportPeriod,
    required this.totalSales,
    required this.totalCogs,
    required this.totalProfit,
    required this.profitMarginPercent,
    required this.totalOrders,
    required this.totalInstallmentsPaid,
    required this.totalInstallmentsPending,
  });

  factory SimplePnLReportModel.fromJson(Map<String, dynamic> json) {
    return SimplePnLReportModel(
      reportPeriod: json['report_period'] as String,
      totalSales: _parseToDouble(json['total_sales']),
      totalCogs: _parseToDouble(json['total_cogs']),
      totalProfit: _parseToDouble(json['total_profit']),
      profitMarginPercent: _parseToDouble(json['profit_margin_percent']),
      totalOrders: _parseToInt(json['total_orders']),
      totalInstallmentsPaid: _parseToDouble(json['total_installments_paid']),
      totalInstallmentsPending: _parseToDouble(json['total_installments_pending']),
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'report_period': reportPeriod,
      'total_sales': totalSales,
      'total_cogs': totalCogs,
      'total_profit': totalProfit,
      'profit_margin_percent': profitMarginPercent,
      'total_orders': totalOrders,
      'total_installments_paid': totalInstallmentsPaid,
      'total_installments_pending': totalInstallmentsPending,
    };
  }

  @override
  String toString() {
    return 'SalesReportModel(reportPeriod: $reportPeriod, totalSales: $totalSales, totalCogs: $totalCogs, totalProfit: $totalProfit, profitMarginPercent: $profitMarginPercent, totalOrders: $totalOrders, totalInstallmentsPaid: $totalInstallmentsPaid, totalInstallmentsPending: $totalInstallmentsPending)';
  }
}