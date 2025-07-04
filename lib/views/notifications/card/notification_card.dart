// ignore_for_file: deprecated_member_use

import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:ecommerce_dashboard/controllers/notification/notification_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
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
    final notificationColor =
        THelperFunctions.getNotificationColor(notificationTypeEnum);

    return GetBuilder<NotificationController>(
      id: notificationId, // Unique ID for this notification
      builder: (controller) {
        return MouseRegion(
          onEnter: (_) => controller.setHover(notificationId, true),
          onExit: (_) => controller.setHover(notificationId, false),
          child: Stack(
            children: [
              // Unread indicator
              if (!markAsRead)
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: notificationColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: markAsRead ? TColors.primaryBackground : TColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 0.5,
                    color: controller.isHovered(notificationId)
                        ? TColors.primary
                        : markAsRead
                            ? Colors.transparent
                            : notificationColor.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.isHovered(notificationId)
                          ? TColors.primary.withOpacity(0.2)
                          : markAsRead
                              ? Colors.transparent
                              : notificationColor.withOpacity(0.1),
                      blurRadius: controller.isHovered(notificationId) ? 8 : 4,
                      spreadRadius:
                          controller.isHovered(notificationId) ? 1 : 0,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: TRoundedContainer(
                  backgroundColor: Colors.transparent,
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification icon with styled container
                          TRoundedContainer(
                            backgroundColor: notificationColor
                                .withOpacity(markAsRead ? 0.7 : 1.0),
                            radius: 12,
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              THelperFunctions.getNotificationIcon(
                                  notificationTypeEnum),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),

                          // Notification content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: markAsRead
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              color: markAsRead
                                                  ? TColors.textSecondary
                                                  : TColors.textPrimary,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(
                                        width: TSizes.spaceBtwItems / 2),
                                    // Push date to right side
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: markAsRead
                                            ? TColors.lightGrey
                                            : notificationColor
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        formattedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: markAsRead
                                                    ? TColors.darkGrey
                                                    : notificationColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TSizes.spaceBtwItems),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Actions row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Mark as read toggle button
                          InkWell(
                            onTap: () {
                              toggleRead();
                              controller.update([notificationId]);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: markAsRead
                                    ? TColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: markAsRead
                                      ? TColors.primary
                                      : TColors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    markAsRead
                                        ? Iconsax.tick_circle
                                        : Iconsax.tick_circle5,
                                    color: markAsRead
                                        ? TColors.primary
                                        : TColors.darkGrey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    markAsRead ? 'Read' : 'Mark as read',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: markAsRead
                                          ? TColors.primary
                                          : TColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),

                          // View and delete actions
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
            ],
          ),
        );
      },
    );
  }
}
