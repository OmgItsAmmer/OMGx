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

    return Scaffold(
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
                    GetBuilder<ProductController>(
                      builder: (controller) {
                        final showVariants = controller.hasSerialNumbers.value;
                        return showVariants
                            ? const ProductSerialVariants()
                            : const SizedBox.shrink();
                      },
                    ),
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
    );
  }

  void _initializeVariantsIfNeeded(ProductController controller) {
    // Initialize variants only at the start - don't react to state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch variants once when the view is first built
      if (controller.productId.value > 0 &&
          controller.hasSerialNumbers.value &&
          !controller.isAddingVariants.value) {
        // Check if we're not already loading
        debugPrint('Initial fetch of variants');
        controller.fetchProductVariants(controller.productId.value);
      }
    });
  }
}
