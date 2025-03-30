import 'package:intl/intl.dart';
import '../../../Models/orders/order_item_model.dart';
import '../../../utils/helpers/helper_functions.dart';


class SalesData {
  final double currentMonthSales;
  final double previousMonthSales;
  final int percentageChange;
  final bool isProfit;
  final String monthYear;

  SalesData( {
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

  SalesData calculateSalesTotal(List<OrderModel> allOrders) {
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
    DateTime lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    double currentMonthSales = allOrders
        .where((order) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      return orderDate.isAfter(firstDayOfCurrentMonth);
    })
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    double previousMonthSales = allOrders
        .where((order) {
      DateTime orderDate = DateTime.parse(order.orderDate);
      return orderDate.isAfter(firstDayOfPreviousMonth) && orderDate.isBefore(lastDayOfPreviousMonth);
    })
        .fold(0.0, (sum, order) => sum + order.totalPrice);

    int percentageChange = previousMonthSales == 0
        ? (currentMonthSales > 0 ? 100 : 0)
        : (((currentMonthSales - previousMonthSales) / previousMonthSales) * 100).round();

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
}
