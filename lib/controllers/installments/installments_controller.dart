import 'dart:ffi';

import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/installment/installment_repository.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Models/installments/installemt_plan_model.dart';
import '../../Models/installments/installment_table_model/installment_table_model.dart';
import '../sales/sales_controller.dart';

class InstallmentController extends GetxController {
  static InstallmentController get instance => Get.find();
  final InstallmentRepository installmentRepository = Get.put(InstallmentRepository());
  final SalesController salesController = Get.find<SalesController>();



//  RxList<SaleModel> allSales = <SaleModel>[].obs;


  // Loading state
  final isLoading = false.obs;


  //Salesman Info
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


  //Installment table
  RxList<InstallmentTableModel> installmentPlans = <InstallmentTableModel>[].obs;
  //final List<InstallmentTableModel> installmentPayments;

  //final RxList<>







  void addProduct() {
    try {

    }
    catch (e) {
      TLoader.errorsnackBar(title: 'Adding Data', message: e.toString());
    }
  }


  void updateINCLExMargin() {
    try {
      // Convert strings to double and then perform the addition
      double billAmountDouble = double.tryParse(billAmount.value.text) ?? 0.0;
      double downPaymentDouble = double.tryParse(DownPayment.text) ?? 0.0;
      double documentChargesDouble = double.tryParse(DocumentCharges.text) ?? 0.0;
      double otherChargesDouble = double.tryParse(otherCharges.text) ?? 0.0;
      double marginDouble = double.tryParse(margin.text) ?? 0.0;

    // Convert margin percentage to decimal
      double marginAsDecimal = marginDouble / 100;

    // Perform the addition
      double _payableExMargin = billAmountDouble + downPaymentDouble + documentChargesDouble + otherChargesDouble;
      double _payableINCLMargin = _payableExMargin + (_payableExMargin * marginAsDecimal);

    // Convert the result back to string if you want to display it in the text fields
      payableExMargin.value.text = _payableExMargin.toString();
      payableINCLMargin.value.text = _payableINCLMargin.toString();

    }
    catch(e){
      TLoader.errorsnackBar(title: 'Oh Snap!',message: e.toString());
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
        TLoader.errorsnackBar(
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
          installmentDurationInDays = 30;  // Approximate number of days in a month
          break;
        case DurationType.Quarterly:
          installmentDurationInDays = 90;  // Approximate number of days in a quarter
          break;
        case DurationType.Yearly:
          installmentDurationInDays = 365; // Approximate number of days in a year
          break;
        default:
          installmentDurationInDays = 30; // Default to monthly if Duration is selected
      }

      // Add advance payment info at index 0
      installmentPlans.insert(
        0,
        InstallmentTableModel(
          sequenceNo: 0,
          description: "Advance Payment",
          dueDate: currentDate.toIso8601String(), // Current date for advance payment
          paidDate: currentDate.toIso8601String(), // Paid on current date
          paid_amount: downPaymentValue.toStringAsFixed(2),
          remarks: note.text,
          remaining: "0", // No remaining amount for advance
          status: "Paid",
          action: "N/A", // No action needed
          amount_due: downPaymentValue.toStringAsFixed(2), // Set the amount as advance
        ),
      );

      // Generate installment plans
      for (int i = 1; i <= numberOfInstallments; i++) {
        DateTime dueDate = currentDate.add(Duration(days: i * installmentDurationInDays)); // Using dynamic duration

        installmentPlans.add(
          InstallmentTableModel(
            sequenceNo: i,
            description: "Installment $i",
            dueDate: dueDate.toIso8601String(), // Only date part
            paidDate: null, // Initially empty
            paid_amount: "0", // Initially unpaid
            remarks: "",  
            remaining: installmentAmount.toStringAsFixed(2),
            status: "Pending",
            action: "Pay Now",
            amount_due: installmentAmount.toStringAsFixed(2), // Added the amount
          ),
        );
      }

      // Log or process the generated plans as needed
      print(installmentPlans.map((plan) => plan.toJson()).toList());
    } catch (e) {
      TLoader.errorsnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }


  Future<void> savePlan() async {
    try{

      // Log or process the generated plans as needed
      print(installmentPlans.map((plan) => plan.toJson()).toList());
      int orderId = await salesController.checkOut();

      // Now, call the uploadInstallmentPlan function to upload the generated plan
      final InstallmentPlanModel planModel = InstallmentPlanModel(
        // Example values; you need to populate this properly
        installmentPlanId: -1, // not count
        orderId: orderId,
        totalAmount: billAmount.value.text,
        documentCharges: DocumentCharges.text,
        margin: margin.text ,
        otherCharges: otherCharges.text,
        note: note.text,
        duration: durationController.value.toString().split('.').last,
        downPayment: DownPayment.text,
        numberOfInstallments: NoOfInstallments.text,
        firstInstallmentDate: selectedDate,
        frequencyInMonth: durationController == DurationType.Monthly ? "1" : durationController == DurationType.Quarterly ? "3" : "12",
        installemtPaymentList: installmentPlans,  // Converts RxList to a standard List
      // Pass the generated installment plans
      );



      // Call the uploadInstallmentPlan function
      await installmentRepository.uploadInstallmentPlan(planModel,orderId);

    }
    catch(e){
      TLoader.errorsnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }

  }






}







