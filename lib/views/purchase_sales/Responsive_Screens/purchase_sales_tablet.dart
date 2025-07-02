import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import 'purchase_sales_desktop.dart';

class PurchaseSalesTablet extends GetView<PurchaseSalesController> {
  const PurchaseSalesTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, use the desktop layout with some adjustments
    return const PurchaseSalesDesktop();
  }
}
