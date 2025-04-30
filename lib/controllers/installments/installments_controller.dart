import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/repositories/installment/installment_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Models/installments/installemt_plan_model.dart';
import '../../Models/installments/installment_payment_model.dart';
import '../../Models/installments/installment_table_model/installment_table_model.dart';
import '../../views/reports/specific_reports/installment_plans/installment_plan_report.dart';
import '../guarantors/guarantor_controller.dart';
import '../guarantors/guarantor_image_controller.dart';
import '../sales/sales_controller.dart';
import '../media/media_controller.dart';

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
  final isUpdating = false.obs;

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

  // Refund related variables
  final includeShippingInRefund = false.obs;
  final includeTaxInRefund = false.obs;
  final includeDocumentChargesInRefund = false.obs;
  final includeOtherChargesInRefund = false.obs;
  final includeAdvancePaymentInRefund = true.obs;
  final includeSalesmanCommissionInRefund = false.obs;
  final includeMarginInRefund = false.obs;
  final totalOrderAmount = 0.0.obs;
  final totalPaidAmount = 0.0.obs;
  final shippingAmount = 0.0.obs;
  final taxAmount = 0.0.obs;
  final documentChargesAmount = 0.0.obs;
  final otherChargesAmount = 0.0.obs;
  final advancePaymentAmount = 0.0.obs;
  final installmentsPaidAmount = 0.0.obs;
  final salesmanCommissionAmount = 0.0.obs;
  final marginAmount = 0.0.obs;
  final refundAmount = 0.0.obs;
  final isProcessingRefund = false.obs;
  final RxBool shouldShowRefundReport = false.obs;

  //Installment table (Global)
  Rx<InstallmentPlanModel> currentInstallmentPlan =
      InstallmentPlanModel.empty().obs;
  RxList<InstallmentTableModel> currentInstallmentPayments =
      <InstallmentTableModel>[].obs;
  //final List<InstallmentTableModel> installmentPayments;

  //Installment Table

  final paidAmount = TextEditingController();
  final remainingAmount = TextEditingController().obs;

  //final RxList<>

  //OrderDetails
  // Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;

  void resetFormFields() {
    try {
      paidAmount.clear();
      remainingAmount.value.clear();
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        print(e);
      }
    }
  }

  Future<void> updateInstallmentPayments(int sequenceNo, int planId) async {
    try {
      // Step 1: Find the current installment in the local list
      isUpdating.value = true;
      final currentInstallment = currentInstallmentPayments.firstWhere(
        (installment) =>
            installment.sequenceNo == sequenceNo &&
            installment.planId == planId,
        orElse: () => throw Exception('Current installment not found'),
      );
      print(planId);
      // Validate planId
      if (planId <= 0) {
        TLoader.errorSnackBar(
            title: 'Invalid Plan ID',
            message: 'Please ensure the installment plan is properly saved.');
        return;
      }

      // Step 2: Parse the paidAmount and remainingAmount
      final paidAmountValue = double.tryParse(paidAmount.text) ?? 0.0;
      final remainingAmountValue =
          double.tryParse(remainingAmount.value.text) ?? 0.0;

      // Step 3: Update the current installment
      currentInstallment.paidDate = DateTime.now().toIso8601String();
      currentInstallment.status =
          InstallmentStatus.paid.toString().split('.').last;
      currentInstallment.paidAmount = paidAmountValue.toString();
      currentInstallment.remaining =
          (double.tryParse(currentInstallment.amountDue) ??
                  0.0 - paidAmountValue)
              .toString();

      // Step 4: Check if remaining amount is zero, if yes, don't create new installment
      if (remainingAmountValue <= 0) {
        // Mark the current installment as the final one
        // Update the plan status to completed
        await installmentRepository.updateInstallmentPlanStatus(
          planId,
          InstallmentStatus.completed.toString().split('.').last,
        );

        // Update the current installment to show zero remaining
        currentInstallment.remaining = "0.0";

        // Mark all installments as having a plan status of completed for UI purposes
        for (var installment in currentInstallmentPayments) {
          if (installment.planId == planId) {
            // Only update the action if it's not already "N/A"
            if (installment.action != "N/A") {
              installment.action = "Completed";
            }
          }
        }

        // Get the orderId associated with this installment plan
        final orderId = await installmentRepository.getOrderIdForPlan(planId);

        if (orderId != null) {
          // Update the order status to completed
          await installmentRepository.updateOrderStatus(
              orderId, OrderStatus.completed.toString().split('.').last);

          // If we need to update the UI or any controllers that show order status
          if (Get.isRegistered<OrderController>()) {
            final orderController = Get.find<OrderController>();
            // Update the selected status if this is the current order being viewed
            orderController.selectedStatus.value = OrderStatus.completed;
            // Refresh the orders list to get updated status from database
            orderController.fetchOrders();
          }
        }

        // Update the local state
        currentInstallmentPayments.refresh();

        // Update the database for current installment
        await installmentRepository.updateInstallmentPayment(
          sequenceNo,
          planId,
          paidAmount.text,
          "0.0", // Ensure zero remaining amount is saved
        );

        TLoader.successSnackBar(
          title: 'Plan Completed',
          message: 'All installments have been paid successfully!',
        );
        return;
      }

      // Continue with existing logic for non-zero remaining amounts
      // Step 5: Find the next installment in the local list
      final nextSequenceNo = sequenceNo + 1;
      final nextInstallmentIndex = currentInstallmentPayments.indexWhere(
        (installment) =>
            installment.sequenceNo == nextSequenceNo &&
            installment.planId == planId,
      );

      if (nextInstallmentIndex != -1) {
        // If the next installment exists, update its amountDue
        final nextInstallment =
            currentInstallmentPayments[nextInstallmentIndex];
        final nextAmountDue = double.tryParse(nextInstallment.amountDue) ?? 0.0;
        final updatedAmountDue = nextAmountDue + remainingAmountValue;
        nextInstallment.amountDue = updatedAmountDue.toString();
      } else {
        // If no next installment exists
        if (planId == 0) {
          TLoader.errorSnackBar(
              title: 'Plan Error',
              message: 'Reset and generate the plan again.');
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
          final secondLastDate = DateTime.parse(
              previousInstallments[previousInstallments.length - 2].dueDate);
          final averageInterval = lastDate.difference(secondLastDate);
          newDueDate = lastDate.add(averageInterval);
        } else if (previousInstallments.length == 1) {
          newDueDate = DateTime.parse(currentInstallment.dueDate)
              .add(const Duration(days: 30));
        } else {
          newDueDate = DateTime.now().add(const Duration(days: 30));
        }

        // If the next installment doesn't exist, create a new one
        final newInstallment = InstallmentPayment(
          sequenceNo: nextSequenceNo,
          installmentPlanId:
              planId, // This was the issue - ensure planId is valid
          dueDate: newDueDate.toIso8601String(),
          amountDue: remainingAmountValue.toString(),
          paidAmount: '0.0',
          status: InstallmentStatus.pending.toString().split('.').last,
        );

        final paymentJson = newInstallment.toJson(isUpdate: true);
        await installmentRepository.insertInstallmentPayment(paymentJson);
        TLoader.successSnackBar(
            title: 'Success', message: 'New Installment Data Added!');

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

      // Step 6: Update the local state
      currentInstallmentPayments.refresh();

      // Step 7: Call the repository to update the database
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
    } finally {
      isUpdating.value = false;
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
      double documentChargesValue =
          double.tryParse(DocumentCharges.text) ?? 0.0;
      double otherChargesValue = double.tryParse(otherCharges.text) ?? 0.0;
      double marginValue = double.tryParse(margin.text) ?? 0.0;

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

      // Parse frequency as integer
      int frequency = int.tryParse(frequencyInMonth.text) ?? 0;
      // Use the provided frequency or set a default based on duration type
      if (frequency <= 0) {
        frequency = durationController.value == DurationType.Monthly
            ? 1
            : durationController.value == DurationType.Quarterly
                ? 3
                : 12;
      }

      // Generate installment plan before installment payments
      currentInstallmentPlan.value = InstallmentPlanModel(
        installmentPlanId: null, // not count
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
        frequencyInMonth: frequency.toString(),
      );

      // Calculate remaining amount including all charges
      double baseRemainingAmount = billAmountValue - downPaymentValue;

      // Calculate margin amount if applicable
      double marginAmount = 0.0;
      if (marginValue > 0) {
        marginAmount = baseRemainingAmount * (marginValue / 100);
      }

      // Total amount to be distributed across installments
      double totalRemainingWithCharges = baseRemainingAmount +
          documentChargesValue +
          otherChargesValue +
          marginAmount;

      // If no remaining amount, add only advance payment
      if (totalRemainingWithCharges <= 0) {
        currentInstallmentPayments.add(
          InstallmentTableModel(
            sequenceNo: 0,
            planId: 0, // Will be updated after saving
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
      double installmentAmount =
          totalRemainingWithCharges / numberOfInstallments;
      double roundedInstallment =
          double.parse(installmentAmount.toStringAsFixed(2));
      double totalRounded = roundedInstallment * (numberOfInstallments - 1);
      double lastInstallment = totalRemainingWithCharges - totalRounded;

      // Add advance payment
      currentInstallmentPayments.add(
        InstallmentTableModel(
          sequenceNo: 0,
          planId: 0, // Will be updated after saving
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

        // Calculate the due date based on the duration type and frequency
        try {
          switch (durationController.value) {
            case DurationType.Monthly:
              // Add months based on frequency and installment number
              dueDate = _addMonths(currentDate, i * frequency);
              break;
            case DurationType.Quarterly:
              // Add months based on quarterly frequency (3 months) and installment number
              dueDate = _addMonths(currentDate, i * frequency);
              break;
            case DurationType.Yearly:
              // Add years based on installment number
              dueDate = DateTime(
                  currentDate.year + i, currentDate.month, currentDate.day);
              break;
            default:
              dueDate = _addMonths(currentDate, i);
          }
        } catch (e) {
          // Fallback in case of date calculation error
          dueDate = currentDate.add(Duration(days: 30 * i * frequency));
        }

        double amount =
            (i == numberOfInstallments) ? lastInstallment : roundedInstallment;

        currentInstallmentPayments.add(
          InstallmentTableModel(
            sequenceNo: i,
            planId: 0, // Will be updated after saving
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

  // Helper method to correctly add months to a date and handle month end edge cases
  DateTime _addMonths(DateTime date, int monthsToAdd) {
    // Calculate target month and year
    int targetMonth = date.month + monthsToAdd;
    int targetYear = date.year + (targetMonth - 1) ~/ 12;
    targetMonth = ((targetMonth - 1) % 12) + 1; // Adjust month to be 1-12

    // Get last day of target month
    int lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0).day;

    // Ensure day is valid for the target month
    int targetDay = date.day <= lastDayOfMonth ? date.day : lastDayOfMonth;

    return DateTime(targetYear, targetMonth, targetDay);
  }

  Future<void> savePlan() async {
    try {
      final guarantorImageController = Get.find<GuarantorImageController>();
      final mediaController = Get.find<MediaController>();
      int orderId = await salesController.checkOut();

      // Set the images in the guarantor controller before uploading
      guarantorController.guarrantor1Image.value =
          guarantorImageController.guarantor1Image.value;
      guarantorController.guarrantor2Image.value =
          guarantorImageController.guarantor2Image.value;

      List<int> guarranteIds = await guarantorController.uploadGuarantors();

      final installmentPaymentList =
          InstallmentPayment.getInstallmentPaymentsFromTable(
              currentInstallmentPayments);
      currentInstallmentPlan.value.installmentPaymentList =
          installmentPaymentList;
      currentInstallmentPlan.value.orderId = orderId;
      currentInstallmentPlan.value.guarantor1_id = guarranteIds[0];
      currentInstallmentPlan.value.guarantor2_id = guarranteIds[1];
      // Now, call the uploadInstallmentPlan function to upload the generated plan

      // Call the uploadInstallmentPlan function
      await installmentRepository.uploadInstallmentPlanAndPayment(
          currentInstallmentPlan.value, orderId);

      // Clear the images after successful upload and save guarantor images with correct IDs
      await guarantorImageController.saveGuarantorImages(guarranteIds);

      Get.to(() => InstallmentReportPage(
            installmentPlans: currentInstallmentPayments,
            cashierName: 'Ammer',
            companyName: 'OMGz',
            branchName: 'MAIN',
          ));

      // Clear all variables after successful installment creation
      clearAllFields();
      guarantorImageController.clearGuarantorImages();
      mediaController.displayImage.value = null;
      salesController.clearSaleDetails();
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
    // billAmount.value.clear();
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

  // Helper method to get color based on installment status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get appropriate text color for status background
  Color getStatusTextColor(String status) {
    return Colors.white; // White text works well on all our status colors
  }

  // Initializes refund data when an order status changes to cancelled
  void initializeRefundData(OrderModel order) {
    try {
      // Reset all refund-related data - all toggles start as enabled
      includeShippingInRefund.value = true;
      includeTaxInRefund.value = true;
      includeDocumentChargesInRefund.value = true;
      includeOtherChargesInRefund.value = true;
      includeAdvancePaymentInRefund.value = true;
      includeSalesmanCommissionInRefund.value = true;
      includeMarginInRefund.value = true;
      isProcessingRefund.value = false;

      // Set the initial base order amount (product subtotal without any charges)
      double baseOrderAmount = order.orderItems?.fold<double>(
            0.0,
            (previousValue, element) =>
                (previousValue ?? 0.0) + (element.price * element.quantity),
          ) ??
          0.0;

      // Set shipping amount from order
      shippingAmount.value = order.shippingFee;

      // Set tax amount from order
      taxAmount.value = order.tax;

      // Calculate salesman commission amount (convert from percentage to amount)
      // Base commission on the subtotal, not the total which would include tax and shipping
      salesmanCommissionAmount.value =
          baseOrderAmount * (order.salesmanComission / 100.0);

      // Load installment plan details for this order if needed
      if (currentInstallmentPlan.value.installmentPlanId == null ||
          currentInstallmentPlan.value.orderId != order.orderId) {
        // Fetch the installment plan for this order
        fetchInstallmentPlanForRefund(order.orderId);
      } else {
        updateRefundValuesFromPlan();
      }

      // Show the refund report
      shouldShowRefundReport.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing refund data: $e');
      }
      TLoader.errorSnackBar(
        title: 'Error',
        message: 'Could not calculate refund: ${e.toString()}',
      );
    }
  }

  // Updates refund values from the current installment plan
  void updateRefundValuesFromPlan() {
    try {
      // Extract values from the installment plan
      final String downPaymentStr =
          currentInstallmentPlan.value.downPayment.trim();
      final String documentChargesStr =
          currentInstallmentPlan.value.documentCharges?.trim() ?? '0.0';
      final String otherChargesStr =
          currentInstallmentPlan.value.otherCharges?.trim() ?? '0.0';
      final String marginStr =
          currentInstallmentPlan.value.margin?.trim() ?? '0.0';
      final String totalAmountStr =
          currentInstallmentPlan.value.totalAmount.trim();

      // Parse values safely
      final double downPayment = double.tryParse(downPaymentStr) ?? 0.0;
      final double documentCharges = double.tryParse(documentChargesStr) ?? 0.0;
      final double otherCharges = double.tryParse(otherChargesStr) ?? 0.0;
      final double marginPercentage = double.tryParse(marginStr) ?? 0.0;
      final double totalAmount = double.tryParse(totalAmountStr) ?? 0.0;

      // Calculate margin amount
      final double baseAmount = totalAmount - downPayment;
      final double margin = baseAmount * (marginPercentage / 100.0);

      // The base product amount without any extras
      double productSubtotal = totalAmount;

      // Calculate total order amount including all charges (as it would appear on the invoice)
      double orderTotal = productSubtotal; // Start with product subtotal
      orderTotal += documentCharges; // Add document charges
      orderTotal += otherCharges; // Add other charges
      orderTotal += margin; // Add margin
      orderTotal += taxAmount.value; // Add tax
      orderTotal += shippingAmount.value; // Add shipping

      // Update the Rx variables
      advancePaymentAmount.value = downPayment;
      documentChargesAmount.value = documentCharges;
      otherChargesAmount.value = otherCharges;
      marginAmount.value = margin;
      totalOrderAmount.value = orderTotal;

      // Calculate installments paid
      calculateInstallmentsPaid();

      // Total paid is advance payment plus installments
      totalPaidAmount.value = downPayment + installmentsPaidAmount.value;

      // Calculate refund amount
      calculateRefundAmount();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating refund values: $e');
      }
    }
  }

  // Calculates the amount paid through installments
  void calculateInstallmentsPaid() {
    double paidInstallments = 0.0;
    for (var payment in currentInstallmentPayments) {
      final paymentStatus = payment.status?.toLowerCase() ?? '';
      // Only count actual installments (not the advance payment which is sequence 0)
      if (paymentStatus ==
              InstallmentStatus.paid.toString().split('.').last.toLowerCase() &&
          payment.sequenceNo > 0) {
        paidInstallments += double.tryParse(payment.paidAmount ?? '0.0') ?? 0.0;
      }
    }
    installmentsPaidAmount.value = paidInstallments;
  }

  // Fetch the installment plan for a specific order
  Future<void> fetchInstallmentPlanForRefund(int orderId) async {
    try {
      // Get the plan ID for this order
      final planId = await installmentRepository.fetchPlanId(orderId);

      if (planId != null) {
        // Fetch the complete installment plan
        final plan = await installmentRepository.fetchInstallmentPlan(planId);

        if (plan != null) {
          // Update the current plan
          currentInstallmentPlan.value = plan;

          // Update refund values based on the plan
          updateRefundValuesFromPlan();

          // Make sure the UI shows the refund report
          shouldShowRefundReport.value = true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching installment plan: $e');
      }
    }
  }

  // Toggle a refund option and recalculate
  void toggleRefundOption(String option, bool value) {
    switch (option) {
      case 'shipping':
        includeShippingInRefund.value = value;
        break;
      case 'tax':
        includeTaxInRefund.value = value;
        break;
      case 'document':
        includeDocumentChargesInRefund.value = value;
        break;
      case 'other':
        includeOtherChargesInRefund.value = value;
        break;
      case 'advance':
        includeAdvancePaymentInRefund.value = value;
        break;
      case 'commission':
        includeSalesmanCommissionInRefund.value = value;
        break;
      case 'margin':
        includeMarginInRefund.value = value;
        break;
    }

    if (kDebugMode) {
      print('Toggle $option: $value');
      print('includeShippingInRefund: ${includeShippingInRefund.value}');
      print('includeTaxInRefund: ${includeTaxInRefund.value}');
      print(
          'includeDocumentChargesInRefund: ${includeDocumentChargesInRefund.value}');
      print(
          'includeOtherChargesInRefund: ${includeOtherChargesInRefund.value}');
      print(
          'includeAdvancePaymentInRefund: ${includeAdvancePaymentInRefund.value}');
      print(
          'includeSalesmanCommissionInRefund: ${includeSalesmanCommissionInRefund.value}');
      print('includeMarginInRefund: ${includeMarginInRefund.value}');
    }

    calculateRefundAmount();
    update(); // Ensure UI updates
  }

  // Calculates the refund amount based on current settings
  void calculateRefundAmount() {
    // Start with installment payments which are always included
    double calculatedRefund = installmentsPaidAmount.value;

    // Conditionally include advance payment (previously enabled by default)
    if (includeAdvancePaymentInRefund.value) {
      calculatedRefund += advancePaymentAmount.value;
    }

    // Conditionally include shipping
    if (includeShippingInRefund.value) {
      calculatedRefund += shippingAmount.value;
    }

    // Conditionally include tax
    if (includeTaxInRefund.value) {
      calculatedRefund += taxAmount.value;
    }

    // Conditionally include document charges
    if (includeDocumentChargesInRefund.value) {
      calculatedRefund += documentChargesAmount.value;
    }

    // Conditionally include other charges
    if (includeOtherChargesInRefund.value) {
      calculatedRefund += otherChargesAmount.value;
    }

    // Conditionally include margin
    if (includeMarginInRefund.value) {
      calculatedRefund += marginAmount.value;
    }

    // Conditionally include salesman commission
    if (includeSalesmanCommissionInRefund.value) {
      calculatedRefund += salesmanCommissionAmount.value;
    }

    // Update the refund amount
    refundAmount.value = calculatedRefund;

    // Print debug information
    if (kDebugMode) {
      print('-------- Refund Calculation --------');
      print('Installment Payments: ${installmentsPaidAmount.value}');
      print(
          'Advance Payment: ${includeAdvancePaymentInRefund.value ? advancePaymentAmount.value : 0}');
      print(
          'Shipping: ${includeShippingInRefund.value ? shippingAmount.value : 0}');
      print('Tax: ${includeTaxInRefund.value ? taxAmount.value : 0}');
      print(
          'Document Charges: ${includeDocumentChargesInRefund.value ? documentChargesAmount.value : 0}');
      print(
          'Other Charges: ${includeOtherChargesInRefund.value ? otherChargesAmount.value : 0}');
      print('Margin: ${includeMarginInRefund.value ? marginAmount.value : 0}');
      print(
          'Salesman Commission: ${includeSalesmanCommissionInRefund.value ? salesmanCommissionAmount.value : 0}');
      print('Total Refund Amount: ${refundAmount.value}');
      print('-----------------------------------');
    }

    // Force UI update
    update();
  }

  // Process the actual refund
  Future<void> processRefund() async {
    try {
      isProcessingRefund.value = true;

      // Get the current plan ID
      final planId = currentInstallmentPayments.isNotEmpty
          ? currentInstallmentPayments.first.planId
          : -1;

      if (planId <= 0) {
        throw Exception('Invalid plan ID. Cannot process refund.');
      }

      // Get the order ID for this plan
      final orderId = await installmentRepository.getOrderIdForPlan(planId);
      if (orderId == null) {
        throw Exception('Could not find associated order.');
      }

      // Recalculate the refund amount to ensure it's up to date
      calculateRefundAmount();

      if (kDebugMode) {
        print(
            'Processing refund for order $orderId with amount ${refundAmount.value}');
      }

      // Record the refund in the database with all settings
      await installmentRepository.recordRefund(
        orderId,
        totalPaidAmount.value,
        refundAmount.value,
        includeShippingInRefund.value,
        includeTaxInRefund.value,
        includeDocumentChargesInRefund.value,
        includeOtherChargesInRefund.value,
        includeAdvancePaymentInRefund.value,
        includeSalesmanCommissionInRefund.value,
        includeMarginInRefund.value,
        advancePaymentAmount.value,
        installmentsPaidAmount.value,
        documentChargesAmount.value,
        otherChargesAmount.value,
        salesmanCommissionAmount.value,
        marginAmount.value,
      );

      // Update the UI state
      TLoader.successSnackBar(
        title: 'Refund Processed',
        message:
            'Refund of Rs. ${refundAmount.value.toStringAsFixed(2)} has been processed.',
      );

      // In a real app, you might want to trigger receipt printing or other actions here
    } catch (e) {
      if (kDebugMode) {
        print('Error processing refund: $e');
      }
      TLoader.errorSnackBar(
        title: 'Refund Failed',
        message: e.toString(),
      );
    } finally {
      isProcessingRefund.value = false;
      update(); // Ensure UI updates
    }
  }
}
