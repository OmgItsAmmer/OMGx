import 'package:admin_dashboard_v3/Models/installments/installment_payment_model.dart';

import 'installment_table_model/installment_table_model.dart';

class InstallmentPlanModel {
  final int installmentPlanId;
  final int orderId;
  final String totalAmount;
  final String downPayment;
  final String numberOfInstallments; // Changed from int to String
  final DateTime? createdAt;
  final String? documentCharges; // Changed from double? to String?
  final String? margin; // Changed from double? to String?
  final String? frequencyInMonth; // Changed from double? to String?
  final String? otherCharges; // Changed from double? to String?
  final String? duration;
  final DateTime? firstInstallmentDate;
  final String? note;
  final List<InstallmentTableModel>? installemtPaymentList;

  InstallmentPlanModel({
    required this.installmentPlanId,
    required this.orderId,
    required this.totalAmount,
    required this.downPayment,
    required this.numberOfInstallments,
    this.createdAt,
    this.documentCharges,
    this.margin,
    this.frequencyInMonth,
    this.otherCharges,
    this.duration,
    this.firstInstallmentDate,
    this.note,
    this.installemtPaymentList,
  });

  // Static function to create an empty installment plan model
  static InstallmentPlanModel empty() => InstallmentPlanModel(
    installmentPlanId: 0,
    orderId: 0,
    totalAmount: "",
    downPayment: "",
    numberOfInstallments: "",
    createdAt: null,
    documentCharges: null,
    margin: null,
    frequencyInMonth: null,
    otherCharges: null,
    duration: null,
    firstInstallmentDate: null,
    note: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'installment_plans_id': installmentPlanId,
      'order_id': orderId,
      'total_amount': totalAmount,
      'down_payment': downPayment,
      'number_of_installments': numberOfInstallments,
      'created_at': createdAt?.toIso8601String(),
      'document_charges': documentCharges,
      'margin': margin,
      'frequency_in_month': frequencyInMonth,
      'other_charges': otherCharges,
      'duration': duration,
      'first_installment_date': firstInstallmentDate?.toIso8601String(),
      'note': note,
      'installemtPaymentList': [],
    };
    if (!isUpdate) {
      data['installment_plans_id'] = installmentPlanId; // Only include `order_id` if it's not an update
    }
    return data;
  }

  // Factory method to create an InstallmentPlanModel from JSON
  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      installmentPlanId: json['installment_plans_id'] as int,
      orderId: json['order_id'] as int,
      totalAmount: (json['total_amount'] as String),
      downPayment: json['down_payment'] as String,
      numberOfInstallments: json['number_of_installments'] as String, // Changed
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      documentCharges: json['document_charges'] as String?, // Changed
      margin: json['margin'] as String?, // Changed
      frequencyInMonth: json['frequency_in_month'] as String?, // Changed
      otherCharges: json['other_charges'] as String?, // Changed
      duration: json['duration'] as String?,
      firstInstallmentDate: json['first_installment_date'] != null
          ? DateTime.parse(json['first_installment_date'] as String)
          : null,
      note: json['note'] as String?,
      installemtPaymentList: json['installemtPaymentList'] != null //TODO might be a issue
          ? InstallmentTableModel.fromJsonList(json['order_items'] as List)
          : null,
    );
  }
}



