
import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/repositories/installment/installment_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/installments/installemt_plan_model.dart';
import '../../Models/installments/installment_payment_model.dart';
import '../../Models/installments/installment_table_model/installment_table_model.dart';
import '../../views/reports/specific_reports/installment_plans/installment_plan_report.dart';
import '../guarantors/guarantor_controller.dart';
import '../sales/sales_controller.dart';

class InstallmentController extends GetxController {
  static InstallmentController get instance => Get.find();
  final InstallmentRepository installmentRepository =
      Get.put(InstallmentRepository());
  final SalesController salesController = Get.find<SalesController>();
  final GuarantorController guarantorController =
      Get.put(GuarantorController());
  final CustomerController customerController = Get.find<CustomerController>();

//  RxList<SaleModel> allSales = <SaleModel>[].obs;

  // Loading state
  final isLoading = false.obs;
  final isCustomerLoading = false.obs;
  final isGuarantorLoading = false.obs;

  //Installment Info
  final billAmount = TextEditingController().obs;
  final NoOfInstallments = TextEditingController();
  final DownPayment = TextEditingController();
  final DocumentCharges = TextEditingController();
  final margin = TextEditingController();
  final note = TextEditingController();

  //Advance Info
  final frequencyInMonth = TextEditingController();
  final otherCharges = TextEditingController();
  final payableExMargin = TextEditingController().obs;
  final payableINCLMargin = TextEditingController().obs;

  //Duration Info
  final durationController = DurationType.Duration.obs;
  DateTime? selectedDate;

  //Installment table (Global)
  Rx<InstallmentPlanModel> currentInstallmentPlan = InstallmentPlanModel.empty().obs;
  RxList<InstallmentTableModel> currentInstallmentPayments =
      <InstallmentTableModel>[].obs;
  //final List<InstallmentTableModel> installmentPayments;


  //Installment Table

  final paidAmount = TextEditingController();
  final remainingAmount = TextEditingController().obs;

  //final RxList<>

  //OrderDetails
  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;

void resetFormFields() {
  try{
    paidAmount.clear();
    remainingAmount.value.clear();
  }
  catch(e)
  {
    if (kDebugMode) {
      TLoader.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      print(e);
    }
  }

  }


  Future<void> updateInstallmentPayments(int sequenceNo, int planId) async {
    try {
      // Step 1: Find the current installment in the local list
      final currentInstallment = currentInstallmentPayments.firstWhere(
            (installment) => installment.sequenceNo == sequenceNo && installment.planId == planId,
        orElse: () => throw Exception('Current installment not found'),
      );

      // Step 2: Parse the paidAmount and remainingAmount
      final paidAmountValue = double.tryParse(paidAmount.text) ?? 0.0;
      final remainingAmountValue = double.tryParse(remainingAmount.value.text) ?? 0.0;

      // Step 3: Update the current installment
      currentInstallment.paidDate = DateTime.now().toIso8601String();
      currentInstallment.status = InstallmentStatus.paid.toString().split('.').last;
      currentInstallment.paidAmount = paidAmountValue.toString();
      currentInstallment.remaining = (double.tryParse(currentInstallment.amountDue) ?? 0.0 - paidAmountValue).toString();

      // Step 4: Find the next installment in the local list
      final nextSequenceNo = sequenceNo + 1;
      final nextInstallmentIndex = currentInstallmentPayments.indexWhere(
            (installment) => installment.sequenceNo == nextSequenceNo && installment.planId == planId,
      );

      if (nextInstallmentIndex != -1) {
        // If the next installment exists, update its amountDue
        final nextInstallment = currentInstallmentPayments[nextInstallmentIndex];
        final nextAmountDue = double.tryParse(nextInstallment.amountDue) ?? 0.0;
        final updatedAmountDue = nextAmountDue + remainingAmountValue;
        nextInstallment.amountDue = updatedAmountDue.toString();
      } else {
        // If no next installment exists
        if (planId == 0) {
          TLoader.errorSnackBar(title: 'Plan Error', message: 'Reset and generate the plan again.');
          return; // Stop execution here
        }

        // Calculate the new due date based on previous installments' pattern
        DateTime newDueDate;
        final previousInstallments = currentInstallmentPayments
            .where((i) => i.planId == planId)
            .toList()
          ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo));

        if (previousInstallments.length >= 2) {
          final lastDate = DateTime.parse(previousInstallments.last.dueDate);
          final secondLastDate = DateTime.parse(previousInstallments[previousInstallments.length - 2].dueDate);
          final averageInterval = lastDate.difference(secondLastDate);
          newDueDate = lastDate.add(averageInterval);
        } else if (previousInstallments.length == 1) {
          newDueDate = DateTime.parse(currentInstallment.dueDate).add(const Duration(days: 30));
        } else {
          newDueDate = DateTime.now().add(const Duration(days: 30));
        }

        // If the next installment doesn't exist, create a new one
        final newInstallment = InstallmentPayment(
          sequenceNo: nextSequenceNo,
          installmentPlanId: planId,
          dueDate: newDueDate.toIso8601String(),
          amountDue: remainingAmountValue.toString(),
          paidAmount: '0.0',
          status: InstallmentStatus.pending.toString().split('.').last,
        );

        final paymentJson = newInstallment.toJson();
        await installmentRepository.insertInstallmentPayment(paymentJson);
        TLoader.successSnackBar(title: 'Success', message: 'New Installment Data Added!');

        final newInstallmentPayment = InstallmentTableModel(
          sequenceNo: nextSequenceNo,
          planId: planId,
          description: 'Installment $nextSequenceNo',
          dueDate: newDueDate.toIso8601String(),
          paidDate: 'not yet',
          amountDue: remainingAmountValue.toString(),
          paidAmount: '0.0',
          remarks: currentInstallment.remarks,
          remaining: remainingAmountValue.toString(),
          status: InstallmentStatus.pending.toString().split('.').last,
          action: currentInstallment.action,
        );

        currentInstallmentPayments.add(newInstallmentPayment);
      }

      // Step 5: Update the local state
      currentInstallmentPayments.refresh();

      // Step 6: Call the repository to update the database
      await installmentRepository.updateInstallmentPayment(
        sequenceNo,
        planId,
        paidAmount.text,
        remainingAmount.value.text,
      );

    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        print(e);
      }
    }
  }


  Future<void> fetchSpecificInstallmentPayment(int orderId) async {
    try {
      isLoading.value = true;
      currentInstallmentPayments.clear();
      final planId = await installmentRepository.fetchPlanId(orderId);
      if (planId == null) {
        TLoader.errorSnackBar(title: 'Fetch Plan Issue!');
      } else {
        final payments = await installmentRepository
            .fetchSpecifcInstallmentPlanItems(planId);
        currentInstallmentPayments.assignAll(payments);
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCustomerInfo(int customerId) {
    try {
      // Set loading state to true
      isCustomerLoading.value = true;

      // Fetch customer data based on orderId
      final customerData = customerController.allCustomers.firstWhere(
        (customer) => customer.customerId == customerId,
        orElse: () => CustomerModel.empty(), // Fallback if no customer is found
      );

      // If customer data is found, process it
      if (customerData != CustomerModel.empty()) {
        selectedCustomer.value = customerData;
      } else {
        TLoader.warningSnackBar(
            title: 'Not Found',
            message: 'No customer found for the given order ID.');
      }
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Set loading state to false
      isCustomerLoading.value = false;
    }
  }

  void addProduct() {
    try {} catch (e) {
      TLoader.errorSnackBar(title: 'Adding Data', message: e.toString());
    }
  }

  void updateINCLExMargin() {
    try {
      // Convert strings to double and then perform the addition
      double billAmountDouble = double.tryParse(billAmount.value.text) ?? 0.0;
      double downPaymentDouble = double.tryParse(DownPayment.text) ?? 0.0;
      double documentChargesDouble =
          double.tryParse(DocumentCharges.text) ?? 0.0;
      double otherChargesDouble = double.tryParse(otherCharges.text) ?? 0.0;
      double marginDouble = double.tryParse(margin.text) ?? 0.0;

      // Convert margin percentage to decimal
      double marginAsDecimal = marginDouble / 100;

      // Perform the addition
      double _payableExMargin = billAmountDouble +
          downPaymentDouble +
          documentChargesDouble +
          otherChargesDouble;
      double _payableINCLMargin =
          _payableExMargin + (_payableExMargin * marginAsDecimal);

      // Convert the result back to string if you want to display it in the text fields
      payableExMargin.value.text = _payableExMargin.toString();
      payableINCLMargin.value.text = _payableINCLMargin.toString();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void generatePlan() {
    try {
      // Clear existing plans
      currentInstallmentPayments.clear();

      // Parse inputs with validation
      int numberOfInstallments = int.tryParse(NoOfInstallments.text) ?? 0;
      double billAmountValue = double.tryParse(billAmount.value.text) ?? 0.0;
      double downPaymentValue = double.tryParse(DownPayment.text) ?? 0.0;



      // Validate inputs
      if (billAmountValue <= 0) {
        TLoader.errorSnackBar(
          title: 'Invalid Data',
          message: 'Bill Amount must be greater than zero.',
        );
        return;
      }
      if (downPaymentValue < 0) {
        TLoader.errorSnackBar(
          title: 'Invalid Data',
          message: 'Down Payment cannot be negative.',
        );
        return;
      }
      if (downPaymentValue > billAmountValue) {
        TLoader.errorSnackBar(
          title: 'Invalid Data',
          message: 'Down Payment cannot exceed Bill Amount.',
        );
        return;
      }
      if (numberOfInstallments <= 0) {
        TLoader.errorSnackBar(
          title: 'Invalid Data',
          message: 'Number of Installments must be at least 1.',
        );
        return;
      }

      //generate installment plan before installment payments
      currentInstallmentPlan.value = InstallmentPlanModel(
        // Example values; you need to populate this properly
        installmentPlanId: -1, // not count
        //orderId: orderId, will be added at saving time
        totalAmount: billAmount.value.text,
        documentCharges: DocumentCharges.text,
        margin: margin.text,
        otherCharges: otherCharges.text,
        note: note.text,
        duration: durationController.value.toString().split('.').last,
        downPayment: DownPayment.text,
        numberOfInstallments: NoOfInstallments.text,
        firstInstallmentDate: selectedDate,
        frequencyInMonth: durationController == DurationType.Monthly
            ? "1"
            : durationController == DurationType.Quarterly
            ? "3"
            : "12",
        installemtPaymentList:
        currentInstallmentPayments, // Converts RxList to a standard List
       // guarantor1_id: guarranteIds[0],
      //  guarantor2_id: guarranteIds[1],
        // Pass the generated installment plans
      );

      double remainingAmount = billAmountValue - downPaymentValue;

      // If no remaining amount, add only advance payment
      if (remainingAmount <= 0) {
        currentInstallmentPayments.add(
          InstallmentTableModel(
            sequenceNo: 0,
            description: "Advance Payment",
            dueDate: DateTime.now().toIso8601String(),
            paidDate: DateTime.now().toIso8601String(),
            paidAmount: downPaymentValue.toStringAsFixed(2),
            remarks: note.text,
            remaining: "0",
            status: InstallmentStatus.paid.toString().split('.').last,
            action: "N/A",
            amountDue: downPaymentValue.toStringAsFixed(2),
          ),
        );
        return;
      }

      // Calculate installments with remainder adjustment
      double installmentAmount = remainingAmount / numberOfInstallments;
      double roundedInstallment = double.parse(installmentAmount.toStringAsFixed(2));
      double totalRounded = roundedInstallment * (numberOfInstallments - 1);
      double lastInstallment = remainingAmount - totalRounded;

      // Add advance payment
      currentInstallmentPayments.add(
        InstallmentTableModel(
          sequenceNo: 0,
          description: "Advance Payment",
          dueDate: DateTime.now().toIso8601String(),
          paidDate: DateTime.now().toIso8601String(),
          paidAmount: downPaymentValue.toStringAsFixed(2),
          remarks: note.text,
          remaining: "0",
          status: InstallmentStatus.paid.toString().split('.').last,
          action: "N/A",
          amountDue: downPaymentValue.toStringAsFixed(2),
        ),
      );

      DateTime currentDate = selectedDate ?? DateTime.now();

      // Generate installments with correct dates and amounts
      for (int i = 1; i <= numberOfInstallments; i++) {
        DateTime dueDate;
        switch (durationController.value) {
          case DurationType.Monthly:
            dueDate = DateTime(currentDate.year, currentDate.month + i, currentDate.day);
            break;
          case DurationType.Quarterly:
            dueDate = DateTime(currentDate.year, currentDate.month + (i * 3), currentDate.day);
            break;
          case DurationType.Yearly:
            dueDate = DateTime(currentDate.year + i, currentDate.month, currentDate.day);
            break;
          default:
            dueDate = currentDate.add(Duration(days: 30 * i));
        }

        // Handle end-of-month edge cases (e.g., adding months to a day that doesn't exist in the target month)
        if (dueDate.month != currentDate.month + i && durationController.value == DurationType.Monthly) {
          dueDate = DateTime(dueDate.year, dueDate.month + 1, 0);
        }

        double amount = (i == numberOfInstallments) ? lastInstallment : roundedInstallment;

        currentInstallmentPayments.add(
          InstallmentTableModel(
            sequenceNo: i,
            description: "Installment $i",
            dueDate: dueDate.toIso8601String(),
            paidDate: null,
            paidAmount: "0.00",
            remarks: "",
            remaining: amount.toStringAsFixed(2),
            status: InstallmentStatus.pending.toString().split('.').last,
            action: "Pay Now",
            amountDue: amount.toStringAsFixed(2),
          ),
        );
      }

    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> savePlan() async {
    try {
      int orderId = await salesController.checkOut();
      List<int> guarranteIds = await guarantorController.uploadGuarantors();

      currentInstallmentPlan.value.orderId = orderId;
      currentInstallmentPlan.value.guarantor1_id = guarranteIds[0];
      currentInstallmentPlan.value.guarantor2_id = guarranteIds[1];
      // Now, call the uploadInstallmentPlan function to upload the generated plan


      // Call the uploadInstallmentPlan function
      await installmentRepository.uploadInstallmentPlanAndPayment(currentInstallmentPlan.value, orderId);
      Get.to(() => InstallmentReportPage(
        installmentPlans: currentInstallmentPayments,
        cashierName: 'Ammer',
        companyName: 'OMGz',
        branchName: 'MAIN',
      ));
    } catch (e) {

      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(
          title: 'Oh Snap! ya hoo',
          message: e.toString(),
        );
      }
    }
  }


  void clearAllFields() {
    billAmount.value.clear();
    NoOfInstallments.clear();
    DownPayment.clear();
    DocumentCharges.clear();
    margin.clear();
    note.clear();
    frequencyInMonth.clear();
    otherCharges.clear();
    payableExMargin.value.clear();
    payableINCLMargin.value.clear();
    durationController.value = DurationType.Duration; // Reset to default
    currentInstallmentPlan.value = InstallmentPlanModel.empty();
    currentInstallmentPayments.clear();
  }

}
