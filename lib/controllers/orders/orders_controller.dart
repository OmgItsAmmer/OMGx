import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/order/order_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final OrderRepository orderRepository = Get.put(OrderRepository());

  RxList<OrderModel> allOrders = <OrderModel>[].obs;


  final Rx<OrderStatus> selectedStatus = OrderStatus.pending.obs;

  RxList<OrderItemModel> orderItems = <OrderItemModel>[].obs;

  final isStatusLoading = false.obs;
  final isOrderLoading = false.obs;

//Customer Order Detail
  RxList<OrderModel> currentOrders = <OrderModel>[].obs;
  String recentOrderDay = '';
  String  averageTotalAmount= '';




  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  // Function to set the most recent order day with orderId
  void setRecentOrderDay() {
    if (currentOrders.isEmpty) {
      recentOrderDay = "No orders available";
      recentOrderDay = "0"; // Reset difference if no orders
      return;
    }

    // Find the most recent order
    OrderModel recentOrder = currentOrders.reduce((curr, next) =>
    DateTime.parse(curr.orderDate).isAfter(DateTime.parse(next.orderDate))
        ? curr
        : next);

    // Format the date and set the class variable
    recentOrderDay = "${recentOrder.orderDate} (${recentOrder.orderId})";

    // Calculate the difference in days between the current day and the orderDate
    DateTime currentDate = DateTime.now(); // Get the current date
    DateTime orderDate = DateTime.parse(recentOrder.orderDate); // Parse the orderDate

    // Calculate the difference in days
    recentOrderDay = '${currentDate.difference(orderDate).inDays} Days Ago (#${recentOrder.orderId})' ;
  }

  // Function to set the average of totalPrice
  void setAverageTotalAmount() {
    if (currentOrders.isEmpty) {
      averageTotalAmount = "0.0"; // Set to 0 if there are no orders
      return;
    }

    // Calculate the sum of all total prices
    double totalSum = currentOrders.fold(0.0, (sum, order) => sum + order.totalPrice);

    // Calculate the average and set the class variable
    double average = totalSum / currentOrders.length;
    averageTotalAmount = average.toStringAsFixed(2); // Format to 2 decimal places
  }




  void resetCustomerOrders() {
    try{
      currentOrders.assignAll(allOrders);

    }
    catch(e)
    {
      TLoader.errorSnackBar(title: e.toString()); //TODO remove it
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchCustomerOrders(int customerId) async {

    try {
      if (kDebugMode) {
        print(customerId);
      }
      isOrderLoading.value = true;

      currentOrders.clear();

      final orders = await orderRepository.fetchCustomerOrders(customerId);
      currentOrders.assignAll(orders);




    } catch (e) {
      TLoader.errorSnackBar(title: e.toString()); //TODO remove it
      if (kDebugMode) {
        print(e);
      }

    }
    finally
    {
      isOrderLoading.value = false;

    }

  }




  Future<String> updateStatus(int orderId , String status) async {
    try{
      isStatusLoading.value = true;
      await orderRepository.updateStatus(orderId,status);

      return status;

    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }

      return '';
    }
    finally{
      isStatusLoading.value = false;

    }
  }
  OrderStatus? stringToOrderStatus(String status) {
    try {
      return OrderStatus.values.firstWhere((e) => e.toString() == status);
    } catch (e) {
      return null; // Return null if the status string doesn't match any enum value
    }
  }

  Future<void> fetchOrders() async {
    try {

      final orders = await orderRepository.fetchOrders();
      allOrders.assignAll(orders);
      currentOrders.assignAll(orders);



    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
    }
  }


  Future<void> fetchOrderItems(int orderId) async {
    try {
      print(orderId);
      final orderItems1 = await orderRepository.fetchOrderItems(orderId);
      orderItems.assignAll(orderItems1);

    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
    }
  }
}
