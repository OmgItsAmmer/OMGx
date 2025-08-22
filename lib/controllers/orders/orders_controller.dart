import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/dashboard/dashboard_controoler.dart';
import 'package:ecommerce_dashboard/controllers/expenses/expense_controller.dart';
import 'package:ecommerce_dashboard/controllers/installments/installments_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/repositories/order/order_repository.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Models/salesman/salesman_model.dart';
import '../../routes/routes.dart';
import '../address/address_controller.dart';
import '../customer/customer_controller.dart';
import '../guarantors/guarantor_controller.dart';
import '../sales/sales_controller.dart';
import '../salesman/salesman_controller.dart';
import '../../main.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final OrderRepository orderRepository = Get.put(OrderRepository());

  RxList<OrderModel> allOrders = <OrderModel>[].obs;

  Rx<OrderStatus> selectedStatus = OrderStatus.pending.obs;

  RxList<OrderItemModel> orderItems = <OrderItemModel>[].obs;

  final isStatusLoading = false.obs;
  final isOrderLoading = false.obs;
  final isOrdersFetching = false.obs;

//Customer Order Detail
  RxList<OrderModel> currentOrders = <OrderModel>[].obs;
  String recentOrderDay = '';
  String averageTotalAmount = '';

  TextEditingController newPaidAmount = TextEditingController();
  RxDouble remainingAmount = (0.0).obs;

  // @override
  // void onInit() {
  //   fetchOrders();
  //   super.onInit();
  // }

  Future<void> fetchOrders() async {
    try {
      isOrdersFetching.value = true;
      final orders = await orderRepository.fetchOrders();

      // Assign the fetched orders directly without reversing
      allOrders.assignAll(orders);
      currentOrders.assignAll(orders);

      // Dashboard will auto-update through reactive listeners
      // No need to manually trigger dashboard updates here
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        print(e);
      }
    } finally {
      isOrdersFetching.value = false;
    }
  }

  void setRemainingAmount(OrderModel order) {
    // Convert salesman commission from percentage to amount
    double salesmanCommissionAmount =
        (order.subTotal * (order.salesmanComission ?? 0)) / 100;

    // Calculate the total amount including subtotal, shipping tax, and salesman commission
    double totalAmount = (order.subTotal - (order.discount)) +
        (order.shippingFee) +
        salesmanCommissionAmount +
        (order.tax);

    // Calculate the remaining amount with discount
    remainingAmount.value = totalAmount - (order.paidAmount ?? 0.0);
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
    DateTime orderDate =
        DateTime.parse(recentOrder.orderDate); // Parse the orderDate

    // Calculate the difference in days
    recentOrderDay =
        '${currentDate.difference(orderDate).inDays} Days Ago (#${recentOrder.orderId})';
  }

  // Function to set the average of totalPrice
  void setAverageTotalAmount() {
    if (currentOrders.isEmpty) {
      averageTotalAmount = "0.0"; // Set to 0 if there are no orders
      return;
    }

    // Calculate the sum of all total prices
    double totalSum =
        currentOrders.fold(0.0, (sum, order) => sum + order.subTotal);

    // Calculate the average and set the class variable
    double average = totalSum / currentOrders.length;
    averageTotalAmount =
        average.toStringAsFixed(2); // Format to 2 decimal places
  }

  void resetCustomerOrders() {
    try {
      currentOrders.assignAll(allOrders);
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString()); //TODO remove it
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
      final InstallmentController installmentController =
          Get.find<InstallmentController>();
      final AddressController addressController = Get.find<AddressController>();
      final GuarantorController guarantorController =
          Get.find<GuarantorController>();
      final CustomerController customerController =
          Get.find<CustomerController>();
      final SalesmanController salesmanController =
          Get.find<SalesmanController>();

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
      if (order.shippingMethod != 'pickup') {
        addressController.fetchOrderAddress(order.addressId ?? -1);
      }
      else {
        addressController.clearSelectedOrderAddress();
      }

      // Set remaining amount for the order
      orderController.setRemainingAmount(order);

      // Navigate to the order details page
      Get.toNamed(TRoutes.orderDetails, arguments: order);
    } catch (e) {
      TLoaders.errorSnackBar(
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
  Future<void> fetchEntityOrders(int entityId, EntityType entityType) async {
    try {
      if (kDebugMode) {
        print("Fetching orders for ${entityType.name} ID: $entityId");
      }

      isOrderLoading.value = true;

      // Clear the previous data
      currentOrders.clear();

      switch (entityType) {
        case EntityType.customer:
          // Fetch and filter orders for Customer
          final customerOrders =
              allOrders.where((order) => order.customerId == entityId).toList();
          currentOrders.assignAll(customerOrders);
          break;
        case EntityType.user:
          // Fetch and filter orders for User
          final userOrders =
              allOrders.where((order) => order.userId == entityId).toList();
          currentOrders.assignAll(userOrders);
          break;
        case EntityType.salesman:
          // Fetch and filter orders for Salesman
          final salesmanOrders =
              allOrders.where((order) => order.salesmanId == entityId).toList();
          currentOrders.assignAll(salesmanOrders);
          break;
        default:
          throw Exception('Invalid entity type: ${entityType.name}');
      }

      if (kDebugMode) {
        print(
            "Filtered orders count for ${entityType.name}: ${currentOrders.length}");
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Error: ${e.toString()}"); // Handle errors properly
      if (kDebugMode) {
        print("Error fetching ${entityType.name} orders: $e");
      }
    } finally {
      isOrderLoading.value = false;
    }
  }

  // Future<String> updateStatus(int orderId, String status) async {
  //   try {
  //     isStatusLoading.value = true;

  //     // Validate order exists before updating
  //     int index = allOrders.indexWhere((order) => order.orderId == orderId);
  //     if (index == -1) {
  //       throw Exception('Order not found with ID: $orderId');
  //     }

  //     // Get the original status for comparison
  //     final originalStatus = allOrders[index].status;

  //     // CRITICAL: Check stock availability BEFORE making any changes
  //     // If moving from cancelled to another status, validate stock first
  //     if (originalStatus == 'cancelled' && status != 'cancelled') {
  //       if (allOrders[index].orderItems != null &&
  //           allOrders[index].orderItems!.isNotEmpty) {
  //         // Check if there's enough stock available before allowing status change
  //         bool hasStock = await orderRepository
  //             .checkStockAvailability(allOrders[index].orderItems!);

  //         if (!hasStock) {
  //           TLoaders.errorSnackBar(
  //               title: 'Insufficient Stock',
  //               message:
  //                   'Cannot change order status from cancelled to $status. Some products are out of stock or variants are already sold.');
  //           return originalStatus; // Return original status if stock check fails
  //         }
  //       }
  //     }

  //     // Update status in database
  //     await orderRepository.updateStatus(orderId, status);

  //     // If the new status is 'ready', call the Supabase edge function
  //     if (status == 'ready') {
  //       try {
  //         final order = allOrders[index];
  //         final response = await supabase.functions.invoke(
  //           'notify-ready',
  //           body: {
  //             "new": {
  //               "order_id": order.orderId,
  //               "customer_id": order
  //                   .customerId, // This must exist in your `customers` table
  //             }
  //           },
  //         );
  //         if (kDebugMode) {
  //           print('notify-ready response: \\${response.data}');
  //         }
  //       } catch (e) {
  //         if (kDebugMode) {
  //           print(
  //               'Error invoking notify-ready edge function: \\${e.toString()}');
  //         }
  //       }
  //     }

  //     // Update the status in allOrders list
  //     allOrders[index] = allOrders[index].copyWith(status: status);
  //     allOrders.refresh(); // Notify UI about the update

  //     // Dashboard will auto-update through reactive listeners

  //     // If moving to cancelled and order items exist, handle stock restoration
  //     if (status == 'cancelled' && originalStatus != 'cancelled') {
  //       // Make sure order items are available
  //       if (allOrders[index].orderItems != null &&
  //           allOrders[index].orderItems!.isNotEmpty) {
  //         await restoreQuantity(allOrders[index].orderItems);
  //       }
  //     }
  //     // If moving from cancelled to another status, handle adding back quantity
  //     else if (originalStatus == 'cancelled' && status != 'cancelled') {
  //       if (allOrders[index].orderItems != null &&
  //           allOrders[index].orderItems!.isNotEmpty) {
  //         // Stock was already validated above, now subtract the quantity
  //         await addBackQuantity(allOrders[index].orderItems);
  //       }
  //     }

  //     return status;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error updating order status: $e');
  //     }
  //     TLoaders.errorSnackBar(
  //         title: 'Status Update Error', message: e.toString());
  //     return '';
  //   } finally {
  //     isStatusLoading.value = false;
  //   }
  // }

  Future<String> updateStatus(int orderId, String status) async {
    try {
      isStatusLoading.value = true;

      // Validate order exists before updating
      int index = allOrders.indexWhere((order) => order.orderId == orderId);
      if (index == -1) {
        throw Exception('Order not found with ID: $orderId');
      }

      // Get the original status for comparison
      final originalStatus = allOrders[index].status;

      // CRITICAL: Check stock availability BEFORE making any changes
      // If moving from cancelled to another status, validate stock first
      if (originalStatus == 'cancelled' && status != 'cancelled') {
        if (allOrders[index].orderItems != null &&
            allOrders[index].orderItems!.isNotEmpty) {
          // Check if there's enough stock available before allowing status change
          bool hasStock = await orderRepository
              .checkStockAvailability(allOrders[index].orderItems!);

          if (!hasStock) {
            TLoaders.errorSnackBar(
                title: 'Insufficient Stock',
                message:
                    'Cannot change order status from cancelled to $status. Some products are out of stock or variants are already sold.');
            return originalStatus; // Return original status if stock check fails
          }
        }
      }

      // Update status in database
      await orderRepository.updateStatus(orderId, status);

      // Call the generic notification edge function for any status change
      try {
        final order = allOrders[index];
        final response = await supabase.functions.invoke(
          'status_update', // Update this to your actual edge function name
          body: {
            "new": {
              "order_id": order.orderId,
              "customer_id": order.customerId,
              "status": status, // Pass the new status
            }
          },
        );
        if (kDebugMode) {
          print('generic-order-notification response: ${response.data}');
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              'Error invoking generic-order-notification edge function: ${e.toString()}');
        }
      }

      // Update the status in allOrders list
      allOrders[index] = allOrders[index].copyWith(status: status);
      allOrders.refresh(); // Notify UI about the update

      // Dashboard will auto-update through reactive listeners

      // If moving to cancelled and order items exist, handle stock restoration
      if (status == 'cancelled' && originalStatus != 'cancelled') {
        // Make sure order items are available
        if (allOrders[index].orderItems != null &&
            allOrders[index].orderItems!.isNotEmpty) {
          await restoreQuantity(allOrders[index].orderItems);
        }
      }
      // If moving from cancelled to another status, handle adding back quantity
      else if (originalStatus == 'cancelled' && status != 'cancelled') {
        if (allOrders[index].orderItems != null &&
            allOrders[index].orderItems!.isNotEmpty) {
          // Stock was already validated above, now subtract the quantity
          await addBackQuantity(allOrders[index].orderItems);
        }
      }

      return status;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order status: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Status Update Error', message: e.toString());
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

  Future<List<OrderItemModel>> fetchOrderItems(int orderId) async {
    try {
      final orderItems = await orderRepository.fetchOrderItems(orderId);
      return orderItems;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
      return [];
    }
  }

  Future<void> restoreQuantity(List<OrderItemModel>? orderItems) async {
    try {
      if (orderItems == null || orderItems.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'No order items to restore');
        return;
      }

      for (var item in orderItems) {
        // Skip null items
        if (item == null) continue;

        try {
          await orderRepository.restoreQuantity(item);
        } catch (e) {
          if (kDebugMode) {
            print('Error restoring quantity for item: $e');
          }
          // Continue with other items even if one fails
        }
      }

      // Refresh product list to ensure consistent data
      try {
        final productController = Get.find<ProductController>();
        await productController.refreshProducts();
      } catch (e) {
        if (kDebugMode) {
          print('Error refreshing products: $e');
        }
      }

      TLoaders.successSnackBar(
          title: 'Product Quantity Restored!',
          message:
              'Stock has been placed back, this order will not be considered in Profit Analysis');
    } catch (e) {
      if (kDebugMode) {
        print('Error in restoreQuantity: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Restore Error',
          message: 'Failed to restore product quantities');
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
    try {
      if (orderItems == null || orderItems.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'No order items to process');
        return;
      }

      for (var item in orderItems) {
        // Skip null items
        if (item == null) continue;

        try {
          await orderRepository.subtractQuantity(item);
        } catch (e) {
          if (kDebugMode) {
            print('Error subtracting quantity for item: $e');
          }
          // Continue with other items even if one fails
        }
      }

      // Refresh product list to ensure consistent data
      try {
        final productController = Get.find<ProductController>();
        await productController.refreshProducts();
        TLoaders.successSnackBar(
          title: 'Refreshed!',
          message: 'Order list has been updated.',
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error refreshing products: $e');
        }
      }

      TLoaders.successSnackBar(
          title: 'Stock Updated!',
          message: 'Products have been removed from stock successfully.');
    } catch (e) {
      if (kDebugMode) {
        print('Error in addBackQuantity: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Subtract Error',
          message: 'Failed to subtract product quantities');
    }
  }

  Future<void> updateOrderPaidAmount(int orderId, double newAmount) async {
    try {
      bool success = await orderRepository.updatePaidAmount(orderId, newAmount);

      if (success) {
        // Update remaining amount in UI
        remainingAmount.value -= newAmount;

        // Update the order in allOrders list
        final allOrdersIndex =
            allOrders.indexWhere((order) => order.orderId == orderId);
        if (allOrdersIndex != -1) {
          final updatedOrder = allOrders[allOrdersIndex].copyWith(
            paidAmount:
                (allOrders[allOrdersIndex].paidAmount ?? 0.0) + newAmount,
          );
          allOrders[allOrdersIndex] = updatedOrder;
          allOrders.refresh(); // Notify UI about the update
        }

        // Update the order in currentOrders list
        final currentOrdersIndex =
            currentOrders.indexWhere((order) => order.orderId == orderId);
        if (currentOrdersIndex != -1) {
          final updatedOrder = currentOrders[currentOrdersIndex].copyWith(
            paidAmount: (currentOrders[currentOrdersIndex].paidAmount ?? 0.0) +
                newAmount,
          );
          currentOrders[currentOrdersIndex] = updatedOrder;
          currentOrders.refresh(); // Notify UI about the update
        }

        TLoaders.successSnackBar(
          title: 'Success!',
          message: 'Paid amount updated.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: 'Update failed!',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller Error: $e');
      }
    }
  }

  //edit order (transfering data from order to sales screen fields in sales_controller)
  void transferOrderDataToSalesScreen(OrderModel order) {
    //transfer data from order to sales screen fields in sales_controller
    final salesController = Get.find<SalesController>();

    try {
      //step by step
      //step 1 customer info transfer

      //step 2 salesman info transfer

      //step 3 order items transfer

      //step 4 order info transfer
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> editOrder(OrderModel order) async {
    try {
      final salesController = Get.find<SalesController>();

      // Setup the order for editing with proper state management
      await salesController.setupOrderForEditing(order);

      // Navigate to sales screen in edit mode
      Get.toNamed(TRoutes.sales);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }
}
