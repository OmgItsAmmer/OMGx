import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/installments/installemt_plan_model.dart';
import '../../Models/installments/installment_payment_model.dart';
import '../../Models/installments/installment_table_model/installment_table_model.dart';

class InstallmentRepository extends GetxController {
  static InstallmentRepository get instance => Get.find();

  // Future<void> uploadInstallmentPlan(InstallmentPlanModel plan) async {
  //   try {
  //     // Insert the installment plan into the 'installment_plans' table
  //     final response = await Supabase.instance.client
  //         .from('installment_plans')
  //         .insert(plan.toJson())
  //         .select();
  //
  //     final installmentPlanId = response[0]['installment_plans_id'];
  //
  //     // Convert String values to appropriate numerical values
  //     final double totalAmount = double.tryParse(plan.totalAmount) ?? 0.0;
  //     final double downPayment = double.tryParse(plan.downPayment) ?? 0.0;
  //     final int numberOfInstallments = int.tryParse(plan.numberOfInstallments) ?? 1;
  //     final int frequencyInMonth = int.tryParse(plan.frequencyInMonth ?? '1') ?? 1;
  //
  //     // Calculate installment amount
  //     final double installmentAmount = (totalAmount - downPayment) / numberOfInstallments;
  //     final DateTime startDate = plan.firstInstallmentDate ?? DateTime.now();
  //
  //
  //     installmentPayments = List.generate(
  //       numberOfInstallments,
  //           (index) {
  //         final dueDate = DateTime(
  //           startDate.year,
  //           startDate.month + (frequencyInMonth * (index + 1)),
  //           startDate.day,
  //         ).toIso8601String();
  //
  //         return InstallmentTableModel(
  //           sequenceNo: index + 1,
  //           description: "Installment ${index + 1}",
  //           dueDate: dueDate,
  //           paidDate: "", // Initially empty
  //           amount_due: installmentAmount.toStringAsFixed(2),
  //           paid_amount: "0.00", // Initially zero
  //           remarks: "", // Initially empty
  //           remaining: installmentAmount.toStringAsFixed(2), // Initially
  //           status: "Pending",
  //           action: "Pay Now",
  //         );
  //       },
  //     );
  //
  //     // Convert the list of models to a list of JSON objects
  //     final List<Map<String, dynamic>> paymentJsonList =
  //     installmentPayments.map((payment) => payment.toJson()).toList();
  //
  //     // Insert the generated installment payments into the 'installment_payments' table
  //     await Supabase.instance.client.from('installment_payments').insert(paymentJsonList);
  //
  //     TLoader.successSnackBar(
  //       title: 'Success',
  //       message: 'Installment plan and payments successfully created.',
  //     );
  //   } catch (e) {
  //     // Show error if any
  //     TLoader.errorsnackBar(
  //       title: 'Upload Installment Plan Error',
  //       message: e.toString(),
  //     );
  //     print(e);
  //   }
  // }

  Future<void> uploadInstallmentPlan(
      InstallmentPlanModel plan, int orderId) async {
    try {
      // Insert the installment plan into the 'installment_plans' table
      final response =
          await Supabase.instance.client.from('installment_plans').insert({
        'order_id': orderId,
        'total_amount': plan.totalAmount,
        'down_payment': plan.downPayment,
        'number_of_installments': plan.numberOfInstallments,
        'document_charges': plan.documentCharges,
        'margin': plan.margin,
        'frequency_in_month': plan.frequencyInMonth,
        'other_charges': plan.otherCharges,
        'duration': plan.duration,
        'first_installment_date': plan.firstInstallmentDate?.toIso8601String(),
        'note': plan.note,
      }).select();

      final installmentPlanId = response[0]['installment_plans_id'];

      // Insert the order items into the 'order_items' table
      await Supabase.instance.client
          .from('installment_payments')
          .insert(plan.installemtPaymentList!.map((item) {
            return {
              'installment_plan_id':
                  installmentPlanId, // Assign the order_id to the order items
              'installment_number': item.sequenceNo,
              'due_date':  item.dueDate,
              'paid_date': item.paidDate,
              'amount_due': item.amount_due,
              'paid_amount': item.paid_amount,
              'is_paid': false, //initially
              'status': 'pending', //initially
            };
          }).toList());

      // TLoader.successSnackBar(
      //     title: 'Success', message: 'Order successfully checked out.');
    } catch (e) {
      TLoader.errorsnackBar(title: 'Plan didn\'t upload', message: e.toString());
      print(e);

    }
  }
}
