class SalesReportModel {
  final int? id; // Nullable, similar to customerId
  final String name;
  final int itemsSold;
  final double profit;
  final int stockRemaining;

  SalesReportModel({
    this.id,
    required this.name,
    required this.itemsSold,
    required this.profit,
    required this.stockRemaining,
  });

  // Create an empty model
  static SalesReportModel empty() => SalesReportModel(
    id: null,
    name: '',
    itemsSold: 0,
    profit: 0.0,
    stockRemaining: 0,
  );

  // Convert model to JSON
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = <String, dynamic>{
      'name': name,
      'items_sold': itemsSold,
      'profit': profit,
      'stock_remaining': stockRemaining,
    };

    if (!isUpdate && id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Factory constructor from JSON
  factory SalesReportModel.fromJson(Map<String, dynamic> json) {
    return SalesReportModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      itemsSold: json['items_sold'] as int,
      profit: (json['profit'] as num).toDouble(),
      stockRemaining: json['stock_remaining'] as int,
    );
  }

  // Create list of models from JSON list
  static List<SalesReportModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SalesReportModel.fromJson(json)).toList();
  }
}
