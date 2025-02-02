import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/responsive-screens/brand_desktop.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_desktop.dart';
import 'package:flutter/material.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AllBrandsDesktopScreen(),
    );
  }
}
