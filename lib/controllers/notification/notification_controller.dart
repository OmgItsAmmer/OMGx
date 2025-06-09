import 'package:admin_dashboard_v3/Models/notifications/notification_model.dart';
import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/notifications/notification_mobile.dart';
import 'package:admin_dashboard_v3/views/notifications/notification_tablet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/products/product_model.dart';
import '../../repositories/notification/notification_repository.dart';
import '../../utils/constants/sizes.dart';
import '../../views/notifications/notifcaation_desktop.dart';
import '../product/product_controller.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  final NotificationRepository notificationRepository =
      Get.put(NotificationRepository());
  final ProductController productController = Get.find<ProductController>();
  final OrderController orderController = Get.find<OrderController>();

  //
  RxBool isMarkAsRead = false.obs;

  RxList<NotificationModel> allNotifications = <NotificationModel>[].obs;

  // Computed property for unread count
  int get unreadCount => allNotifications.where((n) => !n.isRead.value).length;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      final notifications = await notificationRepository.fetchNotifications();
      allNotifications.assignAll(notifications);
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'Notification Controller', message: e.toString());
        print(e);
      }
    }
  }

  Future<void> showNotifications() async {
    // Determine which screen to show based on device size
    final context = Get.context!;

    if (TDeviceUtils.isDesktopScreen(context)) {
      // Show desktop notifications as bottom sheet
      await showNotificationsBottomSheet();
    } else if (TDeviceUtils.isTabletScreen(context)) {
      // Show tablet view as a new screen
      await Get.to(() => const NotificationTablet());
    } else {
      // Show mobile view as a new screen
      await Get.to(() => const NotificationMobile());
    }
  }

  Future<void> showNotificationsBottomSheet() async {
    await Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      const ClipRRect(
        borderRadius: BorderRadius.zero,
        child: FractionallySizedBox(
          heightFactor: 1.0,
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Expanded content area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(TSizes.defaultSpace),
                    child: NotificationDesktop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openProduct(int productId) {
    try {
      // Find the product with the matching productId from the allProducts array
      ProductModel? productModel = productController.allProducts.firstWhere(
        (product) => product.productId == productId,
        orElse: () =>
            ProductModel.empty(), // If no product is found, return null
      );

      // Navigate to the product details page and pass the productModel
      productController.onProductTap(productModel);
      Get.toNamed(TRoutes.productsDetail);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(
            title: 'Error opening product screen', message: e.toString());
      }
    }
  }

  void openOrder(int orderId) {
    try {
      // Find the product with the matching productId from the allProducts array
      OrderModel? orderModel = orderController.allOrders.firstWhere(
        (order) => order.orderId == orderId,
        orElse: () => OrderModel.empty(), // If no product is found, return null
      );

      // Navigate to the product details page and pass the productModel
      Get.toNamed(TRoutes.orderDetails, arguments: orderModel);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(
            title: 'Error opening product screen', message: e.toString());
      }
    }
  }

  Future<void> toggleRead(NotificationModel model, int index) async {
    try {
      final newCondition = !model.isRead.value;

      await notificationRepository.changeRead(
          newCondition, model.notificationId);

      allNotifications[index].isRead.value = newCondition;

      allNotifications.refresh();
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(
            title: 'Error opening product screen', message: e.toString());
      }
    }
  }

  // Method to mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      // Get all unread notifications
      final unreadNotifications =
          allNotifications.where((n) => !n.isRead.value).toList();

      if (unreadNotifications.isEmpty) return;

      // Update each notification
      for (final notification in unreadNotifications) {
        final index = allNotifications
            .indexWhere((n) => n.notificationId == notification.notificationId);
        if (index != -1) {
          await notificationRepository.changeRead(
              true, notification.notificationId);
          allNotifications[index].isRead.value = true;
        }
      }

      allNotifications.refresh();
      TLoader.successSnackBar(
        title: 'Notifications',
        message: 'All notifications marked as read',
        duration: 2,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(
            title: 'Error marking notifications as read',
            message: e.toString());
      }
    }
  }

  Future<void> deleteNotification(
      BuildContext context, int notificationId) async {
    try {
      // Show confirmation dialog
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text(
                'Are you sure you want to delete this notification?'),
            actions: [
              OutlinedButton(
                onPressed: () =>
                    Navigator.pop(context, false), // Dismiss dialog
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true), // Confirm delete
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      // If user confirms deletion
      if (confirmDelete == true) {
        await notificationRepository
            .deleteNotificationFromTable(notificationId);

        // Remove the notification from the local list
        allNotifications.removeWhere(
            (notification) => notification.notificationId == notificationId);

        TLoader.successSnackBar(
          title: 'Success',
          message: 'Notification deleted successfully',
          duration: 2,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        Get.snackbar('Error', 'Error deleting notification: ${e.toString()}');
      }
    }
  }

  final _hoverStates = <String, bool>{};

  bool isHovered(String notificationId) =>
      _hoverStates[notificationId] ?? false;

  void setHover(String notificationId, bool value) {
    _hoverStates[notificationId] = value;
    update([notificationId]);
  }
}
