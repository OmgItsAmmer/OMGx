import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/responsive_screens/order_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/responsive_screens/order_detail_tablet.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/responsive_screens/order_detail_mobile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    return TSiteTemplate(
      desktop: OrderDetailDesktopScreen(orderModel: order),
      tablet: OrderDetailTabletScreen(orderModel: order),
      mobile: OrderDetailMobileScreen(orderModel: order),
    );
  }
}
