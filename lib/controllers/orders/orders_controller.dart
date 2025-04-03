import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/order/order_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../address/address_controller.dart';
import '../customer/customer_controller.dart';
import '../guarantors/guarantor_controller.dart';
import '../installments/installments_controller.dart';
import '../salesman/salesman_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final OrderRepository orderRepository = Get.put(OrderRepository());

  RxList<OrderModel> allOrders = <OrderModel>[].obs;


   Rx<OrderStatus> selectedStatus = OrderStatus.pending.obs;

  RxList<OrderItemModel> orderItems = <OrderItemModel>[].obs;

  final isStatusLoading = false.obs;
  final isOrderLoading = false.obs;

//Customer Order Detail
  RxList<OrderModel> currentOrders = <OrderModel>[].obs;
  String recentOrderDay = '';
  String  averageTotalAmount= '';


  TextEditingController newPaidAmount = TextEditingController();
  RxDouble remainingAmount = (0.0).obs;



  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  void setRemainingAmount(OrderModel order) {
    remainingAmount.value =(order.totalPrice) - (order.paidAmount ?? 0.0);
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

  Future<void> setUpOrderDetails(OrderModel order) async {
    try {
      // Convert the saleType and orderStatus based on the order values
      SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
            (e) => e.name == order.saletype,
        orElse: () => SaleType.cash,
      );

      OrderStatus? orderStatus = OrderStatus.values.firstWhere(
            (e) => e.name == order.status,
        orElse: () => OrderStatus.pending,
      );

      // Fetch controllers
      final OrderController orderController = Get.find<OrderController>();
      final InstallmentController installmentController = Get.find<InstallmentController>();
      final AddressController addressController = Get.find<AddressController>();
      final GuarantorController guarantorController = Get.find<GuarantorController>();
      final CustomerController customerController = Get.find<CustomerController>();
      final SalesmanController salesmanController = Get.find<SalesmanController>();

      // Fetch order items for the given order
      order.orderItems = await orderController.fetchOrderItems(order.orderId);

      // Handle installment-specific operations
      if (saleTypeFromOrder == SaleType.installment) {
        installmentController.fetchSpecificInstallmentPayment(order.orderId);
        guarantorController.fetchGuarantors(order.orderId);
      }

      // Set the selected order status
      orderController.selectedStatus.value = orderStatus;

      // Fetch customer info based on the order's customer ID
      customerController.fetchCustomerInfo(order.customerId ?? -1);

      // Fetch salesman info based on the order's salesman ID
      salesmanController.fetchSalesmanInfo(order.salesmanId ?? -1);

      // Fetch customer addresses
      addressController.fetchEntityAddresses(order.customerId ?? -1, 'Customer');

      // Set remaining amount for the order
      orderController.setRemainingAmount(order);

      // Navigate to the order details page
      Get.toNamed(TRoutes.orderDetails, arguments: order);

    } catch (e) {
      TLoader.errorSnackBar(
        title: 'Error',
        message: 'An error occurred while processing the order: $e',
      );
    }
  }



  // Future<void> fetchCustomerOrders(int customerId) async {
  //
  //   try {
  //     if (kDebugMode) {
  //       print(customerId);
  //     }
  //     isOrderLoading.value = true;
  //
  //     currentOrders.clear();
  //
  //
  //     currentOrders.assignAll(orders);
  //     print(currentOrders.length);
  //
  //
  //
  //
  //   } catch (e) {
  //     TLoader.errorSnackBar(title: e.toString());
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //
  //   }
  //   finally
  //   {
  //     isOrderLoading.value = false;
  //
  //   }
  //
  // }
  Future<void> fetchEntityOrders(int entityId, String entityName) async {
    try {
      if (kDebugMode) {
        print("Fetching orders for $entityName ID: $entityId");
      }

      isOrderLoading.value = true;

      // Clear the previous data
      currentOrders.clear();

      if (entityName == 'Customer') {
        // Fetch and filter orders for Customer
        final customerOrders = allOrders.where((order) => order.customerId == entityId).toList();
        currentOrders.assignAll(customerOrders);
      } else if (entityName == 'User') {
        // Fetch and filter orders for User
        final userOrders = allOrders.where((order) => order.userId == entityId).toList();
        currentOrders.assignAll(userOrders);
      } else if (entityName == 'Salesman') {
        // Fetch and filter orders for Salesman
        final salesmanOrders = allOrders.where((order) => order.salesmanId == entityId).toList();
        currentOrders.assignAll(salesmanOrders);
      } else {
        throw Exception('Invalid entity name: $entityName');
      }

      if (kDebugMode) {
        print("Filtered orders count for $entityName: ${currentOrders.length}");
      }
    } catch (e) {
      TLoader.errorSnackBar(title: "Error: ${e.toString()}"); // Handle errors properly
      if (kDebugMode) {
        print("Error fetching $entityName orders: $e");
      }
    } finally {
      isOrderLoading.value = false;
    }
  }





  Future<String> updateStatus(int orderId, String status) async {
    try {
      isStatusLoading.value = true;

      await orderRepository.updateStatus(orderId, status);

      // Update the status in allOrders list
      int index = allOrders.indexWhere((order) => order.orderId == orderId);
      if (index != -1) {
        allOrders[index] = allOrders[index].copyWith(status: status);
        allOrders.refresh(); // Notify UI about the update
      }

      return status;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
      return '';
    } finally {
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
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        print(e);
      }
    }
  }


  Future<List<OrderItemModel>> fetchOrderItems(int orderId) async {
    try {

      final orderItems = await orderRepository.fetchOrderItems(orderId);
      return orderItems;

    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<int>> getOrderIdsByProductIdService(int varaintId) async {
    try {

      final orderIds = await orderRepository.getOrderIdsByVariantId(varaintId);
      return orderIds;



    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
      return [];
    }
  }

  Future<void> restoreQuantity(List<OrderItemModel>? orderItems) async {
    try {


      if (orderItems != null) {
        for (var item in orderItems) {
          await orderRepository.restoreQuantity(item);
        }
        TLoader.successSnackBar(title: 'Product Quantity Restored!',message: 'stock is placed back, this order will not considered in Profit Analysis');
      } else {
        TLoader.errorSnackBar(title: 'Oh Snap!', message: 'Order items are null');
      }



    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());

    }

  }
  // Future<String> updateStatus(int orderId, String status) async {
  //   try {
  //     isStatusLoading.value = true;
  //
  //     // Get the old status before updating
  //     final order = allOrders.firstWhere((o) => o.orderId == orderId);
  //     final String oldStatus = order.status;
  //
  //     await orderRepository.updateStatus(orderId, status);
  //
  //     // Update order in RxList
  //     final index = allOrders.indexWhere((o) => o.orderId == orderId);
  //     if (index != -1) {
  //       allOrders[index] = allOrders[index].copyWith(status: status);
  //     }
  //
  //     // Check if status changed from "cancelled" to something else
  //     if (oldStatus == 'cancelled' && status != 'cancelled') {
  //       addBackQuantity(order.orderItems);
  //     }
  //     // If changed to "cancelled", restore quantity
  //     else if (status == 'cancelled') {
  //       restoreQuantity(order.orderItems);
  //     }
  //
  //     return status;
  //   } catch (e) {
  //     TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return '';
  //   } finally {
  //     isStatusLoading.value = false;
  //   }
  // }

  Future<void> addBackQuantity(List<OrderItemModel>? orderItems) async {
    if (orderItems != null) {
      for (var item in orderItems) {
        await orderRepository.subtractQuantity(item);
      }
      TLoader.successSnackBar(
          title: 'Stock Updated!', message: 'Products have been removed from stock.');
    } else {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: 'Order items are null');
    }
  }

  Future<void> updateOrderPaidAmount(int orderId, double newAmount) async {
    try {
      bool success = await orderRepository.updatePaidAmount(orderId, newAmount);

      if (success) {
        remainingAmount.value -= newAmount; // Update remaining amount in UI
        TLoader.successSnackBar(title: 'Success!', message: 'paid amount updated.');

      } else {

        TLoader.errorSnackBar(title: 'Oh Snap!', message: 'update failed!');

      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller Error: $e');
      }
    }
  }



}
