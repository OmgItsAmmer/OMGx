import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ExtraImages extends StatelessWidget {
  const ExtraImages({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TRoundedImage(
              width: 350, height: 170, imageurl: TImages.productImage1),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 80, // Set an appropriate height for the ListView
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: TSizes.spaceBtwInputFields / 2),
                    itemCount: 10, // Ensure this has enough items to scroll
                    itemBuilder: (_, index) {
                      return const TRoundedContainer(
                        backgroundColor: TColors.primaryBackground,
                        width: 100,
                        height: 100, // Fixed dimensions for each item
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwSections),
              const TRoundedImage(
                  width: 50, height: 50, imageurl: TImages.productImage1),
            ],
          ),
        ],
      ),
    );
  }
}
