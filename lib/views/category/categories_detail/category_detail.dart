import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/category/categories_detail/reposnve_screens/category_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/category/categories_detail/reposnve_screens/category_detail_mobile.dart';
import 'package:admin_dashboard_v3/views/category/categories_detail/reposnve_screens/category_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = Get.arguments;

    return TSiteTemplate(
      useLayout: false,
      desktop: CategoryDetailDesktop(
        categoryModel: category,
      ),
      tablet: CategoryDetailTablet(
        categoryModel: category,
      ),
      mobile: CategoryDetailMobile(
        categoryModel: category,
      ),
    );
  }
}
