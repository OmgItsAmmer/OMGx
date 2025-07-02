import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import 'purchase_sales_desktop.dart';

class PurchaseSalesMobile extends GetView<PurchaseSalesController> {
  const PurchaseSalesMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, use the desktop layout - can be customized later for mobile
    return const PurchaseSalesDesktop();
  }
}
