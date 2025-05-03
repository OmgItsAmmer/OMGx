import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../utils/helpers/helper_functions.dart';

class NotificationCardMobile extends StatelessWidget {
  final String description;
  final String notificationType;
  final DateTime date;
  final bool markAsRead;
  final VoidCallback toggleRead;
  final VoidCallback onTapView;
  final VoidCallback onTapDelete;
  final String notificationId;

  const NotificationCardMobile({
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
    final formattedDate = DateFormat('HH:mm • dd/MM/yyyy').format(date);
    final notificationTypeEnum = NotificationType.values.firstWhere(
      (e) => e.name == notificationType,
      orElse: () => NotificationType.company,
    );
    final notificationColor =
        THelperFunctions.getNotificationColor(notificationTypeEnum);

    return GetBuilder<NotificationController>(
      id: notificationId,
      builder: (controller) {
        return GestureDetector(
          onTap: onTapView,
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
              Container(
                decoration: BoxDecoration(
                  color: markAsRead ? TColors.primaryBackground : TColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 0.5,
                    color: markAsRead
                        ? Colors.transparent
                        : notificationColor.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: markAsRead
                          ? Colors.transparent
                          : notificationColor.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: notificationColor
                                  .withOpacity(markAsRead ? 0.7 : 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              THelperFunctions.getNotificationIcon(
                                  notificationTypeEnum),
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: TSizes.sm),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: markAsRead
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        color: markAsRead
                                            ? TColors.textSecondary
                                            : TColors.textPrimary,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: TColors.darkGrey,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: TSizes.sm),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Mark as read button
                          TextButton.icon(
                            onPressed: toggleRead,
                            icon: Icon(
                              markAsRead
                                  ? Iconsax.tick_circle
                                  : Iconsax.tick_circle5,
                              size: 16,
                              color: markAsRead
                                  ? TColors.primary
                                  : TColors.darkGrey,
                            ),
                            label: Text(
                              markAsRead ? 'Read' : 'Mark as read',
                              style: TextStyle(
                                fontSize: 12,
                                color: markAsRead
                                    ? TColors.primary
                                    : TColors.darkGrey,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),

                          // Delete button
                          IconButton(
                            onPressed: onTapDelete,
                            icon: Icon(Iconsax.trash,
                                size: 18,
                                color: TColors.error.withOpacity(0.8)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
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
