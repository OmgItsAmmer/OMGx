import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/category/all_categories/responsive_screens/category_desktop.dart';
import 'package:ecommerce_dashboard/views/category/all_categories/responsive_screens/category_tablet.dart';
import 'package:ecommerce_dashboard/views/category/all_categories/responsive_screens/category_mobile.dart';
import 'package:flutter/material.dart';

class AllCategoryScreen extends StatelessWidget {
  const AllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AllCategoryDesktopScreen(),
      tablet: CategoryTablet(),
      mobile: CategoryMobile(),
    );
  }
}
