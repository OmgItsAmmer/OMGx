import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/order/order_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final OrderRepository orderRepository = Get.put(OrderRepository());

  RxList<OrderModel> allOrders = <OrderModel>[].obs;

  final Rx<OrderStatus> selectedStatus = OrderStatus.pending.obs;

  RxList<OrderItemModel> orderItems = <OrderItemModel>[].obs;






  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {

      final orders = await orderRepository.fetchOrders();
      allOrders.assignAll(orders);



    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
    }
  }


  Future<void> fetchOrderItems(int orderId) async {
    try {
      print(orderId);
      final orderItems1 = await orderRepository.fetchOrderItems(orderId);
      orderItems.assignAll(orderItems1);

    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
    }
  }
}
