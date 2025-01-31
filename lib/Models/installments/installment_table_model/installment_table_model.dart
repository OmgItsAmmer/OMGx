import 'package:flutter/material.dart';

class InstallmentTableModel {
  final int sequenceNo;
  final String description;
  final String dueDate;
  final String? paidDate;
  final String amountDue;
  final String? paidAmount;
  final String remarks;
  final String remaining;
  final String? status;
  final String action;

  InstallmentTableModel({
    required this.sequenceNo,
    this.description = "",
    required this.dueDate,
    this.paidDate,
    required this.amountDue,
    this.paidAmount,
    required this.remarks,
    required this.remaining,
    this.status,
    required this.action,
  });

  // Static function to create an empty installment model
  static InstallmentTableModel empty() => InstallmentTableModel(
    sequenceNo: 0,
    description: "",
    dueDate: DateTime.now().toIso8601String(),
    paidDate: null,
    amountDue: "0.00",
    paidAmount: null,
    remarks: "",
    remaining: "0.00",
    status: null,
    action: "",
  );

  // Convert model to JSON for database insertion or network requests
  Map<String, dynamic> toJson() {
    return {
      'sequence_no': sequenceNo,
      'description': description,
      'due_date': dueDate,
      'paid_date': paidDate,
      'amount_due': amountDue,
      'paid_amount': paidAmount,
      'remarks': remarks,
      'balance': remaining,
      'status': status,
      'action': action,
    };
  }

  // Factory method to create an InstallmentTableModel from a JSON object
  factory InstallmentTableModel.fromJson(Map<String, dynamic> json) {
    return InstallmentTableModel(
      sequenceNo: json['sequence_no'] as int? ?? 0, // Handle null case
      description: json['description'] as String? ?? "",
      dueDate: json['due_date'] != null
          ? _formatDate(json['due_date'] as String)
          : DateTime.now().toIso8601String(),
      paidDate: json['paid_date'] != null
          ? _formatDate(json['paid_date'] as String)
          : null,
      amountDue: json['amount_due'] as String? ?? "0.00",
      paidAmount: json['paid_amount'] as String?,
      remarks: json['remarks'] as String? ?? "",
      remaining: json['balance'] as String? ?? "0.00",
      status: json['status'] as String?,
      action: json['action'] as String? ?? "",
    );
  }

  // Helper method to format date strings
  static String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Convert a list of JSON objects to a list of InstallmentTableModel
  static List<InstallmentTableModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InstallmentTableModel.fromJson(json)).toList();
  }
}