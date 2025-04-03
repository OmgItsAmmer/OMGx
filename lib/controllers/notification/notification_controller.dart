import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repositories/notification/notification_repository.dart';
import '../../utils/constants/sizes.dart';
import '../../views/notifications/notifcaation_desktop.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  final NotificationRepository notificationRepository =
  Get.put(NotificationRepository());


  //
RxBool isMarkAsRead = false.obs;

  //Rx<>

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
}
