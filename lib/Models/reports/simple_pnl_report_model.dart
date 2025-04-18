class SimplePnLReportModel {
  final String category;
  final double amount;

  SimplePnLReportModel({
    required this.category,
    required this.amount,
  });

  factory SimplePnLReportModel.fromJson(Map<String, dynamic> json) {
    return SimplePnLReportModel(
      category: json['category'] as String,
      amount: (json['amount'] is int) 
          ? (json['amount'] as int).toDouble() 
          : json['amount'] as double,
    );
  }
}