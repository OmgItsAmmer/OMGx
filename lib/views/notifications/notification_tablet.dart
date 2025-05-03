import 'package:admin_dashboard_v3/common/widgets/loaders/animation_loader.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/views/notifications/card/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NotificationTablet extends StatelessWidget {
  const NotificationTablet({super.key});

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
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.md, vertical: 4),
              margin: const EdgeInsets.only(right: TSizes.md),
              decoration: BoxDecoration(
                color: unreadCount > 0
                    ? TColors.info.withOpacity(0.1)
                    : TColors.lightGrey,
                borderRadius: BorderRadius.circular(TSizes.sm),
                border: Border.all(
                  color: unreadCount > 0
                      ? TColors.info.withOpacity(0.5)
                      : TColors.darkGrey.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.message,
                    color: unreadCount > 0 ? TColors.info : TColors.darkGrey,
                    size: 16,
                  ),
                  const SizedBox(width: TSizes.xs),
                  Text(
                    unreadCount > 0 ? '$unreadCount unread' : 'All read',
                    style: TextStyle(
                      color: unreadCount > 0 ? TColors.info : TColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: () => notificationController.markAllAsRead(),
            icon: const Icon(Iconsax.tick_circle, size: 16),
            label: const Text('Mark all as read'),
            style: TextButton.styleFrom(
              foregroundColor: TColors.primary,
              backgroundColor: TColors.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.md, vertical: TSizes.xs),
            ),
          ),
          const SizedBox(width: TSizes.md),
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
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.headlineSmall,
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of notifications with animation
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (_, index) {
                    final notification = notifications[index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300 + (index * 30)),
                        child: NotificationCard(
                          notificationId:
                              notification.notificationId.toString(),
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
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
