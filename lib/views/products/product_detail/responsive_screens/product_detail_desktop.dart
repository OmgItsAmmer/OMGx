import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/basic_info.dart';
import '../widgets/product_brand&category.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_serial_variants.dart';
import '../widgets/thumbnail_info.dart';

class ProductDetailDesktop extends StatelessWidget {
  const ProductDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    // Use a separate method to initialize variants to make it cleaner
    _initializeVariantsIfNeeded(controller);

    return Expanded(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info
                      const BasicInfo(),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Serial Variants - Only show for products with serial numbers
                      Obx(() {
                        final showVariants = controller.hasSerialNumbers.value;

                        // When switching to variants mode, try to refresh variants
                        if (showVariants &&
                            controller.currentProductVariants.isEmpty &&
                            controller.productId.value > 0) {
                          _loadVariants(controller);
                        }

                        return showVariants
                            ? const ProductSerialVariants()
                            : const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwSections),
                const Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Upload
                      ThumbnailInfo(),
                      SizedBox(height: TSizes.spaceBtwSections),
                      // Brand & Category & visibility
                      ProductBrandcCategory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const ProductDetailBottomBar(),
      ),
    );
  }

  void _initializeVariantsIfNeeded(ProductController controller) {
    // Initialize variants when needed - use GetX lifecycle callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVariants(controller);
    });
  }

  void _loadVariants(ProductController controller) {
    // Only load if:
    // 1. We have a valid product ID
    // 2. The product has serial numbers
    // 3. We don't already have the variants loaded
    // 4. We're not already loading variants
    if (controller.productId.value > 0 &&
        controller.hasSerialNumbers.value &&
        controller.currentProductVariants.isEmpty &&
        !controller.isAddingVariants.value) {
      // Print debug information
      debugPrint('Loading variants for product ${controller.productId.value}');
      controller.fetchProductVariants(controller.productId.value);
    }
  }
}
