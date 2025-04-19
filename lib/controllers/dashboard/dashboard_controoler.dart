import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/Models/expense/expense_model.dart';
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

class DashboardController extends GetxController with StateMixin<dynamic> {
  static DashboardController get instance => Get.find();

  final OrderController orderController = Get.find<OrderController>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final SalesService salesService = SalesService();
  RxBool isLoading = true.obs;

  var dataList = <Map<String, String>>[].obs;

  // Observables for dashboard cards
  RxDouble currentMonthSales = 0.0.obs;
  RxBool isCard1Profit = false.obs;
  RxInt card1Percentage = 0.obs;
  RxString lastMonth = 'MM//YY'.obs;

  // Average Order Value
  RxDouble averageOrderValue = 0.0.obs;
  RxInt averageOrderPercentage = 0.obs;
  RxBool isAverageOrderIncrease = false.obs;

  // Order Status Counts
  RxInt pendingOrders = 0.obs;
  RxInt completedOrders = 0.obs;
  RxInt cancelledOrders = 0.obs;
  RxDouble pendingAmount = 0.0.obs;
  RxDouble completedAmount = 0.0.obs;
  RxDouble cancelledAmount = 0.0.obs;

  // Observable for the PROFIT
  // Observables for dashboard cards
  RxDouble currentMonthProfit = 0.0.obs;
  RxBool isCard2Profit = false.obs;
  RxInt card2Percentage = 0.obs;

  RxInt customerCount = 0.obs;
  RxBool isCustomerIncrease = false.obs;
  RxInt card4Percentage = 0.obs;

  final RxList<double> weeklySales = RxList<double>.filled(7, 0.0);

  @override
  void onInit() {
    super.onInit();
    initializeDashboard();
  }

  @override
  void onReady() {
    super.onReady();
    // Re-fetch data when the widget is ready
    Future.delayed(const Duration(milliseconds: 100), () {
      initializeDashboard();
    });
  }

  Future<void> initializeDashboard() async {
    try {
      isLoading.value = true;
      change(null, status: RxStatus.loading());

      // Reset values to show loading state
      currentMonthSales.value = 0;
      currentMonthProfit.value = 0;
      customerCount.value = 0;
      // Reset weekly sales to zeros
      for (int i = 0; i < weeklySales.length; i++) {
        weeklySales[i] = 0.0;
      }

      // Fetch data if not already fetched
      if (orderController.allOrders.isEmpty) {
        await orderController.fetchOrders();
      }
      if (expenseController.expenses.isEmpty) {
        await expenseController.fetchExpenses();
      }
      if (customerController.allCustomers.isEmpty) {
        await customerController.fetchAllCustomers();
      }

      // Calculate and update values
      calculateWeeklySales1(orderController.allOrders);
      fetchCards(orderController.allOrders, expenseController.expenses);

      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      TLoader.errorSnackBar(title: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCards(List<OrderModel> allOrders, List<ExpenseModel> expenses) {
    try {
      fetchSalesTotalCard(allOrders);
      fetchProfit(allOrders, expenses);
      fetchCustomerCard(customerController.allCustomers);
      calculateAverageOrderValue(allOrders);
      calculateOrderStatusCounts(allOrders);
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void calculateAverageOrderValue(List<OrderModel> allOrders) {
    try {
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month);
      final lastMonth = DateTime(now.year, now.month - 1);

      // Filter orders for current month
      final currentMonthOrders = allOrders.where((order) =>
          DateTime.parse(order.orderDate)
              .isAfter(currentMonth.subtract(const Duration(seconds: 1))));

      // Filter orders for previous month
      final lastMonthOrders = allOrders.where((order) =>
          DateTime.parse(order.orderDate)
              .isAfter(lastMonth.subtract(const Duration(seconds: 1))) &&
          DateTime.parse(order.orderDate).isBefore(currentMonth));

      // Calculate average for current month
      final currentAvg = currentMonthOrders.isEmpty
          ? 0.0
          : currentMonthOrders
                  .map((e) => e.totalPrice)
                  .reduce((a, b) => a + b) /
              currentMonthOrders.length;

      // Calculate average for previous month
      final lastAvg = lastMonthOrders.isEmpty
          ? 0.0
          : lastMonthOrders.map((e) => e.totalPrice).reduce((a, b) => a + b) /
              lastMonthOrders.length;

      // Set the average order value
      averageOrderValue.value = currentAvg;

      // Calculate percentage change
      if (lastAvg == 0) {
        // If last month had zero average, and current month has value, it's 100% increase
        averageOrderPercentage.value = currentAvg > 0 ? 100 : 0;
        isAverageOrderIncrease.value = currentAvg > 0;
      } else {
        // Calculate percentage change between two months
        final percentageChange =
            ((currentAvg - lastAvg) / lastAvg * 100).round();
        averageOrderPercentage.value =
            percentageChange.abs(); // Store absolute value
        isAverageOrderIncrease.value = currentAvg >= lastAvg; // Store direction
      }

      if (kDebugMode) {
        print(
            "Average Order Value - Current Month: ${averageOrderValue.value.toStringAsFixed(2)}");
        print(
            "Average Order Value - Previous Month: ${lastAvg.toStringAsFixed(2)}");
        print(
            "Average Order Value - Percentage Change: ${averageOrderPercentage.value}%");
        print(
            "Average Order Value - Is Increase: ${isAverageOrderIncrease.value}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating average order value: $e');
      }
      TLoader.errorSnackBar(title: 'Error calculating average order value');
    }
  }

  void calculateOrderStatusCounts(List<OrderModel> allOrders) {
    try {
      pendingOrders.value = 0;
      completedOrders.value = 0;
      cancelledOrders.value = 0;
      pendingAmount.value = 0;
      completedAmount.value = 0;
      cancelledAmount.value = 0;

      for (var order in allOrders) {
        switch (order.status.toLowerCase()) {
          case 'pending':
            pendingOrders.value++;
            pendingAmount.value += order.totalPrice;
            break;
          case 'completed':
            completedOrders.value++;
            completedAmount.value += order.totalPrice;
            break;
          case 'cancelled':
            cancelledOrders.value++;
            cancelledAmount.value += order.totalPrice;
            break;
        }
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Error calculating order status counts');
    }
  }

  void calculateWeeklySales1(List<OrderModel> allOrders) {
    final newSales = calculateWeeklySales(allOrders);
    for (int i = 0; i < weeklySales.length; i++) {
      weeklySales[i] = newSales[i];
    }
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

  void fetchSalesTotalCard(List<OrderModel> allOrders) {
    try {
      var result = salesService.calculateSalesTotal(allOrders);

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

  //
  void fetchProfit(List<OrderModel> allOrders, List<ExpenseModel> expenses) {
    try {
      var result = salesService.calculateProfit(allOrders, expenses);

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

  void fetchCustomerCard(List<CustomerModel> allCustomers) {
    try {
      DateTime now = DateTime.now();

      // Current month range: from 1st to today
      DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
      DateTime today = now;

      // Previous month range: from 1st of previous month to same day number
      DateTime startOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
      DateTime sameDayLastMonth = DateTime(now.year, now.month - 1, now.day);

      // Count current month's customers from 1st to today
      int currentPartialCustomers = allCustomers
          .where((customer) =>
              customer.createdAt != null &&
              customer.createdAt!.isAfter(
                  startOfCurrentMonth.subtract(const Duration(seconds: 1))) &&
              customer.createdAt!.isBefore(
                  today.add(const Duration(days: 1)))) // inclusive of today
          .length;

      // Count previous month's customers for same period
      int previousPartialCustomers = allCustomers
          .where((customer) =>
              customer.createdAt != null &&
              customer.createdAt!.isAfter(
                  startOfPreviousMonth.subtract(const Duration(seconds: 1))) &&
              customer.createdAt!.isBefore(sameDayLastMonth
                  .add(const Duration(days: 1)))) // inclusive of same day
          .length;

      // Calculate percentage change
      int percentageChange = previousPartialCustomers == 0
          ? (currentPartialCustomers > 0 ? 100 : 0)
          : (((currentPartialCustomers - previousPartialCustomers) /
                      previousPartialCustomers) *
                  100)
              .round();

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
