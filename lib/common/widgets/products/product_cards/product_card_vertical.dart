
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../icons/t_circular_icon.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/brand_title_with_verification.dart';
import '../../texts/currency_text.dart';
import '../../texts/product_title_text.dart';
class TProductCardVertical extends StatelessWidget {
  final String title;
  final String brand;
  final String price;
  final String imageUrl;
  final double discount;
  final RxBool isFavorite; // Use RxBool for reactive state
  final bool isNetworkImage;
  final int product_id;
  final VoidCallback? WishListOnPressed;

  TProductCardVertical({
    Key? key,
    this.title = "Green Nike Air Shoes",
    this.brand = "Nike",
    this.price = "35.5",
    this.imageUrl = TImages.productImage78,
    this.discount = 25.0,
    RxBool? isFavorite, // Allow optional parameter
    this.isNetworkImage = false,
    this.product_id = 0,
    this.WishListOnPressed, // Temporary product ID
  })  : isFavorite = isFavorite ?? false.obs, // Default to false.obs
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(
          () => GestureDetector(
     //   onTap: () => Get.to(() => ProductDetailScreen(product_id: product_id)),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            boxShadow: [TshadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkerGrey : TColors.white,
          ),
          child: Column(
            children: [
              // Thumbnail and Wishlist
              TRoundedContainer(
                height: 180,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: dark ? TColors.dark : TColors.light,
                child: Stack(
                  children: [
                    // Product Image
                    TRoundedImage(
                      imageurl: imageUrl,
                      applyImageRadius: true,
                      isNetworkImage: isNetworkImage,
                      fit: BoxFit.fill,
                    ),

                    // Sale Tag
                    if (discount > 0)
                      Positioned(
                        top: 12,
                        child: TRoundedContainer(
                          radius: TSizes.sm,
                          backgroundColor: TColors.secondary.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm, vertical: TSizes.xs),
                          child: Text(
                            "${discount.toInt()}% OFF",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: TColors.black),
                          ),
                        ),
                      ),

                    // Favorite Icon Button
                    // Inside the Positioned widget for Favorite Icon Button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          isFavorite.value = !isFavorite.value; // Toggle the state
                          if (WishListOnPressed != null) {
                            WishListOnPressed!(); // Call the additional callback if provided
                          }
                        },
                        child: TCircularIcon(
                          icon: isFavorite.value ? Iconsax.heart5 : Iconsax.heart5,
                          color: isFavorite.value ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: TSizes.spaceBtwItems / 2),

              // Product Details
              Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TProductTitleText(
                      title: title,
                      smallSize: true,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TBrandTitleWithVerification(title: brand, isVerified: true,),
                  ],
                ),
              ),

              const Spacer(),

              // Pricing and Add-to-Cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.sm),
                    child: TProductPriceText(
                      price: price,
                    ),
                  ),
                  // Add to Cart
                  Container(
                    decoration: const BoxDecoration(
                      color: TColors.dark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(TSizes.cardRadiusMd),
                        bottomRight: Radius.circular(TSizes.productImageRadius),
                      ),
                    ),
                    child: SizedBox(
                      width: TSizes.iconLg * 1.2,
                      height: TSizes.iconLg * 1.2,
                      child: const Center(
                        child: Icon(
                          Iconsax.add,
                          color: TColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


