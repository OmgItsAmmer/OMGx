
import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/repositories/installment/installment_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Models/installments/installemt_plan_model.dart';
import '../../Models/installments/installment_table_model/installment_table_model.dart';
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
  RxList<InstallmentTableModel> installmentPlans =
      <InstallmentTableModel>[].obs;
  //final List<InstallmentTableModel> installmentPayments;


  //Installment Table

  final paidAmount = TextEditingController();
  final remainingAmount = TextEditingController().obs;

  //final RxList<>

  //OrderDetails
  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;




  Future<void> updateInstallmentPlan(int sequenceNo, int planId) async {
    try {
      // Step 1: Find the current installment in the local list
      final currentInstallment = installmentPlans.firstWhere(
            (installment) =>
        installment.sequenceNo == sequenceNo &&
            installment.planId == planId,
        orElse: () => throw Exception('Current installment not found'),
      );

      // Step 2: Parse the paidAmount and remainingAmount
      final paidAmountValue = double.tryParse(paidAmount.text) ?? 0.0;
      final remainingAmountValue = double.tryParse(remainingAmount.value.text) ?? 0.0;

      // Step 3: Update the current installment
      currentInstallment.paidDate = DateTime.now().toIso8601String();
      currentInstallment.status = 'paid';
      currentInstallment.paidAmount = paidAmountValue.toString();
      currentInstallment.remaining = (double.tryParse(currentInstallment.amountDue) ?? 0.0 - paidAmountValue).toString();

      // Step 4: Find the next installment in the local list
      final nextSequenceNo = sequenceNo + 1;
      final nextInstallmentIndex = installmentPlans.indexWhere(
            (installment) =>
        installment.sequenceNo == nextSequenceNo &&
            installment.planId == planId,
      );

      if (nextInstallmentIndex != -1) {
        // If the next installment exists, update its amountDue
        final nextInstallment = installmentPlans[nextInstallmentIndex];
        final nextAmountDue = double.tryParse(nextInstallment.amountDue) ?? 0.0;
        final updatedAmountDue = nextAmountDue + remainingAmountValue;

        nextInstallment.amountDue = updatedAmountDue.toString();
      } else {
        // If the next installment doesn't exist, create a new one
        final newInstallment = InstallmentTableModel(
          sequenceNo: nextSequenceNo,
          planId: planId,
          description: currentInstallment.description, // Copy description from current installment
          dueDate: DateTime.now().toIso8601String(), // Set due date as needed
          paidDate: 'not yet',
          amountDue: remainingAmountValue.toString(),
          paidAmount: '0.0',
          remarks: currentInstallment.remarks, // Copy remarks from current installment
          remaining: remainingAmountValue.toString(),
          status: 'pending',
          action: currentInstallment.action, // Copy action from current installment
        );
        final paymentJson = newInstallment.toJson(includePlanId: true);
        await installmentRepository.uploadInstallmentPayment(paymentJson);
        installmentPlans.add(newInstallment);
      }

      // Step 5: Update the local state
      installmentPlans.refresh(); // Notify listeners of changes

      // Step 6: Call the repository to update the database
      await installmentRepository.updateInstallmentPlan(
        sequenceNo,
        planId,
        paidAmount.text,
        remainingAmount.value.text,
      );

      // Optionally, show a success message
      TLoader.successSnackBar(title: 'Success', message: 'Installment updated successfully');
    } catch (e) {
      // Handle errors and show a snackbar
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
    }
  }

  Future<void> fetchSpecificInstallmentPayment(int orderId) async {
    try {
      isLoading.value = true;
      installmentPlans.clear();
      final planId = await installmentRepository.fetchPlanId(orderId);
      if (planId == null) {
        TLoader.errorSnackBar(title: 'Fetch Plan Issue!');
      } else {
        final payments = await installmentRepository
            .fetchSpecifcInstallmentPlanItems(planId);
        installmentPlans.assignAll(payments);
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
      // Parse the required inputs
      int numberOfInstallments = int.tryParse(NoOfInstallments.text) ?? 0;
      double billAmountValue = double.tryParse(billAmount.value.text) ?? 0.0;
      double downPaymentValue = double.tryParse(DownPayment.text) ?? 0.0;

      // Calculate the amount to be divided across installments
      double remainingAmount = billAmountValue - downPaymentValue;
      if (remainingAmount < 0) {
        TLoader.errorSnackBar(
          title: 'Invalid Data',
          message: 'Down Payment cannot exceed Bill Amount.',
        );
        return;
      }

      double installmentAmount = remainingAmount / numberOfInstallments;

      // Generate installment plans
      DateTime currentDate = selectedDate ?? DateTime.now();

      // Determine the duration in days based on the selected DurationType
      final DurationType selectedDuration = durationController.value;
      int installmentDurationInDays;

      switch (selectedDuration) {
        case DurationType.Monthly:
          installmentDurationInDays =
              30; // Approximate number of days in a month
          break;
        case DurationType.Quarterly:
          installmentDurationInDays =
              90; // Approximate number of days in a quarter
          break;
        case DurationType.Yearly:
          installmentDurationInDays =
              365; // Approximate number of days in a year
          break;
        default:
          installmentDurationInDays =
              30; // Default to monthly if Duration is selected
      }

      // Add advance payment info at index 0
      installmentPlans.insert(
        0,
        InstallmentTableModel(
          sequenceNo: 0,
          description: "Advance Payment",
          dueDate:
              currentDate.toIso8601String(), // Current date for advance payment
          paidDate: currentDate.toIso8601String(), // Paid on current date
          paidAmount: downPaymentValue.toStringAsFixed(2),
          remarks: note.text,
          remaining: "0", // No remaining amount for advance
          status: "Paid",
          action: "N/A", // No action needed
          amountDue:
              downPaymentValue.toStringAsFixed(2), // Set the amount as advance
        ),
      );

      // Generate installment plans
      for (int i = 1; i <= numberOfInstallments; i++) {
        DateTime dueDate = currentDate.add(Duration(
            days: i * installmentDurationInDays)); // Using dynamic duration

        installmentPlans.add(
          InstallmentTableModel(
            sequenceNo: i,
            description: "Installment $i",
            dueDate: dueDate.toIso8601String(), // Only date part
            paidDate: null, // Initially empty
            paidAmount: "0", // Initially unpaid
            remarks: "",
            remaining: installmentAmount.toStringAsFixed(2),
            status: "Pending",
            action: "Pay Now",
            amountDue: installmentAmount.toStringAsFixed(2), // Added the amount
          ),
        );
      }

      // Log or process the generated plans as needed
      print(installmentPlans.map((plan) => plan.toJson()).toList());
    } catch (e) {
      TLoader.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  Future<void> savePlan() async {
    try {
      int orderId = await salesController.checkOut();
      List<int> guarranteIds = await guarantorController.uploadGuarantors();


      // Now, call the uploadInstallmentPlan function to upload the generated plan
      final InstallmentPlanModel planModel = InstallmentPlanModel(
        // Example values; you need to populate this properly
        installmentPlanId: -1, // not count
        orderId: orderId,
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
            installmentPlans, // Converts RxList to a standard List
        guarantor1_id: guarranteIds[0],
        guarantor2_id: guarranteIds[1],
        // Pass the generated installment plans
      );

      // Call the uploadInstallmentPlan function
      await installmentRepository.uploadInstallmentPlanAndPayment(planModel, orderId);
    } catch (e) {
      TLoader.errorSnackBar(
        title: 'Oh Snap! ya hoo',
        message: e.toString(),
      );
      print(e);
    }
  }
}
