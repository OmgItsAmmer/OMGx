import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/shop/shop_controller.dart';
import '../../../utils/constants/enums.dart';

class StoreTablet extends StatelessWidget {
  const StoreTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            Text(
              'Store',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            //Layout for tablet - image and details side by side
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image card
                Expanded(flex: 1, child: StoreImageInfoTablet()),
                SizedBox(
                  width: TSizes.spaceBtwItems,
                ),
                //Store details
                Expanded(flex: 2, child: StoreDetailsTablet()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoreImageInfoTablet extends StatelessWidget {
  const StoreImageInfoTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaController = Get.find<MediaController>();
    final ShopController shopController = Get.find<ShopController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Store Image',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Image with Edit Button
          Center(
            child: Obx(() {
              final isLoading = mediaController.isLoading.value;
              final img = mediaController.displayImage.value;

              // Show shimmer effect during loading
              if (isLoading) {
                return const TShimmerEffect(
                  width: 180,
                  height: 180,
                  radius: 100,
                );
              }

              return Stack(
                children: [
                  // Show either the image or a placeholder
                  img != null
                      ? TRoundedImage(
                          imageurl: img.toString(),
                          width: 180,
                          height: 180,
                          border: Border.all(
                            color: TColors.primary,
                            width: 0.5,
                          ),
                          isNetworkImage: true,
                          borderRadius: 100,
                          fit: BoxFit.cover,
                          padding: const EdgeInsets.all(0),
                        )
                      : FutureBuilder<String?>(
                          future: mediaController.fetchMainImage(
                            shopController.selectedShop?.value.shopId ?? -1,
                            MediaCategory.shop.toString().split('.').last,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const TShimmerEffect(
                                  width: 180, height: 180, radius: 100);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return TRoundedImage(
                                imageurl: snapshot.data!,
                                width: 180,
                                height: 180,
                                border: Border.all(
                                  color: TColors.primary,
                                  width: 0.5,
                                ),
                                isNetworkImage: true,
                                borderRadius: 100,
                                fit: BoxFit.cover,
                                padding: const EdgeInsets.all(0),
                              );
                            } else {
                              return TRoundedImage(
                                imageurl: '',
                                width: 180,
                                height: 180,
                                border: Border.all(
                                  color: TColors.primary,
                                  width: 0.5,
                                ),
                                borderRadius: 100,
                                fit: BoxFit.cover,
                                padding: const EdgeInsets.all(0),
                                applyImageRadius: true,
                                backgroundColor: Colors.white,
                                isNetworkImage: false,
                              );
                            }
                          },
                        ),

                  // Edit Button Overlay
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: TCircularIcon(
                      icon: Iconsax.edit,
                      onPressed: () {
                        // Handle image upload
                        mediaController.selectImagesFromMedia();
                      },
                      backgroundColor: TColors.primary,
                      width: 40,
                      height: 40,
                      size: 20,
                      color: TColors.white,
                    ),
                  )
                ],
              );
            }),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Instructions
          const Text(
            'Upload your store logo or banner',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class StoreDetailsTablet extends StatelessWidget {
  const StoreDetailsTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'Store Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Store Name
          TextFormField(
            controller: shopController.shopName.value,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Store Name',
              hintText: 'Enter your store name',
              prefixIcon: Icon(Iconsax.shop),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Settings in a grid layout
          Wrap(
            spacing: TDeviceUtils.isTabletScreen(context)
                ? TSizes.spaceBtwSections
                : TSizes.spaceBtwItems,
            runSpacing: TSizes.spaceBtwItems,
            children: [
              // Tax Rate
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.taxRate,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Tax Rate(%)',
                    hintText: 'Enter the tax rate',
                    prefixIcon: Icon(Iconsax.receipt_1),
                  ),
                ),
              ),

              // Shipping Fee
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.shippingFee,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Shipping Fee(🚵)',
                    hintText: 'Enter the shipping fee',
                    prefixIcon: Icon(Iconsax.truck_fast),
                  ),
                ),
              ),

              // Free Shipping Threshold
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.shippingThreshold,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Free Shipping Threshold(🚵)',
                    hintText: 'Enter the free shipping threshold',
                    prefixIcon: Icon(Iconsax.truck_tick),
                  ),
                ),
              ),

              // Profile 1
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.profile1,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Profile 1',
                    hintText: 'Enter profile 1 details',
                    prefixIcon: Icon(Iconsax.profile_2user),
                  ),
                ),
              ),

              // Profile 2
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.profile2,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Profile 2',
                    hintText: 'Enter profile 2 details',
                    prefixIcon: Icon(Iconsax.profile_2user),
                  ),
                ),
              ),

              // Profile 3
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: shopController.profile3,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Profile 3',
                    hintText: 'Enter profile 3 details',
                    prefixIcon: Icon(Iconsax.profile_2user),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  // Save changes
                  shopController.updateStore();
                },
                child: shopController.isUpdating.value
                    ? const CircularProgressIndicator(color: TColors.white)
                    : const Text('Save Changes'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
