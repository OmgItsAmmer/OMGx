import 'package:admin_dashboard_v3/Models/installments/installemt_plan_model.dart';

class InstallmentPaymentModel {
  final int installmentPlanId;
  final String installmentNumber;
  final String amountDue;
  final DateTime dueDate;
  final bool? isPaid;
  final DateTime? paidDate;
  final DateTime? createdAt;
  final String? paidAmount;
  final String? status;

  InstallmentPaymentModel({
    required this.installmentPlanId,
    required this.installmentNumber,
    required this.amountDue,
    required this.dueDate,
    this.isPaid,
    this.paidDate,
    this.createdAt,
    this.paidAmount,
    this.status,
  });

  // Static function to create an empty installment payment model
  static InstallmentPaymentModel empty() => InstallmentPaymentModel(
    installmentPlanId: 0,
    installmentNumber: '',
    amountDue: '',
    dueDate: DateTime.now(),
    isPaid: false,
    paidDate: null,
    createdAt: null,
    paidAmount: null,
    status: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'installment_plan_id': installmentPlanId,
      'installment_number': installmentNumber,
      'amount_due': amountDue,
      'due_date': dueDate.toIso8601String(),
      'is_paid': isPaid,
      'paid_date': paidDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'paid_amount': paidAmount,
      'status': status,
    };
  }

  // Factory method to create an InstallmentPaymentModel from JSON
  factory InstallmentPaymentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPaymentModel(
      installmentPlanId: json['installment_plan_id'] as int,
      installmentNumber: json['installment_number'] as String,
      amountDue: json['amount_due'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      isPaid: json['is_paid'] as bool?,
      paidDate: json['paid_date'] != null
          ? DateTime.parse(json['paid_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      paidAmount: json['paid_amount'] as String?,
      status: json['status'] as String?,
    );
  }
  static List<InstallmentPaymentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InstallmentPaymentModel.fromJson(json)).toList();
  }
}
