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

// Define possible data fetch states
enum DataFetchState { initial, loading, success, error }

class DashboardController extends GetxController with StateMixin<dynamic> {
  static DashboardController get instance => Get.find();

  // State management variables for each card
  final Rx<DataFetchState> salesCardState =
      Rx<DataFetchState>(DataFetchState.initial);
  final Rx<DataFetchState> avgOrderState =
      Rx<DataFetchState>(DataFetchState.initial);
  final Rx<DataFetchState> profitCardState =
      Rx<DataFetchState>(DataFetchState.initial);
  final Rx<DataFetchState> customerCardState =
      Rx<DataFetchState>(DataFetchState.initial);
  final Rx<DataFetchState> chartState =
      Rx<DataFetchState>(DataFetchState.initial);
  final Rx<DataFetchState> pieChartState =
      Rx<DataFetchState>(DataFetchState.initial);

  // Track if initialization is complete for each section
  final RxBool orderDataInitialized = false.obs;
  final RxBool expenseDataInitialized = false.obs;
  final RxBool customerDataInitialized = false.obs;

  // Legacy loading state (keep for backward compatibility)
  RxBool isLoading = false.obs;

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

    // Initialize default values
    currentMonthSales.value = 0.0;
    averageOrderValue.value = 0.0;
    currentMonthProfit.value = 0.0;
    customerCount.value = 0;
    card1Percentage.value = 0;
    card2Percentage.value = 0;
    card4Percentage.value = 0;
    averageOrderPercentage.value = 0;

    // Start loading data
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load all necessary data first
      await _loadAllData();

      // Then calculate metrics for each card separately
      await _calculateAllMetrics();
    } catch (e) {
      _handleGlobalError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAllData() async {
    // Load order data if needed
    if (!orderDataInitialized.value || orderController.allOrders.isEmpty) {
      await loadOrderData();
    }

    // Load expense data if needed
    if (!expenseDataInitialized.value || expenseController.expenses.isEmpty) {
      await loadExpenseData();
    }

    // Load customer data if needed
    if (!customerDataInitialized.value ||
        customerController.allCustomers.isEmpty) {
      await loadCustomerData();
    }
  }

  Future<void> _calculateAllMetrics() async {
    // Calculate each metric independently with proper state management
    await _calculateSalesCard();
    await _calculateAvgOrderCard();
    await _calculateProfitCard();
    await _calculateCustomerCard();
    await _calculateChartData();
    await _calculatePieChartData();
  }

  Future<void> _calculateSalesCard() async {
    salesCardState.value = DataFetchState.loading;
    try {
      var result = salesService.calculateSalesTotal(orderController.allOrders);
      currentMonthSales.value = result.currentMonthSales;
      card1Percentage.value = result.percentageChange;
      isCard1Profit.value = result.isProfit;
      lastMonth.value = result.monthYear;
      salesCardState.value = DataFetchState.success;
    } catch (e) {
      salesCardState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating sales total: $e');
      }
    }
  }

  Future<void> _calculateAvgOrderCard() async {
    avgOrderState.value = DataFetchState.loading;
    try {
      calculateAverageOrderValue(orderController.allOrders);
      avgOrderState.value = DataFetchState.success;
    } catch (e) {
      avgOrderState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating average order value: $e');
      }
    }
  }

  Future<void> _calculateProfitCard() async {
    profitCardState.value = DataFetchState.loading;
    try {
      var result = salesService.calculateProfit(
          orderController.allOrders, expenseController.expenses);
      currentMonthProfit.value = result.currentMonthSales;
      card2Percentage.value = result.percentageChange;
      isCard2Profit.value = result.isProfit;
      profitCardState.value = DataFetchState.success;
    } catch (e) {
      profitCardState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating profit: $e');
      }
    }
  }

  Future<void> _calculateCustomerCard() async {
    customerCardState.value = DataFetchState.loading;
    try {
      fetchCustomerCard(customerController.allCustomers);
      customerCardState.value = DataFetchState.success;
    } catch (e) {
      customerCardState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating customer metrics: $e');
      }
    }
  }

  Future<void> _calculateChartData() async {
    chartState.value = DataFetchState.loading;
    try {
      calculateWeeklySales1(orderController.allOrders);
      chartState.value = DataFetchState.success;
    } catch (e) {
      chartState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating weekly sales: $e');
      }
    }
  }

  Future<void> _calculatePieChartData() async {
    pieChartState.value = DataFetchState.loading;
    try {
      calculateOrderStatusCounts(orderController.allOrders);
      pieChartState.value = DataFetchState.success;
    } catch (e) {
      pieChartState.value = DataFetchState.error;
      if (kDebugMode) {
        print('Error calculating order status counts: $e');
      }
    }
  }

  Future<void> loadOrderData() async {
    try {
      if (orderController.allOrders.isEmpty) {
        await orderController.fetchOrders();
      }
      orderDataInitialized.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading order data: $e');
      }
    }
  }

  Future<void> loadExpenseData() async {
    try {
      if (expenseController.expenses.isEmpty) {
        await expenseController.fetchExpenses();
      }
      expenseDataInitialized.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading expense data: $e');
      }
    }
  }

  Future<void> loadCustomerData() async {
    try {
      if (customerController.allCustomers.isEmpty) {
        await customerController.fetchAllCustomers();
      }
      customerDataInitialized.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading customer data: $e');
      }
    }
  }

  // Simplified error handling
  void _handleGlobalError(dynamic error) {
    if (kDebugMode) {
      print('Dashboard error: $error');
    }
    TLoader.errorSnackBar(title: 'Dashboard Error', message: error.toString());
    change(null, status: RxStatus.error(error.toString()));
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
            percentageChange; // Store the actual value (can be negative)
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }
}
