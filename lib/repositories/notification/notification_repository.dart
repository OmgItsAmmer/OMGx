import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/notifications/notification_model.dart';
import '../../main.dart';



class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  @override
  void onInit() {
    triggerInstallmentNotifications();
    super.onInit();

  }
  // Function to fetch notifications from Supabase
  Future<List<NotificationModel>> fetchNotifications({int limit = 10}) async {
    try {
      final response = await supabase
          .from('notifications')
          .select()
          .order('created_at', ascending: false) // Latest notifications first
          .limit(limit);

      if (response.isEmpty) return []; // Return empty list if no data

      return response.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Notification Repo Fetch issue',message: e.toString());
        print("Error fetching notifications: $e");
      }
      return [];
    }
  }



  Future<void> triggerInstallmentNotifications() async {


    try {
      final response = await supabase.rpc('notify_due_installments');
      if (kDebugMode) {
        print("Notification trigger response: $response");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error triggering notifications: $error");
      }
    }
  }

  Future<void> changeRead(bool newCondition, int notificationId) async {
    try {


      await supabase
          .from('notifications')  // Table name
          .update({'isRead': newCondition})  // Field to update
          .eq('notification_id', notificationId);  // Condition to find the correct row



      if (kDebugMode) {
        print('Notification read status updated successfully.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error triggering notifications: $error');
      }
    }
  }

  Future<void> deleteNotificationFromTable(int notificationId) async {


    try {
       await supabase
          .from('notifications')
          .delete()
          .eq('notification_id', notificationId);


    } catch (e) {
      if (kDebugMode) {
        print("Exception deleting notification: $e");
      }
    }
  }


}