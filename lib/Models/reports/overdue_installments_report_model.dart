class OverdueInstallmentsReportModel {
  final int installmentPlanId;
  final int orderId;
  final String customerName;
  final String customerContact;
  final String dueDate;
  final String amountDue;
  final int sequenceNo;
  final String totalAmount;
  final String salesmanName;
  final int daysOverdue;
  final String status;

  OverdueInstallmentsReportModel({
    required this.installmentPlanId,
    required this.orderId,
    required this.customerName,
    required this.customerContact,
    required this.dueDate,
    required this.amountDue,
    required this.sequenceNo,
    required this.totalAmount,
    required this.salesmanName,
    required this.daysOverdue,
    required this.status,
  });

  factory OverdueInstallmentsReportModel.fromJson(Map<String, dynamic> json) {
    return OverdueInstallmentsReportModel(
      installmentPlanId: json['installment_plan_id'] as int,
      orderId: json['order_id'] as int,
      customerName: json['customer_name'] as String,
      customerContact: json['customer_contact'] as String? ?? '',
      dueDate: json['due_date'] as String,
      amountDue: json['amount_due'] as String,
      sequenceNo: json['sequence_no'] as int,
      totalAmount: json['total_amount'] as String,
      salesmanName: json['salesman_name'] as String? ?? '',
      daysOverdue: json['days_overdue'] as int,
      status: json['status'] as String? ?? 'Unpaid',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installment_plan_id': installmentPlanId,
      'order_id': orderId,
      'customer_name': customerName,
      'customer_contact': customerContact,
      'due_date': dueDate,
      'amount_due': amountDue,
      'sequence_no': sequenceNo,
      'total_amount': totalAmount,
      'salesman_name': salesmanName,
      'days_overdue': daysOverdue,
      'status': status,
    };
  }
}
