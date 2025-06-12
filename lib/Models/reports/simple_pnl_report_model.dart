class SimplePnLReportModel {
  final double totalRevenue;
  final double totalCogs;
  final double totalExpenses;
  final double grossProfit;
  final double netProfit;
  final double profitMargin;

  SimplePnLReportModel({
    required this.totalRevenue,
    required this.totalCogs,
    required this.totalExpenses,
    required this.grossProfit,
    required this.netProfit,
    required this.profitMargin,
  });

  factory SimplePnLReportModel.fromJson(Map<String, dynamic> json) {
    return SimplePnLReportModel(
      totalRevenue: _parseToDouble(json['total_revenue']),
      totalCogs: _parseToDouble(json['total_cogs']),
      totalExpenses: _parseToDouble(json['total_expenses']),
      grossProfit: _parseToDouble(json['gross_profit']),
      netProfit: _parseToDouble(json['net_profit']),
      profitMargin: _parseToDouble(json['profit_margin']),
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_cogs': totalCogs,
      'total_expenses': totalExpenses,
      'gross_profit': grossProfit,
      'net_profit': netProfit,
      'profit_margin': profitMargin,
    };
  }

  @override
  String toString() {
    return 'SimplePnLReportModel(totalRevenue: $totalRevenue, totalCogs: $totalCogs, totalExpenses: $totalExpenses, grossProfit: $grossProfit, netProfit: $netProfit, profitMargin: $profitMargin)';
  }
}