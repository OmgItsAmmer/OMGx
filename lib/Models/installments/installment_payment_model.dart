
class InstallmentPayment {
  int sequenceNo;
  int installmentPlanId;
  String dueDate;
  String amountDue;
  String? paidDate;
  String? paidAmount;
  String? status;
  bool isPaid;
  DateTime createdAt;

  InstallmentPayment({
    required this.sequenceNo,
    required this.installmentPlanId,
    required this.dueDate,
    required this.amountDue,
    this.paidDate,
    this.paidAmount,
    this.status,
    this.isPaid = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory method to create an InstallmentPayment from a JSON object
  factory InstallmentPayment.fromJson(Map<String, dynamic> json) {
    return InstallmentPayment(
      sequenceNo: json['sequence_no'] as int? ?? 0,
      installmentPlanId: json['installment_plan_id'] as int? ?? 0,
      dueDate: json['due_date'] as String? ?? DateTime.now().toIso8601String(),
      amountDue: json['amount_due'] as String? ?? "0.00",
      paidDate: json['paid_date'] as String?,
      paidAmount: json['paid_amount'] as String?,
      status: json['status'] as String?,
      isPaid: json['is_paid'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // Convert model to JSON for database insertion or network requests
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> json = {
      'sequence_no': sequenceNo,
      'due_date': dueDate,
      'paid_date': paidDate,
      'amount_due': amountDue,
      'paid_amount': paidAmount,
      'status': status,
      'is_paid': isPaid,
      'created_at': createdAt.toIso8601String(),
    };

    // Conditionally include installment_plan_id
    if (isUpdate) {
      json['installment_plan_id'] = installmentPlanId;
    }

    return json;
  }


  // Static function to create an empty installment model
  static InstallmentPayment empty() => InstallmentPayment(
    sequenceNo: 0,
    installmentPlanId: 0,
    dueDate: DateTime.now().toIso8601String(),
    amountDue: "0.00",
    isPaid: false,
    createdAt: DateTime.now(),
  );

  // Convert a list of JSON objects to a list of InstallmentPayment
  static List<InstallmentPayment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InstallmentPayment.fromJson(json)).toList();
  }
}
