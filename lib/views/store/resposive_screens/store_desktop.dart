import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/validators/validation.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/product/product_images_controller.dart';
import '../../../controllers/shop/shop_controller.dart';

class StoreDesktop extends StatelessWidget {
  const StoreDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return Expanded(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
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
              //BRead Crumbs

              const Row(
                children: [
                  //Image card
                  Expanded(child: StoreImageInfo()),
                  SizedBox(
                    width: TSizes.spaceBtwSections,
                  ),
                  //info card
                  Expanded(flex: 2, child: ProfileDetails()),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              //
            ],
          ),
        ),
      ),
    ));
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Heading
          Text(
            'Store Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //fields row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    controller: shopController.shopName.value,
                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Store Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Store Name'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          Wrap(
            spacing:
                TSizes.spaceBtwSections, // Horizontal space between children
            runSpacing: TSizes.spaceBtwItems, // Vertical space between lines
            children: [
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  controller: shopController.taxRate,
                  validator: (value) =>
                      TValidator.validateEmptyText('Tax Rate(%)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Tax Rate(%)'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  controller: shopController.shippingFee,
                  validator: (value) =>
                      TValidator.validateEmptyText('Shipping Fee(🚵)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration:
                      const InputDecoration(labelText: 'Shipping Fee(🚵)'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  controller: shopController.shippingThreshold,
                  validator: (value) => TValidator.validateEmptyText(
                      'Free Shipping Threshold(🚵)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                      labelText: 'Free Shipping Threshold(🚵)'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          //Prifles
          Wrap(
            spacing:
                TSizes.spaceBtwSections, // Horizontal space between children
            runSpacing: TSizes.spaceBtwItems, // Vertical space between lines
            children: [
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility
                child: TextFormField(
                  controller: shopController.profile1,
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 1', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 1'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  controller: shopController.profile2,
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 2', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 2'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context)
                    ? 250
                    : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  controller: shopController.profile3,
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 3', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 3'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          //save button
          Row(
            children: [
              Expanded(
                child: Obx(
              () => ElevatedButton(
                    onPressed: () {
                    shopController.updateStore();
                    },
                    child: shopController.isUpdating.value
                        ? const CircularProgressIndicator(color: TColors.white)
                        : Text(
                      'Update Store',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: TColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

class StoreImageInfo extends StatelessWidget {
  const StoreImageInfo({super.key});

  Future<String> _getImageUrl() async {
    final MediaController mediaController = Get.find<MediaController>();
    return await mediaController.getImageFromBucket(
          mediaController.allImages[0].mediaCategory,
          mediaController.allImages[0].filename,
        ) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final ProductImagesController productImagesController =
        Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      width: double.infinity,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment
                .bottomRight, // Align the camera icon to the bottom right
            children: [
              // Rounded Image
              Obx(
                () {
                  if (productImagesController.selectedImage.value == null) {
                    return const SizedBox(
                        height: 120, width: 100, child: Icon(Iconsax.image));
                  }
                  // Check if selectedImages is empty
                  return FutureBuilder<String?>(
                    future: mediaController.getImageFromBucket(
                      productImagesController
                              .selectedImage.value?.mediaCategory ??
                          '',
                      productImagesController.selectedImage.value?.filename ??
                          '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(
                            width: 350,
                            height: 170); // Show shimmer while loading
                      } else if (snapshot.hasError) {
                        return const Text(
                            'Error loading image'); // Handle error case
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 150,
                          height: 150,
                          imageurl: snapshot.data!,
                        );
                      } else {
                        return const Text(
                            'No image available'); // Handle case where no image is available
                      }
                    },
                  );
                },
              ),

              // Camera Icon
              TRoundedContainer(
                onTap: () {
                  productImagesController.selectThumbnailImage();
                },
                borderColor: TColors.white,
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.all(6), // Add padding around the icon
                child: const Icon(
                  Iconsax.camera, // Camera icon
                  size: 25, // Icon size
                  color: Colors.white, // Icon color
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Obx(
            () => Text(
              shopController.shopName.value.text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}
