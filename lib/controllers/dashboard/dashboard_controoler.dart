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
import '../../repositories/installment/installment_repository.dart';
import '../../Models/installments/installemt_plan_model.dart';

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
  final InstallmentRepository installmentRepository =
      Get.put(InstallmentRepository());

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

    // Set up reactive listeners after initial load
    _setupReactiveListeners();
  }

  void _setupReactiveListeners() {
    // Listen to changes in orders array
    ever(orderController.allOrders, (List<OrderModel> orders) {
      if (orderDataInitialized.value) {
        if (kDebugMode) {
          print(
              'Orders array changed, recalculating metrics. Orders count: ${orders.length}');
        }
        _recalculateOrderMetrics();
      }
    });

    // Listen to changes in customers array
    ever(customerController.allCustomers, (List<CustomerModel> customers) {
      if (customerDataInitialized.value) {
        if (kDebugMode) {
          print(
              'Customers array changed, recalculating metrics. Customers count: ${customers.length}');
        }
        _recalculateCustomerMetrics();
      }
    });

    // Listen to changes in expenses array
    ever(expenseController.expenses, (List<ExpenseModel> expenses) {
      if (expenseDataInitialized.value) {
        if (kDebugMode) {
          print(
              'Expenses array changed, recalculating metrics. Expenses count: ${expenses.length}');
        }
        _recalculateProfitMetrics();
      }
    });
  }

  Future<void> _recalculateOrderMetrics() async {
    try {
      // Recalculate sales card
      await _calculateSalesCard();

      // Recalculate average order card
      await _calculateAvgOrderCard();

      // Recalculate chart data
      await _calculateChartData();

      // Recalculate pie chart data
      await _calculatePieChartData();

      if (kDebugMode) {
        print('Dashboard metrics updated due to order changes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recalculating order metrics: $e');
      }
    }
  }

  Future<void> _recalculateCustomerMetrics() async {
    try {
      // Recalculate customer card
      await _calculateCustomerCard();

      if (kDebugMode) {
        print('Customer metrics updated due to customer changes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recalculating customer metrics: $e');
      }
    }
  }

  Future<void> _recalculateProfitMetrics() async {
    try {
      // Recalculate profit card (depends on both orders and expenses)
      await _calculateProfitCard();

      if (kDebugMode) {
        print('Profit metrics updated due to expense changes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recalculating profit metrics: $e');
      }
    }
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

  /// Force refresh all dashboard data and metrics
  Future<void> forceRefreshDashboard() async {
    try {
      if (kDebugMode) {
        print('Force refreshing dashboard data...');
      }

      // Reset initialization flags to force data reload
      orderDataInitialized.value = false;
      expenseDataInitialized.value = false;
      customerDataInitialized.value = false;

      // Reload all data and recalculate metrics
      await loadDashboardData();

      if (kDebugMode) {
        print('Dashboard force refresh completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during force refresh: $e');
      }
    }
  }

  /// Recalculate all metrics without reloading data
  Future<void> recalculateAllMetrics() async {
    try {
      if (kDebugMode) {
        print('Recalculating all dashboard metrics...');
      }

      await _calculateAllMetrics();

      if (kDebugMode) {
        print('All metrics recalculated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error recalculating metrics: $e');
      }
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
      if (kDebugMode) {
        print('Calculating customer metrics...');
        print('Total customers: ${customerController.allCustomers.length}');
      }
      fetchCustomerCard(customerController.allCustomers);
      customerCardState.value = DataFetchState.success;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating customer metrics: $e');
      }
      customerCardState.value = DataFetchState.error;
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
    TLoaders.errorSnackBar(title: 'Dashboard Error', message: error.toString());
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
          : currentMonthOrders.map((e) => e.subTotal).reduce((a, b) => a + b) /
              currentMonthOrders.length;

      // Calculate average for previous month
      final lastAvg = lastMonthOrders.isEmpty
          ? 0.0
          : lastMonthOrders.map((e) => e.subTotal).reduce((a, b) => a + b) /
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

  // Helper method to calculate the correct total amount for an order
  // considering installment charges if applicable
  Future<double> _calculateOrderTotalAmount(OrderModel order) async {
    try {
      // Calculate base amounts
      double salesmanCommissionAmount =
          (order.subTotal * order.salesmanComission) / 100;
      double baseTotal = order.subTotal +
          order.tax +
          order.shippingFee +
          salesmanCommissionAmount;

      // Check if this is an installment order
      if (order.saletype != null &&
          order.saletype!.toLowerCase() == 'installment') {
        // Fetch installment plan for this order
        final planId = await installmentRepository.fetchPlanId(order.orderId);
        if (planId != null) {
          final installmentPlan =
              await installmentRepository.fetchInstallmentPlan(planId);
          if (installmentPlan != null) {
            // Add installment-specific charges
            double documentCharges =
                double.tryParse(installmentPlan.documentCharges ?? '0.0') ??
                    0.0;
            double otherCharges =
                double.tryParse(installmentPlan.otherCharges ?? '0.0') ?? 0.0;

            // Calculate margin amount
            double marginPercentage =
                double.tryParse(installmentPlan.margin ?? '0.0') ?? 0.0;
            double downPayment =
                double.tryParse(installmentPlan.downPayment ?? '0.0') ?? 0.0;
            double marginAmount = 0.0;

            if (marginPercentage > 0) {
              double baseAmountForMargin = order.subTotal - order.discount;
              double financedBase = baseAmountForMargin - downPayment;
              if (financedBase < 0) financedBase = 0; // Ensure not negative
              marginAmount = financedBase * (marginPercentage / 100.0);
            }

            // Return total including installment charges
            return baseTotal + documentCharges + otherCharges + marginAmount;
          }
        }
      }

      // Return base total for non-installment orders or if installment data is unavailable
      return baseTotal;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating order total amount: $e');
      }
      // Fallback to base calculation
      double salesmanCommissionAmount =
          (order.subTotal * order.salesmanComission) / 100;
      return order.subTotal +
          order.tax +
          order.shippingFee +
          salesmanCommissionAmount;
    }
  }

  void calculateOrderStatusCounts(List<OrderModel> allOrders) async {
    try {
      pendingOrders.value = 0;
      completedOrders.value = 0;
      cancelledOrders.value = 0;
      pendingAmount.value = 0;
      completedAmount.value = 0;
      cancelledAmount.value = 0;

      for (var order in allOrders) {
        // Calculate total amount for the order (already includes commission)
        double totalAmount = await _calculateOrderTotalAmount(order);

        // Calculate pending amount as totalAmount - paidAmount
        double paidAmount = order.paidAmount ?? 0.0;
        double pendingOrderAmount = totalAmount - paidAmount;

        switch (order.status.toLowerCase()) {
          case 'pending':
            pendingOrders.value++;
            pendingAmount.value += pendingOrderAmount;
            break;
          case 'completed':
            completedOrders.value++;
            completedAmount.value += totalAmount;
            break;
          case 'cancelled':
            cancelledOrders.value++;
            cancelledAmount.value += totalAmount;
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
        weeklySales[index] += order.subTotal;
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

  /// Test method to verify reactive updates work
  void testReactiveUpdates() {
    if (kDebugMode) {
      print('=== Dashboard Reactive Test ===');
      print('Orders count: ${orderController.allOrders.length}');
      print('Customers count: ${customerController.allCustomers.length}');
      print('Expenses count: ${expenseController.expenses.length}');
      print('Current month sales: ${currentMonthSales.value}');
      print('Customer count: ${customerCount.value}');
      print('Current month profit: ${currentMonthProfit.value}');
      print('==============================');
    }
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
