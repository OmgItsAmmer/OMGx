import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_desktop.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_tablet.dart';
import 'package:admin_dashboard_v3/views/products/all_products/responsive_screens/all_product_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ProductController is initialized properly
    final controller = Get.find<ProductController>();

    // Reset controller state when navigating to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetState();
      controller.fetchProducts();
    });

    return const TSiteTemplate(
      desktop: AllProductDesktopScreen(),
      tablet: AllProductTabletScreen(),
      mobile: AllProductMobileScreen(),
    );
  }
}
