import 'package:admin_dashboard_v3/Models/installments/installment_table_model/installment_table_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/installments/installemt_plan_model.dart';
import '../../main.dart';
import 'package:admin_dashboard_v3/Models/installments/installment_payment_model.dart';

class InstallmentRepository extends GetxController {
  static InstallmentRepository get instance => Get.find();

  Future<void> updateInstallmentPayment(
    int sequenceNo,
    int planId,
    String paidAmount,
    String remainingAmount,
  ) async {
    // Step 1: Mark the current installment as paid
    await supabase
        .from('installment_payments')
        .update({
          'is_paid': true,
          'paid_date': DateTime.now().toIso8601String(),
          'status': 'paid',
          'paid_amount': paidAmount,
        })
        .eq('installment_plan_id', planId)
        .eq('sequence_no', sequenceNo);

    // Step 2: Update the next installment's amount_due
    final nextSequenceNo = sequenceNo + 1;

    await supabase
        .from('installment_payments')
        .update({
          'amount_due': (double.tryParse(remainingAmount) ?? 0.0).toString(),
        })
        .eq('installment_plan_id', planId)
        .eq('sequence_no', nextSequenceNo);
  }

  Future<void> uploadInstallmentPlanAndPayment(
      InstallmentPlanModel plan, int orderId) async {
    try {
      // Convert plan to JSON using the model's toJson method
      final planJson = plan.toJson(isUpdate: true);

      // Add order_id which isn't part of the model's default toJson
      planJson['order_id'] = orderId;

      // Format the firstInstallmentDate if it exists
      if (plan.firstInstallmentDate != null) {
        planJson['first_installment_date'] =
            plan.firstInstallmentDate!.toIso8601String();
      }

      // Insert the installment plan
      final response = await Supabase.instance.client
          .from('installment_plans')
          .insert(planJson)
          .select();

      final installmentPlanId = response[0]['installment_plans_id'];

      // Convert payment list to JSON using the model's methods
      final paymentJsons = plan.installmentPaymentList!.map((payment) {
        // Convert to JSON using the payment model's method
        final paymentJson = payment.toJson();

        // Add additional fields needed for the insert
        paymentJson['installment_plan_id'] = installmentPlanId;
        paymentJson['is_paid'] = false;
        paymentJson['status'] = (payment.sequenceNo == 0) ? 'paid' : 'pending';

        return paymentJson;
      }).toList();

      // Insert all payments in a single batch
      await supabase.from('installment_payments').insert(paymentJsons);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Plan didn\'t upload', message: e.toString());
      if (kDebugMode) print(e);
    }
  }

  Future<void> insertInstallmentPayment(
      Map<String, dynamic> paymentJson) async {
    try {
      // Insert the payment data into the 'installment_payments' table

      await supabase.from('installment_payments').insert(paymentJson);

      TLoaders.successSnackBar(
          title: 'Success', message: 'Payment successfully uploaded.');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Payment Upload Failed', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<InstallmentTableModel>> fetchSpecifcInstallmentPlanItems(
      int installmentPlanId) async {
    try {
      final data = await supabase
          .from('installment_payments')
          .select()
          .eq('installment_plan_id', installmentPlanId);

      final installmentPaymentList = data.map((item) {
        return InstallmentTableModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(installmentPaymentList[1].status);
      }
      return installmentPaymentList;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Plan didn\'t fetch', message: e.toString());
      print(e);
      return [];
    }
  }

  Future<int?> fetchPlanId(int orderId) async {
    try {
      final data = await supabase
          .from('installment_plans')
          .select('installment_plans_id') // Correct column name
          .eq('order_id', orderId)
          .limit(1); // Ensures only one row is fetched

      if (data.isNotEmpty) {
        return data.first['installment_plans_id'] as int; // Correct column name
      } else {
        return null; // Return null if no matching record
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Plan ID didn\'t fetch', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
      return null; // Return null in case of an error
    }
  }

  Future<void> updateInstallmentPlanStatus(int planId, String status) async {
    try {
      await supabase
          .from('installment_plans')
          .update({'status': status}).eq('installment_plans_id', planId);
    } catch (e) {
      print('Error updating installment plan status: $e');
      throw Exception('Failed to update installment plan status: $e');
    }
  }

  Future<int?> getOrderIdForPlan(int planId) async {
    try {
      final result = await supabase
          .from('installment_plans')
          .select('order_id')
          .eq('installment_plans_id', planId)
          .limit(1)
          .single();

      if (result != null && result['order_id'] != null) {
        return result['order_id'] as int;
      }
      return null;
    } catch (e) {
      print('Error getting order ID for plan: $e');
      return null;
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await supabase
          .from('orders')
          .update({'status': status}).eq('order_id', orderId);
    } catch (e) {
      print('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> recordRefund(
    int orderId,
    double amountPaid,
    double refundAmount,
    bool includesShipping,
    bool includesTax,
    bool includesDocumentCharges,
    bool includesOtherCharges,
    bool includesAdvancePayment,
    bool includesSalesmanCommission,
    bool includesMargin,
    double advancePayment,
    double installmentsPaid,
    double documentCharges,
    double otherCharges,
    double salesmanCommission,
    double margin,
  ) async {
    try {
      // Create a record in the refunds table with detailed information
      await supabase.from('refunds').insert({
        'order_id': orderId,
        'amount_paid': amountPaid,
        'refund_amount': refundAmount,
        'includes_shipping': includesShipping,
        'includes_tax': includesTax,
        'includes_document_charges': includesDocumentCharges,
        'includes_other_charges': includesOtherCharges,
        'includes_advance_payment': includesAdvancePayment,
        'includes_salesman_commission': includesSalesmanCommission,
        'includes_margin': includesMargin,
        'advance_payment': advancePayment,
        'installments_paid': installmentsPaid,
        'document_charges': documentCharges,
        'other_charges': otherCharges,
        'salesman_commission': salesmanCommission,
        'margin': margin,
        'refund_date': DateTime.now().toIso8601String(),
        'status': 'processed',
      });

      // Update the order record to mark it as refunded
      await supabase.from('orders').update({
        'refund_status': 'refunded',
        'refund_amount': refundAmount,
        'refund_date': DateTime.now().toIso8601String(),
      }).eq('order_id', orderId);
    } catch (e) {
      print('Error recording refund: $e');
      throw Exception('Failed to record refund: $e');
    }
  }

  Future<InstallmentPlanModel?> fetchInstallmentPlan(int planId) async {
    try {
      final data = await supabase
          .from('installment_plans')
          .select()
          .eq('installment_plans_id', planId)
          .limit(1)
          .single();

      if (data != null) {
        return InstallmentPlanModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching installment plan: $e');
      return null;
    }
  }
}
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
