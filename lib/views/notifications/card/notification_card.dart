import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../utils/helpers/helper_functions.dart';

class NotificationCard extends StatelessWidget {
  final String description;
  final String notificationType;
  final DateTime date;
  final bool markAsRead;
  final VoidCallback toggleRead;
  final VoidCallback onTapView;
  final VoidCallback onTapDelete;
  final String notificationId; // Add ID for individual updates

  const NotificationCard({
    super.key,
    required this.description,
    required this.notificationType,
    required this.date,
    required this.markAsRead,
    required this.toggleRead,
    required this.onTapView,
    required this.onTapDelete,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('HH:mm  dd/MM/yyyy').format(date);
    final notificationTypeEnum = NotificationType.values.firstWhere(
          (e) => e.name == notificationType,
      orElse: () => NotificationType.company,
    );

    return GetBuilder<NotificationController>(
      id: notificationId, // Unique ID for this notification
      builder: (controller) {
        return MouseRegion(
          onEnter: (_) => controller.setHover(notificationId, true),
          onExit: (_) => controller.setHover(notificationId, false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: controller.isHovered(notificationId)
                  ? TColors.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 0.5,
                color: controller.isHovered(notificationId)
                    ? TColors.primary
                    : Colors.transparent,
              ),
              boxShadow: controller.isHovered(notificationId)
                  ? [
                BoxShadow(
                  color: TColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                )
              ]
                  : [],
            ),
            child: TRoundedContainer(
              backgroundColor: TColors.primaryBackground,
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            TRoundedContainer(
                              backgroundColor:
                              THelperFunctions.getNotificationColor(
                                  notificationTypeEnum),
                              child: Icon(
                                THelperFunctions.getNotificationIcon(
                                    notificationTypeEnum),
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(formattedDate,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          toggleRead();
                          controller.update([notificationId]);
                        },
                        child: Icon(
                          Iconsax.tick_circle,
                          color: markAsRead ? TColors.primary : Colors.black,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      TTableActionButtons(
                        view: true,
                        delete: true,
                        edit: false,
                        onViewPressed: onTapView,
                        onDeletePressed: onTapDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}