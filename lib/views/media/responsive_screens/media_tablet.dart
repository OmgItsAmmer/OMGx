import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/media/widgets/media_uploader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/media/media_controller.dart';
import '../widgets/media_content.dart';

class MediaTabletScreen extends StatelessWidget {
  const MediaTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with upload button in a row for tablet
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Media',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  width: 200, // Slightly wider button for tablet
                  child: ElevatedButton.icon(
                    onPressed: () {
                      mediaController.showImagesUploaderSection.value =
                          !mediaController.showImagesUploaderSection.value;
                    },
                    label: const Text('Upload Images'),
                    icon: const Icon(Iconsax.cloud_add, color: TColors.white),
                  ),
                )
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Upload Area - using the existing widget
            MediaUploader(),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Media content - optimized for tablet layout
            MediaContent(
              allowMultipleSelection: false,
              allowSelection: false,
              onSelectedImage: (val) {
                //  mediaController.selectedImages.value = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
