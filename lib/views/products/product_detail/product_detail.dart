import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/views/products/product_detail/responsive_screens/product_detail_desktop.dart';
import 'package:ecommerce_dashboard/views/products/product_detail/responsive_screens/product_detail_mobile.dart';
import 'package:ecommerce_dashboard/views/products/product_detail/responsive_screens/product_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FocusNode _screenFocusNode =
      FocusNode(debugLabel: 'ProductDetailScreen');

  @override
  void initState() {
    super.initState();

    // Initialize new product form if needed
    if (Get.arguments == null) {
      Get.find<ProductController>().cleanProductDetail();
    }

    // Refresh brand and category lists when screen loads
    // This ensures dropdowns show the most up-to-date data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshControllerData();
    });
  }

  @override
  void dispose() {
    _screenFocusNode.dispose();
    super.dispose();
  }

  // Refresh data in controllers
  void _refreshControllerData() {
    Get.find<BrandController>().fetchBrands();
    Get.find<CategoryController>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _screenFocusNode,
      autofocus: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
              const SaveIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const DiscardIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: CallbackAction<SaveIntent>(
              onInvoke: (_) => _handleSave(),
            ),
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (_) => _handleDiscard(),
            ),
          },
          child: const TSiteTemplate(
            useLayout: false,
            desktop: ProductDetailDesktop(),
            tablet: ProductDetailTablet(),
            mobile: ProductDetailMobile(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final productController = Get.find<ProductController>();
    if (productController.isUpdating.value) return;

    try {
      productController.isUpdating.value = true;
      // Your save logic here
      if (productController.productId.value == -1) {
        await productController.insertProduct();
      } else {
        await productController.updateProduct();
      }
      // Additional save logic as needed
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      productController.isUpdating.value = false;
    }
  }

  void _handleDiscard() {
    final productController = Get.find<ProductController>();
    if (productController.isUpdating.value) return;
    productController.cleanProductDetail();
    Navigator.of(context).pop();
  }
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class DiscardIntent extends Intent {
  const DiscardIntent();
}
