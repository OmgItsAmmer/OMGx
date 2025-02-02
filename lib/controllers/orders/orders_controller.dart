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







  @override
  void onInit() {
    fetchOrders();
    super.onInit();
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
