import 'package:admin_dashboard_v3/common/widgets/loaders/animation_loader.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/notifications/card/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDesktop extends StatelessWidget {
  const NotificationDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find<NotificationController>();

    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
        itemCount: notificationController.allNotifications.length,
        itemBuilder: (_, index) {
          if(notificationController.allNotifications.isEmpty){
            return TAnimationLoaderWidget(animation: TImages.docerAnimation ,);
          }

          final notification = notificationController.allNotifications[index];

          return  NotificationCard(
            notificationId: notification.notificationId.toString(),
                onTapDelete: () {

                      notificationController.deleteNotification(context,notification.notificationId);


                },
            onTapView: () {
              NotificationType type = (notification.notificationType ?? '').toNotificationType();


              switch (type) {
                case NotificationType.installment:
                  notificationController.openOrder(notification.orderId ?? -1);
                  break;

                case NotificationType.alertStock:
                  notificationController.openProduct(notification.productId ?? -1);
                  break;

                default:
                  print('Unknown notification type');
                  break;
              }
            },

            toggleRead: () async {
                await notificationController.toggleRead(notification,index);
              },
              markAsRead: notification.isRead.value,
              description: notification.description ?? 'No Description',
              notificationType: notification.notificationType ?? NotificationType.company.toString(),
              date: notification.createdAt,
            );

        },
      ),
    );
  }
}
