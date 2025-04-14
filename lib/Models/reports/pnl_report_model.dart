class PnLReportModel {
  String? reportMonth;
  double? totalRevenue;
  double? totalCogs;
  double? totalShippingFees;
  double? totalSalesmanCommission;
  double? grossProfit;
  double? netProfit;

  PnLReportModel({
    this.reportMonth,
    this.totalRevenue,
    this.totalCogs,
    this.totalShippingFees,
    this.totalSalesmanCommission,
    this.grossProfit,
    this.netProfit,
  });

  // Static function to create an empty PnL report model
  static PnLReportModel empty() => PnLReportModel(
    reportMonth: "",
    totalRevenue: 0.0,
    totalCogs: 0.0,
    totalShippingFees: 0.0,
    totalSalesmanCommission: 0.0,
    grossProfit: 0.0,
    netProfit: 0.0,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'report_month': reportMonth ?? "",
      'total_revenue': totalRevenue ?? 0.0,
      'total_cogs': totalCogs ?? 0.0,
      'total_shipping_fees': totalShippingFees ?? 0.0,
      'total_salesman_comission': totalSalesmanCommission ?? 0.0,
      'gross_profit': grossProfit ?? 0.0,
      'net_profit': netProfit ?? 0.0,
    };
  }

  // Factory method to create a PnLReportModel from Supabase response
  factory PnLReportModel.fromJson(Map<String, dynamic> json) {
    return PnLReportModel(
      reportMonth: json['report_month'] as String?,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
      totalCogs: (json['total_cogs'] as num?)?.toDouble(),
      totalShippingFees: (json['total_shipping_fees'] as num?)?.toDouble(),
      totalSalesmanCommission: (json['total_salesman_comission'] as num?)?.toDouble(),
      grossProfit: (json['gross_profit'] as num?)?.toDouble(),
      netProfit: (json['net_profit'] as num?)?.toDouble(),
    );
  }

}
