import 'package:flutter/material.dart';

class InstallmentTableModel {
  final int sequenceNo;
  final String description;
  final String dueDate;
  final String? paidDate;
  final String amount_due;
  final String paid_amount;
  final String remarks;
  final String remaining;
  final String status;
  final String action;

  InstallmentTableModel({
    required this.sequenceNo,
    this.description = "",
    required this.dueDate,
    required this.paidDate,
    required this.amount_due,
    required this.paid_amount,
    required this.remarks,
    required this.remaining,
    required this.status,
    required this.action,
  });

  // Static function to create an empty installment model
  static InstallmentTableModel empty() => InstallmentTableModel(
    sequenceNo: 0,
    description: "",
    dueDate: DateTime.now().toIso8601String(),
    paidDate: DateTime.now().toIso8601String(),
    paid_amount: "",
    amount_due: "",
    remarks: "",
    remaining: "",
    status: "",
    action: "",
  );

  // Convert model to JSON for database insertion or network requests
  Map<String, dynamic> toJson() {
    return {
      'sequence_no': sequenceNo,
      'description': description,
      'due_date': dueDate,  // ✅ Convert DateTime to String
      'paid_date': paidDate, // ✅ Convert DateTime to String
      'amount_due': amount_due,
      'paid_amount': paid_amount,
      'remarks': remarks, // ✅ Fixing duplicate key issue
      'balance': remaining,
      'status': status,
      'action': action,
    };
  }


  // Factory method to create an InstallmentTableModel from a JSON object
  factory InstallmentTableModel.fromJson(Map<String, dynamic> json) {
    DateTime fullDueDate = DateTime.parse(json['due_date']);
    String formattedDueDate = "${fullDueDate.year.toString().padLeft(4, '0')}-${fullDueDate.month.toString().padLeft(2, '0')}-${fullDueDate.day.toString().padLeft(2, '0')}";
    DateTime fullPaidDate = DateTime.parse(json['paid_date']);
    String formattedPaidDate = "${fullPaidDate.year.toString().padLeft(4, '0')}-${fullPaidDate.month.toString().padLeft(2, '0')}-${fullPaidDate.day.toString().padLeft(2, '0')}";
    return InstallmentTableModel(
      sequenceNo: json['sequence_no'] as int,
      description: json['description'] as String,
      dueDate: formattedDueDate,
      paidDate: json['paid_date'] != null
          ? formattedPaidDate
          : null,
      amount_due: json['amount_due'] as String? ?? "",
      paid_amount: json['paid_amount'] as String? ?? "",
      remarks: json['remarks'] as String? ?? "",
      remaining: json['balance'] as String? ?? "",
      status: json['status'] as String? ?? "",
      action: json['action'] as String? ?? "",
    );
  }
  static List<InstallmentTableModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InstallmentTableModel.fromJson(json)).toList();
  }
}
