import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/notifications/card/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationDesktop extends StatelessWidget {
  const NotificationDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
      itemCount: 10,
      itemBuilder: (_, index) {
        return const NotificationCard(
          markAsRead: true,
          description: 'Installment No 7 of Order No 13 is due in 3 days!',
          notificationType: NotificationType.company,
          date: '09-12-2025 1:45PM',
        );
      },
    );
  }
}