import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/purchase_sales/purchase_sales_controller.dart';
import 'Responsive_Screens/purchase_sales_desktop.dart';
import 'Responsive_Screens/purchase_sales_mobile.dart';
import 'Responsive_Screens/purchase_sales_tablet.dart';

class PurchaseSales extends StatefulWidget {
  const PurchaseSales({super.key});

  @override
  State<PurchaseSales> createState() => _PurchaseSalesState();
}

class _PurchaseSalesState extends State<PurchaseSales> {
  late PurchaseSalesController purchaseSalesController;

  @override
  void initState() {
    super.initState();
    purchaseSalesController = Get.find<PurchaseSalesController>();
  }

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: PurchaseSalesDesktop(),
      tablet: PurchaseSalesTablet(),
      mobile: PurchaseSalesMobile(),
    );
  }
}
