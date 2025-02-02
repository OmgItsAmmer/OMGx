import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/brands/brand_details/responsive_screens/brand_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/customer/customer_detail/responsive_screens/customer_detail_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandDetailScreen extends StatelessWidget {
  const BrandDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Get.arguments;
    return  TSiteTemplate(
      desktop: BrandDetailDesktop(brandModel: brand,),
    );
  }
}
