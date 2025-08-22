import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/basic_info.dart';
import '../widgets/extra_images.dart';
import '../widgets/product_brand&category.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_variants_widget.dart';
import '../widgets/thumbnail_info.dart';

class ProductDetailTablet extends StatelessWidget {
  const ProductDetailTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    // Use a separate method to initialize variants to make it cleaner
    _initializeVariantsIfNeeded(controller);

    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product info in a row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column with BasicInfo
                  Expanded(
                    flex: 3,
                    child: BasicInfo(),
                  ),
                  SizedBox(width: TSizes.spaceBtwItems),
                  // Right column with Thumbnail
                  Expanded(
                    flex: 2,
                    child: ExtraImages(),
                  ),
                ],
              ),

              SizedBox(height: TSizes.spaceBtwSections),

              // Brand & Category & visibility
              ProductBrandcCategory(),

              SizedBox(height: TSizes.spaceBtwSections),

              // Product Variants - All products now have variants
              ProductVariantsWidget(),

              SizedBox(height: TSizes.spaceBtwSections),

              // Extra Images
              ExtraImages(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailBottomBar(),
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
    // 2. We don't already have the variants loaded
    // 3. We're not already loading variants
    if (controller.productId.value > 0 &&
        controller.currentProductVariants.isEmpty &&
        !controller.isAddingVariants.value) {
      // Print debug information
      debugPrint('Loading variants for product ${controller.productId.value}');
      controller.fetchProductVariants(controller.productId.value);
    }
  }
}
