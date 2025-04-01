import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../expenses/expense_controller.dart';
import '../orders/orders_controller.dart';
import 'services/sales_service.dart';



class DashboardController extends GetxController {
  final OrderController orderController = Get.find<OrderController>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final SalesService salesService = SalesService();


  var dataList = <Map<String, String>>[].obs;

  // Observables for dashboard cards
  RxDouble currentMonthSales = 0.0.obs;
  RxBool isCard1Profit = false.obs;
  RxInt card1Percentage = 0.obs;
  RxString lastMonth = 'MM//YY'.obs;


  // Observable for the PROFIT
  // Observables for dashboard cards
  RxDouble currentMonthProfit = 0.0.obs;
  RxBool isCard2Profit = false.obs;
  RxInt card2Percentage = 0.obs;



  RxInt customerCount = 0.obs;
  RxBool isCustomerIncrease = false.obs;
  RxInt card4Percentage = 0.obs;

  final RxList<double> weeklySales = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
    _calculateWeeklySales();
    fetchCards();
  }

  void fetchCards() {
    try {
      fetchSalesTotalCard();
      fetchProfit();
      fetchCustomerCard();
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void _calculateWeeklySales() {
    weeklySales.value = salesService.calculateWeeklySales(orderController.allOrders);
  }

  void fetchSalesTotalCard() {
    try {
      var result = salesService.calculateSalesTotal(orderController.allOrders);

      currentMonthSales.value = result.currentMonthSales;
      card1Percentage.value = result.percentageChange;
      isCard1Profit.value = result.isProfit;
      lastMonth.value = result.monthYear;

      if (kDebugMode) {
        print("Previous Month Total: ${result.previousMonthSales}");
        print("Is Profit: ${isCard1Profit.value}");
        print("Current Month Total: ${currentMonthSales.value}");
      }
    } catch (e) {
      TLoader.errorSnackBar(title: "Error", message: e.toString());
    }
  }


  void fetchProfit() {
    try {
      var result = salesService.calculateProfit(orderController.allOrders,expenseController.expenses);

      currentMonthProfit.value = result.currentMonthSales;
      card2Percentage.value = result.percentageChange;
      isCard2Profit.value = result.isProfit;
     // lastMonth.value = result.monthYear;

      if (kDebugMode) {
        print("Previous Month Total: ${result.previousMonthSales}");
        print("Is Profit: ${isCard1Profit.value}");
        print("Current Month Total: ${currentMonthSales.value}");
      }
    } catch (e) {
      TLoader.errorSnackBar(title: "Error", message: e.toString());
    }
  }



  void fetchCustomerCard() {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
      DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
      DateTime lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));

      // ✅ Count new customers for the current month
      int currentMonthCustomers = customerController.allCustomers
          .where((customer) =>
      customer.createdAt != null &&
          customer.createdAt!.isAfter(firstDayOfCurrentMonth))
          .length;

      // ✅ Count new customers for the previous month
      int previousMonthCustomers = customerController.allCustomers
          .where((customer) =>
      customer.createdAt != null &&
          customer.createdAt!.isAfter(firstDayOfPreviousMonth) &&
          customer.createdAt!.isBefore(lastDayOfPreviousMonth))
          .length;

      // ✅ Calculate percentage increase or decrease
      int percentageChange = previousMonthCustomers == 0
          ? (currentMonthCustomers > 0 ? 100 : 0)
          : (((currentMonthCustomers - previousMonthCustomers) / previousMonthCustomers) * 100).round();

      // ✅ Determine if there's an increase
      bool isIncrease = currentMonthCustomers > previousMonthCustomers;

      // ✅ Store values in controller variables
      customerCount.value = currentMonthCustomers;
     // previousMonthCustomers.value = previousMonthCustomers;
      card4Percentage.value = percentageChange;
      isCustomerIncrease.value = isIncrease;
    } catch (e) {
      TLoader.errorSnackBar(title: "Error", message: e.toString());
    }
  }

}
