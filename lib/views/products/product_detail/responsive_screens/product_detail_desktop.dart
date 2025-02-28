import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import Material.dart for buttons and other Material Design widgets

import '../widgets/basic_info.dart';
import '../widgets/product_brand&category.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/thumbnail_info.dart';

class ProductDetailDesktop extends StatelessWidget {
  const ProductDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info
                      BasicInfo(),
                      SizedBox(height: TSizes.spaceBtwSections),
                      // Variation Info
                      // const VariationInfo(),
                    ],
                  ),
                ),
                SizedBox(width: TSizes.spaceBtwSections),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Upload
                      ThumbnailInfo(),

                      // Extra Images
                      // const SizedBox(height: TSizes.spaceBtwSections),
                      // const ExtraImages(),

                      // Brand & Category & visibility
                      SizedBox(height: TSizes.spaceBtwSections),
                      ProductBrandcCategory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ProductDetailBottomBar(),
      ),
    );
  }
}

