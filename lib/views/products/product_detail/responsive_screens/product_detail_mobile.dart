import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/basic_info.dart';
import '../widgets/product_brand&category.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_serial_variants.dart';
import '../widgets/thumbnail_info.dart';

class ProductDetailMobile extends StatelessWidget {
  const ProductDetailMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // All elements stacked vertically for mobile
              // Thumbnail first
              const ThumbnailInfo(),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Basic Info
              const BasicInfo(),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Brand & Category & visibility
              const ProductBrandcCategory(),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Serial Variants - Only show for products with serial numbers
              const ProductVariantsWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProductDetailBottomBar(),
    );
  }
}
