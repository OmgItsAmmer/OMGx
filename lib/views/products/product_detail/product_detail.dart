import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_mobile.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize or find ProductController before building the screen
    // Using fenix:true ensures it's recreated if it was previously deleted
    final controller = Get.find<ProductController>();

    // Clean state for new product form
    if (Get.arguments == null) {
      controller.cleanProductDetail();
    }

    return const TSiteTemplate(
      desktop: ProductDetailDesktop(),
      tablet: ProductDetailTablet(),
      mobile: ProductDetailMobile(),
    );
  }
}
