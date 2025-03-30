import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseModel {
  int expenseId;
  final String description;
  final double amount;
  final DateTime? createdAt;

  ExpenseModel({
    required this.expenseId,
    required this.description,
    required this.amount,
    this.createdAt,
  });

  // Static function to create an empty expense model
  static ExpenseModel empty() => ExpenseModel(
    expenseId: 0,
    description: "",
    amount: 0.0,
    createdAt: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'description': description,
      'amount': amount,

    };
    if (!isUpdate) {
      data['expense_id'] = expenseId;
      data['created_at'] = createdAt?.toIso8601String();
    }
    return data;
  }

  // Factory method to create an ExpenseModel from Supabase response
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expense_id'] as int,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // Static method to create a list of ExpenseModel from a JSON list
  static List<ExpenseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ExpenseModel.fromJson(json)).toList();
  }
}