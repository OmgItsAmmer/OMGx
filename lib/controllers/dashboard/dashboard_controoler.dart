import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/orders/order_item_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/helpers/helper_functions.dart';
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
    weeklySales.value = calculateWeeklySales(orderController.allOrders);
  }

  List<double> calculateWeeklySales(List<OrderModel> allOrders) {
    List<double> weeklySales = List<double>.filled(7, 0.0);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    for (var order in allOrders) {
      DateTime orderDate = dateFormat.parse(order.orderDate);
      DateTime orderWeekStart = THelperFunctions.getStartOfWeek(orderDate);

      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (orderDate.weekday - 1) % 7;
        index = index < 0 ? index + 7 : index;
        weeklySales[index] += order.totalPrice;
      }
    }
    return weeklySales;
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

      // Current month range: from 1st to today
      DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
      DateTime today = now;

      // Previous month range: from 1st of previous month to same day number
      DateTime startOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
      DateTime sameDayLastMonth = DateTime(now.year, now.month - 1, now.day);

      // Count current month's customers from 1st to today
      int currentPartialCustomers = customerController.allCustomers
          .where((customer) =>
      customer.createdAt != null &&
          customer.createdAt!.isAfter(startOfCurrentMonth.subtract(const Duration(seconds: 1))) &&
          customer.createdAt!.isBefore(today.add(const Duration(days: 1)))) // inclusive of today
          .length;

      // Count previous month's customers for same period
      int previousPartialCustomers = customerController.allCustomers
          .where((customer) =>
      customer.createdAt != null &&
          customer.createdAt!.isAfter(startOfPreviousMonth.subtract(const Duration(seconds: 1))) &&
          customer.createdAt!.isBefore(sameDayLastMonth.add(const Duration(days: 1)))) // inclusive of same day
          .length;

      // Calculate percentage change
      int percentageChange = previousPartialCustomers == 0
          ? (currentPartialCustomers > 0 ? 100 : 0)
          : (((currentPartialCustomers - previousPartialCustomers) / previousPartialCustomers) * 100).round();

      bool isIncrease = currentPartialCustomers > previousPartialCustomers;

      // Update controller variables
      customerCount.value = currentPartialCustomers;
      card4Percentage.value = percentageChange;
      isCustomerIncrease.value = isIncrease;
    } catch (e) {
      TLoader.errorSnackBar(title: "Error", message: e.toString());
    }
  }


}
