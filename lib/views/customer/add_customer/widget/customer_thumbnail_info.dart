import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';

class CustomerThumbnailInfo extends StatelessWidget {
  const CustomerThumbnailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductImagesController productImagesController = Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    return Row(
      children: [
        Expanded(
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TRoundedContainer(
              backgroundColor: TColors.primaryBackground,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                        () {
                      if(productImagesController.selectedImage.value == null){
                        return const SizedBox(
                            height: 120,
                            width: 100,
                            child: Icon(Iconsax.image));
                      }
                      // Check if selectedImages is empty
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          productImagesController.selectedImage.value?.mediaCategory ?? '',
                          productImagesController.selectedImage.value?.filename ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const TShimmerEffect(width: 350, height: 170); // Show shimmer while loading
                          } else if (snapshot.hasError) {
                            return const Text('Error loading image'); // Handle error case
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return TRoundedImage(
                              isNetworkImage: true,
                              width: 350,
                              height: 170,
                              imageurl: snapshot.data!,
                            );
                          } else {
                            return const Text('No image available'); // Handle case where no image is available
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  OutlinedButton(
                    onPressed: () {
                      // Trigger the selection of a thumbnail image
                      productImagesController.selectThumbnailImage();
                    },
                    child: Text(
                      'Add Thumbnail',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}