import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/responsive-screens/brand_desktop.dart';
import 'package:admin_dashboard_v3/views/category/all_categories/responsive_screens/category_desktop.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_desktop.dart';
import 'package:flutter/material.dart';

class AllCategoryScreen extends StatelessWidget {
  const AllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AllCategoryDesktopScreen(),
    );
  }
}
