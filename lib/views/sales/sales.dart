import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:flutter/material.dart';

import 'Responsive_Screens/sales_desktop.dart';
import 'Responsive_Screens/sales_mobile.dart';
import 'Responsive_Screens/sales_tablet.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: SalesDesktop(),
      tablet: SalesTablet(),
      mobile: SalesMobile(),
    );
  }
}
