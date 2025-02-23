import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../orders/orders_controller.dart';

class DashboardController extends GetxController {
  final OrderController  orderController =
  Get.find<OrderController>();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');



  var DataList = <Map<String, String>>[].obs;
  final RxList<double> weeklySales = <double>[].obs;

  static final List<OrderModel> orders = [];



  @override
  void onInit() {
    _calculateWeeklySales();
    super.onInit();

  }

  void _calculateWeeklySales() {
    try {
      // Reset weekly sales to zero
      weeklySales.value = List<double>.filled(7, 0.0);
      print(orderController.allOrders);

      for (var order in orderController.allOrders) {
        // Check if order.orderDate is not null
        if (order.orderDate != null) {
          final DateTime orderDate = dateFormat.parse(order.orderDate!);
          final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(orderDate);

          // Debugging: Print dates
          print('Order Date: $orderDate');
          print('Order Week Start: $orderWeekStart');
          print('Current Date: ${DateTime.now()}');

          if (orderWeekStart.isBefore(DateTime.now()) &&
              orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {

            int index = (orderDate.weekday - 1) % 7;
            // Ensure the index is not negative
            index = index < 0 ? index + 7 : index;

            weeklySales[index] += order.totalPrice;

            // Print it (optional)
            print('Weekly Sales: $weeklySales');
          }
        } else {
          if (kDebugMode) {
            print('Order date is null for order: ${order.orderId}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }




}