import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:intl/intl.dart';
import '../../../Models/expense/expense_model.dart';
import '../../../Models/orders/order_item_model.dart';
import '../../../utils/helpers/helper_functions.dart';

class SalesData {
  final double currentMonthSales;
  final double previousMonthSales;
  final int percentageChange;
  final bool isProfit;
  final String monthYear;

  SalesData({
    required this.currentMonthSales,
    required this.previousMonthSales,
    required this.percentageChange,
    required this.isProfit,
    required this.monthYear,
  });
}

class SalesService {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat monthYearFormat = DateFormat('MMM yy');

  // Helper method to filter out cancelled orders
  List<OrderModel> _filterCancelledOrders(List<OrderModel> allOrders) {
    return allOrders
        .where((order) => order.status != OrderStatus.cancelled.name)
        .toList();
  }

  SalesData calculateSalesTotal(List<OrderModel> allOrders) {
    List<OrderModel> filteredOrders = _filterCancelledOrders(allOrders);
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);

    // Get the number of days passed in the current month
    int daysInCurrentMonth = now.day;

    // Find the last day of the previous month
    DateTime lastDayOfPreviousMonth =
        firstDayOfCurrentMonth.subtract(const Duration(days: 1));
    // Calculate the number of days in the previous month
    int daysInPreviousMonth = lastDayOfPreviousMonth.day;

    // Calculate sales for the current month up to the current date
    double currentMonthSales = filteredOrders.where((order) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      return orderDate
              .isAfter(firstDayOfCurrentMonth.subtract(Duration(days: 1))) &&
          orderDate.isBefore(now.add(Duration(days: 1)));
    }).fold(0.0, (sum, order) => sum + order.totalPrice);

    // Calculate sales for the same number of days from the previous month
    double previousMonthSales = filteredOrders.where((order) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      return orderDate
              .isAfter(firstDayOfPreviousMonth.subtract(Duration(days: 1))) &&
          orderDate.isBefore(
              firstDayOfPreviousMonth.add(Duration(days: daysInCurrentMonth)));
    }).fold(0.0, (sum, order) => sum + order.totalPrice);

    int percentageChange = previousMonthSales == 0
        ? (currentMonthSales > 0 ? 100 : 0)
        : (((currentMonthSales - previousMonthSales) / previousMonthSales) *
                100)
            .round();

    bool isProfit = currentMonthSales > previousMonthSales;

    String monthYear = monthYearFormat.format(firstDayOfPreviousMonth);

    return SalesData(
      currentMonthSales: currentMonthSales,
      previousMonthSales: previousMonthSales,
      percentageChange: percentageChange,
      isProfit: isProfit,
      monthYear: monthYear,
    );
  }

  List<double> calculateWeeklySales(List<OrderModel> allOrders) {
    List<OrderModel> filteredOrders = _filterCancelledOrders(allOrders);
    List<double> weeklySales = List<double>.filled(7, 0.0);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    for (var order in filteredOrders) {
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

  SalesData calculateProfit(
      List<OrderModel> allOrders, List<ExpenseModel> expenses) {
    List<OrderModel> filteredOrders = _filterCancelledOrders(allOrders);
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
    DateTime lastDayOfPreviousMonth =
        firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    // ✅ Calculate current month's sales, buying price, and expenses
    double currentMonthSales = 0.0;
    double currentMonthBuyingPrice = 0.0;
    double currentMonthExpenses = 0.0;

    for (var order in filteredOrders) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      if (orderDate.isAfter(firstDayOfCurrentMonth)) {
        currentMonthSales += order.totalPrice;
        currentMonthBuyingPrice += (order.buyingPrice ?? 0.0);
      }
    }

    for (var expense in expenses) {
      if (expense.createdAt != null &&
          expense.createdAt!.isAfter(firstDayOfCurrentMonth)) {
        currentMonthExpenses += expense.amount;
      }
    }

    // ✅ Calculate previous month's sales, buying price, and expenses
    double previousMonthSales = 0.0;
    double previousMonthBuyingPrice = 0.0;
    double previousMonthExpenses = 0.0;

    for (var order in filteredOrders) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      if (orderDate.isAfter(firstDayOfPreviousMonth) &&
          orderDate.isBefore(lastDayOfPreviousMonth)) {
        previousMonthSales += order.totalPrice;
        previousMonthBuyingPrice += (order.buyingPrice ?? 0.0);
      }
    }

    for (var expense in expenses) {
      if (expense.createdAt != null &&
          expense.createdAt!.isAfter(firstDayOfPreviousMonth) &&
          expense.createdAt!.isBefore(lastDayOfPreviousMonth)) {
        previousMonthExpenses += expense.amount;
      }
    }

    // ✅ Calculate net profit
    double currentMonthProfit =
        (currentMonthSales - currentMonthBuyingPrice) - currentMonthExpenses;
    double previousMonthProfit =
        (previousMonthSales - previousMonthBuyingPrice) - previousMonthExpenses;

    // ✅ Calculate percentage change in profit
    int percentageChange = previousMonthProfit == 0
        ? (currentMonthProfit > 0 ? 100 : 0) // Avoid division by zero
        : (((currentMonthProfit - previousMonthProfit) / previousMonthProfit) *
                100)
            .round();

    // ✅ Determine profit or loss
    bool isProfit = currentMonthProfit > 0;

    // ✅ Format month & year
    String monthYear =
        "${now.year}-${now.month.toString().padLeft(2, '0')}"; // Example: "2025-03"

    return SalesData(
      currentMonthSales: currentMonthProfit,
      previousMonthSales: previousMonthSales,
      percentageChange: percentageChange,
      isProfit: isProfit,
      monthYear: monthYear,
    );
  }
}
