import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Responsive_Screens/sales_desktop.dart';
import 'Responsive_Screens/sales_mobile.dart';
import 'Responsive_Screens/sales_tablet.dart';

// Create a custom snackbar helper for the Sales screen
class SalesSnackbars {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get scaffoldKey => _scaffoldKey;

  static void successSnackBar(
      {required String title, String message = '', int duration = 3}) {
    _scaffoldKey.currentState?.hideCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (message.isNotEmpty)
              Text(message, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void errorSnackBar({required String title, String message = ''}) {
    _scaffoldKey.currentState?.hideCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (message.isNotEmpty)
              Text(message, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void warningSnackBar({required String title, String message = ''}) {
    _scaffoldKey.currentState?.hideCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (message.isNotEmpty)
              Text(message, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: SalesSnackbars.scaffoldKey,
      child: const TSiteTemplate(
        desktop: SalesDesktop(),
        tablet: SalesTablet(),
        mobile: SalesMobile(),
      ),
    );
  }
}
