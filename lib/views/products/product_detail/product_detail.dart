import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_mobile.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Controllers
  final ProductController productController = Get.find<ProductController>();
  final BrandController brandController = Get.find<BrandController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();

    // Initialize new product form if needed
    if (Get.arguments == null) {
      productController.cleanProductDetail();
    }

    // Refresh brand and category lists when screen loads
    // This ensures dropdowns show the most up-to-date data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshControllerData();
    });
  }

  // Refresh data in controllers
  void _refreshControllerData() {
    brandController.fetchBrands();
    categoryController.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ProductDetailDesktop(),
      tablet: ProductDetailTablet(),
      mobile: ProductDetailMobile(),
    );
  }
}
