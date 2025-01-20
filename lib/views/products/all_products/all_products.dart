import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_desktop.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AllProductDesktopScreen(),
    );
  }
}
