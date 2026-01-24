import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CollectionImageUploader extends StatelessWidget {
  const CollectionImageUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionController>();
    final mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () {
                final image = mediaController.displayImage.value;

                if (image != null) {
                  // Show newly selected image from media library
                  return FutureBuilder<String?>(
                    future: mediaController.getImageFromBucket(
                      MediaCategory.collections.toString().split('.').last,
                      image.filename ?? '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(width: 350, height: 170);
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Icon(Icons.error);
                      } else {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 350,
                          height: 170,
                          imageurl: snapshot.data!,
                        );
                      }
                    },
                  );
                }
                // Check if collection has an existing image
                return FutureBuilder<String?>(
                  future: mediaController.fetchMainImage(
                    controller.collectionId.value,
                    MediaCategory.collections.toString().split('.').last,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const TShimmerEffect(
                        width: 350,
                        height: 170,
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading image');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return TRoundedImage(
                        isNetworkImage: true,
                        width: 350,
                        height: 170,
                        imageurl: snapshot.data!,
                      );
                    } else {
                      return const TCircularIcon(
                        icon: Iconsax.image,
                        width: 80,
                        height: 80,
                        backgroundColor: TColors.primaryBackground,
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            OutlinedButton(
              onPressed: () {
                // Trigger the selection of a thumbnail image from media library
                mediaController.selectImagesFromMedia();
              },
              child: Text(
                'Add Thumbnail',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              'Recommended: 800x800px or larger, JPG/PNG format',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
