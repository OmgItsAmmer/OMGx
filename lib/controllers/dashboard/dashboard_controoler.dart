import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../orders/orders_controller.dart';
import 'services/sales_service.dart';



class DashboardController extends GetxController {
  final OrderController orderController = Get.find<OrderController>();
  final SalesService salesService = SalesService();


  var dataList = <Map<String, String>>[].obs;

  // Observables for dashboard cards
  RxDouble currentMonthSales = 0.0.obs;
  RxBool isCard1Profit = false.obs;
  RxInt card1Percentage = 0.obs;
  RxString lastMonth = 'MM//YY'.obs;



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
}
