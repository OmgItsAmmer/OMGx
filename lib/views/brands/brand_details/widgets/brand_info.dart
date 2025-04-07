import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/brands/brand_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class BrandInfo extends StatelessWidget {
  const BrandInfo({super.key, required this.brandModel});
  final BrandModel brandModel;

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();
    final MediaController mediaController = Get.find<MediaController>();

    final bool isMobile = TDeviceUtils.isMobileScreen(context);

    return Form(
      key: brandController.brandDetail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Text(
            'Brand Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Brand name text field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: brandController.brandName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Brand Name', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          Stack(
            alignment: Alignment
                .bottomRight, // Align the camera icon to the bottom right
            children: [
              // Rounded Image
              Obx(() {
                final image = mediaController.displayImage.value;

                if (image != null) {
                  //print(image.filename);
                  return FutureBuilder<String?>(
                    future: mediaController.getImageFromBucket(
                      MediaCategory.brands.toString().split('.').last,
                      image.filename ?? '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(width: 80, height: 80);
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Icon(Icons.error);
                      } else {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 80,
                          height: 80,
                          imageurl: snapshot.data!,
                        );
                      }
                    },
                  );
                }

                // Fallback to future-based image if no image is selected
                return FutureBuilder<String?>(
                  future: mediaController.fetchMainImage(
                    brandController.selectedBrand.value.brandID ,
                    MediaCategory.brands.toString().split('.').last,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const TShimmerEffect(width: 80, height: 80);
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const TCircularIcon(icon: Iconsax.image,width: 80,height: 80,backgroundColor: TColors.primaryBackground,); // Handle case where no image is available

                    } else {
                      return TRoundedImage(
                        isNetworkImage: true,
                        width: 80,
                        height: 80,
                        imageurl: snapshot.data!,
                      );
                    }
                  },
                );
              }),


              // Camera Icon
              TRoundedContainer(
                onTap: () {
                  // productImagesController.selectThumbnailImage();
                  mediaController.selectImagesFromMedia();
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

          // Save button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save button press
                    brandController.saveOrUpdate(brandModel.brandID);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}