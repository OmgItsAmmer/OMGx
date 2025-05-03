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

class NotificationDesktop extends StatelessWidget {
  const NotificationDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Obx(
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

        // Get unread count from controller
        final unreadCount = notificationController.unreadCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with counts
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.md),
              child: Row(
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.circular(TSizes.sm),
                    ),
                    child: Text(
                      '${notifications.length}',
                      style: const TextStyle(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.md, vertical: TSizes.xs),
                      decoration: BoxDecoration(
                        color: TColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.sm),
                        border: Border.all(
                          color: TColors.info.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.message,
                              color: TColors.info, size: 16),
                          const SizedBox(width: TSizes.xs),
                          Text(
                            '$unreadCount unread',
                            style: const TextStyle(
                              color: TColors.info,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: TSizes.md),
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
                ],
              ),
            ),

            // Notification list with staggered animation
            ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
        itemBuilder: (_, index) {
                final notification = notifications[index];

                return AnimatedSlide(
                  offset: Offset(0, 0),
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.easeOutQuart,
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                      child: NotificationCard(
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
                  ),
            );
        },
      ),
          ],
        );
      },
    );
  }
}
