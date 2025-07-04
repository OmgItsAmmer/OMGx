import 'package:ecommerce_dashboard/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_dashboard/controllers/notification/notification_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/views/notifications/card/notification_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NotificationMobile extends StatelessWidget {
  const NotificationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Obx(() {
            final unreadCount = notificationController.unreadCount;
            return unreadCount > 0
                ? TextButton.icon(
                    onPressed: () => notificationController.markAllAsRead(),
                    icon: const Icon(Iconsax.tick_circle, size: 16),
                    label: const Text('Mark all as read'),
                    style: TextButton.styleFrom(
                      foregroundColor: TColors.primary,
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(
        () {
          final notifications = notificationController.allNotifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TAnimationLoaderWidget(
                    animation: TImages.docerAnimation,
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    'You will see your notifications here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Unread count indicator
              if (notificationController.unreadCount > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    color: TColors.info.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.message,
                            color: TColors.info, size: 14),
                        const SizedBox(width: TSizes.xs),
                        Text(
                          '${notificationController.unreadCount} unread notification${notificationController.unreadCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: TColors.info,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Notification list
              Padding(
                padding: EdgeInsets.only(
                  top: notificationController.unreadCount > 0 ? 30 : 0,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(TSizes.md),
                  itemCount: notifications.length,
                  itemBuilder: (_, index) {
                    final notification = notifications[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.md),
                      child: NotificationCardMobile(
                        notificationId: notification.notificationId.toString(),
                        onTapDelete: () {
                          notificationController.deleteNotification(
                              context, notification.notificationId);
                        },
                        onTapView: () {
                          NotificationType type =
                              (notification.notificationType ?? '')
                                  .toNotificationType();

                          switch (type) {
                            case NotificationType.installment:
                              notificationController
                                  .openOrder(notification.orderId ?? -1);
                              break;

                            case NotificationType.alertStock:
                              notificationController
                                  .openProduct(notification.productId ?? -1);
                              break;

                            default:
                              print('Unknown notification type');
                              break;
                          }
                          Get.back(); // Close notification screen after navigation
                        },
                        toggleRead: () async {
                          await notificationController.toggleRead(
                              notification, index);
                        },
                        markAsRead: notification.isRead.value,
                        description:
                            notification.description ?? 'No Description',
                        notificationType: notification.notificationType ??
                            NotificationType.company.toString(),
                        date: notification.createdAt,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
