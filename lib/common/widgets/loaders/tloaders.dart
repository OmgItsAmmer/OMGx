import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class TLoader {
  /// Gets a safe context for showing snackbars, preferring overlay context if available
  static BuildContext? _getSafeContext() {
    try {
      // Try to get the overlay context first (better for dialogs/modals)
      if (Get.overlayContext != null) return Get.overlayContext!;
      // Fall back to normal context
      if (Get.context != null) return Get.context!;
      return null;
    } catch (e) {
      debugPrint('Error getting safe context: $e');
      return null;
    }
  }

  /// Hides any currently visible snackbar
  static hideSnackBar() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      } else {
        final context = _getSafeContext();
        if (context != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    } catch (e) {
      debugPrint('Error hiding snackbar: $e');
    }
  }

  /// Shows a custom toast message
  static customToast({required String message}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show custom toast: No valid context');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: THelperFunctions.isDarkMode(context)
                  ? TColors.darkerGrey.withOpacity(0.9)
                  : TColors.grey.withOpacity(0.9),
            ),
            child: Center(
                child: Text(
              message,
              style: Theme.of(context).textTheme.labelLarge,
            )),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing custom toast: $e');
      // Fallback to GetX snackbar if traditional snackbar fails
      _fallbackGetSnackbar(message: message);
    }
  }

  /// Shows a success snackbar using Get.rawSnackbar for better compatibility
  static successSnackBar(
      {required String title, String message = '', int duration = 3}) {
    try {
      // hideSnackBar(); // Temporarily comment out

      Get.rawSnackbar(
        titleText: Text(title,
            style: const TextStyle(
                color: TColors.white, fontWeight: FontWeight.bold)),
        messageText:
            Text(message, style: const TextStyle(color: TColors.white)),
        icon: const Icon(Iconsax.check, color: TColors.white, size: 20),
        isDismissible: true,
        shouldIconPulse: true,
        backgroundColor: TColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
        maxWidth: 600, // Keep max width for consistency
      );
    } catch (e) {
      debugPrint('Error showing success snackbar (raw): $e');
      // Minimal fallback if even raw fails
      _fallbackGetSnackbar(title: title, message: message, isSuccess: true);
    }
  }

  /// Shows a warning snackbar using Get.rawSnackbar
  static warningSnackBar({required String title, String message = ''}) {
    try {
      // hideSnackBar(); // Temporarily comment out

      Get.rawSnackbar(
        titleText: Text(title,
            style: const TextStyle(
                color: TColors.white, fontWeight: FontWeight.bold)),
        messageText:
            Text(message, style: const TextStyle(color: TColors.white)),
        icon: const Icon(Iconsax.warning_2, color: TColors.white, size: 20),
        isDismissible: true,
        shouldIconPulse: true,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
        maxWidth: 600,
      );
    } catch (e) {
      debugPrint('Error showing warning snackbar (raw): $e');
      _fallbackGetSnackbar(title: title, message: message, isWarning: true);
    }
  }

  /// Shows an error snackbar using Get.rawSnackbar
  static errorSnackBar({required String title, String message = ''}) {
    try {
      // hideSnackBar(); // Temporarily comment out

      Get.rawSnackbar(
        titleText: Text(title,
            style: const TextStyle(
                color: TColors.white, fontWeight: FontWeight.bold)),
        messageText:
            Text(message, style: const TextStyle(color: TColors.white)),
        icon: const Icon(Iconsax.warning_2, color: TColors.white, size: 20),
        isDismissible: true,
        shouldIconPulse: true,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
        maxWidth: 600,
      );
    } catch (e) {
      debugPrint('Error showing error snackbar (raw): $e');
      _fallbackGetSnackbar(title: title, message: message, isError: true);
    }
  }

  /// Shows an info snackbar using Get.rawSnackbar
  static infoSnackBar(
      {required String title, String message = '', int duration = 3}) {
    try {
      Get.rawSnackbar(
        titleText: Text(title,
            style: const TextStyle(
                color: TColors.white, fontWeight: FontWeight.bold)),
        messageText:
            Text(message, style: const TextStyle(color: TColors.white)),
        icon: const Icon(Iconsax.information, color: TColors.white, size: 20),
        isDismissible: true,
        shouldIconPulse: true,
        backgroundColor: TColors.info,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(20),
        borderRadius: 10,
        maxWidth: 600,
      );
    } catch (e) {
      debugPrint('Error showing info snackbar (raw): $e');
      _fallbackGetSnackbar(title: title, message: message, isInfo: true);
    }
  }

  /// Fallback method that tries to show a simpler snackbar when the main one fails
  static void _fallbackGetSnackbar(
      {String title = '',
      String message = '',
      bool isSuccess = false,
      bool isWarning = false,
      bool isError = false,
      bool isInfo = false}) {
    try {
      Color bgColor = Colors.grey;
      if (isSuccess) bgColor = TColors.primary;
      if (isWarning) bgColor = Colors.orange;
      if (isError) bgColor = Colors.red.shade600;
      if (isInfo) bgColor = TColors.info;

      Get.rawSnackbar(
        title: title,
        message: message,
        backgroundColor: bgColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Even fallback snackbar failed: $e');
    }
  }
}
