import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/views/orders/all_orders/responsive_screens/order_desktop.dart';
import 'package:ecommerce_dashboard/views/orders/all_orders/responsive_screens/order_mobile.dart';
import 'package:ecommerce_dashboard/views/orders/all_orders/responsive_screens/order_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TOrderScreen extends StatefulWidget {
  const TOrderScreen({super.key});

  @override
  State<TOrderScreen> createState() => _TOrderScreenState();
}

class _TOrderScreenState extends State<TOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: OrdersDesktopScreen(),
      tablet: OrdersTabletScreen(),
      mobile: OrdersMobileScreen(),
    );
  }
}
