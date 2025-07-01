import '../../../utils/constants/enums.dart';

class AccountBookModel {
  int? accountBookId;
  final String entityType; // customer, vendor, salesman
  final int entityId; // ID of the customer/vendor/salesman
  final String entityName; // Name for display purposes
  final TransactionType transactionType; // buy, sell (from enum)
  final double amount;
  final String description;
  final String? reference; // Optional reference number
  final DateTime transactionDate;
  final DateTime? createdAt;

  AccountBookModel({
    this.accountBookId,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.transactionType,
    required this.amount,
    required this.description,
    this.reference,
    required this.transactionDate,
    this.createdAt,
  });

  // Static function to create an empty account book model
  static AccountBookModel empty() => AccountBookModel(
        accountBookId: null,
        entityType: "",
        entityId: 0,
        entityName: "",
        transactionType: TransactionType.sell,
        amount: 0.0,
        description: "",
        reference: "",
        transactionDate: DateTime.now(),
        createdAt: null,
      );

  // Helper method to get transaction type display text
  String get transactionTypeDisplay {
    switch (transactionType) {
      case TransactionType.buy:
        return "Incoming Payment";
      case TransactionType.sell:
        return "Outgoing Payment";
    }
  }

  // Helper method to get entity type display text
  String get entityTypeDisplay {
    switch (entityType.toLowerCase()) {
      case 'customer':
        return "Customer";
      case 'vendor':
        return "Vendor";
      case 'salesman':
        return "Salesman";
      default:
        return entityType;
    }
  }

  // Helper method to determine if this is an incoming or outgoing payment
  bool get isIncoming => transactionType == TransactionType.buy;
  bool get isOutgoing => transactionType == TransactionType.sell;

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'entity_type': entityType,
      'entity_id': entityId,
      'entity_name': entityName,
      'transaction_type': transactionType.toString().split('.').last,
      'amount': amount,
      'description': description,
      'reference': reference,
      'transaction_date': transactionDate.toIso8601String(),
    };

    if (!isUpdate) {
      if (accountBookId != null) {
        data['account_book_id'] = accountBookId;
      }
    }

    return data;
  }

  // Factory method to create an AccountBookModel from Supabase response
  factory AccountBookModel.fromJson(Map<String, dynamic> json) {
    return AccountBookModel(
      accountBookId: json['account_book_id'] as int?,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as int,
      entityName: json['entity_name'] as String,
      transactionType: (json['transaction_type'] as String) == 'buy'
          ? TransactionType.buy
          : TransactionType.sell,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      reference: json['reference'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // Static method to create a list of AccountBookModel from a JSON list
  static List<AccountBookModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AccountBookModel.fromJson(json)).toList();
  }

  // Copy with method for updating specific fields
  AccountBookModel copyWith({
    int? accountBookId,
    String? entityType,
    int? entityId,
    String? entityName,
    TransactionType? transactionType,
    double? amount,
    String? description,
    String? reference,
    DateTime? transactionDate,
    DateTime? createdAt,
  }) {
    return AccountBookModel(
      accountBookId: accountBookId ?? this.accountBookId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityName: entityName ?? this.entityName,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AccountBookModel(id: $accountBookId, entity: $entityName, type: ${transactionTypeDisplay}, amount: \$${amount.toStringAsFixed(2)}, date: ${transactionDate.toString().split(' ')[0]})';
  }
}
