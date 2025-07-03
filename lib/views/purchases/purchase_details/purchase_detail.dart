import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/responsive_screens/purchase_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/responsive_screens/purchase_detail_tablet.dart';
import 'package:admin_dashboard_v3/views/purchases/purchase_details/responsive_screens/purchase_detail_mobile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseDetailScreen extends StatelessWidget {
  const PurchaseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purchase = Get.arguments;
    return TSiteTemplate(
      desktop: PurchaseDetailDesktopScreen(purchaseModel: purchase),
      tablet: PurchaseDetailTabletScreen(purchaseModel: purchase),
      mobile: PurchaseDetailMobileScreen(purchaseModel: purchase),
    );
  }
}
