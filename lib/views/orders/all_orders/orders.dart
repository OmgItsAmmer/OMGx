import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/responsive_screens/order_desktop.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/responsive_screens/order_mobile.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/responsive_screens/order_tablet.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/table/order_table.dart';
import 'package:flutter/material.dart';

class TOrderScreen extends StatelessWidget {
  const TOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: OrdersDesktopScreen(),
      tablet: OrdersTabletScreen(),
      mobile: OrdersMobileScreen(),
    );
  }
}
