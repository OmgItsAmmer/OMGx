import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/responsive_screens/order_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/customer_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/oorder_transaction.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../products/add_product_form.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    return   TSiteTemplate(
      desktop: OrderDetailDesktopScreen(orderModel: order,) ,
    );
  }
}
