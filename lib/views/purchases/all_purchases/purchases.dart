import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/purchases/all_purchases/responsive_screens/purchase_desktop.dart';
import 'package:admin_dashboard_v3/views/purchases/all_purchases/responsive_screens/purchase_mobile.dart';
import 'package:admin_dashboard_v3/views/purchases/all_purchases/responsive_screens/purchase_tablet.dart';
import 'package:flutter/material.dart';

class TPurchaseScreen extends StatelessWidget {
  const TPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: PurchasesDesktopScreen(),
      tablet: PurchasesTabletScreen(),
      mobile: PurchasesMobileScreen(),
    );
  }
}
