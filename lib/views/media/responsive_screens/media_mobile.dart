import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/media/widgets/media_uploader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/media/media_controller.dart';
import '../widgets/media_content.dart';

class MediaMobileScreen extends StatelessWidget {
  const MediaMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Media',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Upload button for mobile - full width
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  mediaController.showImagesUploaderSection.value =
                      !mediaController.showImagesUploaderSection.value;
                },
                label: const Text('Upload Images'),
                icon: const Icon(Iconsax.cloud_add, color: TColors.white),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Upload Area with smaller height on mobile
            MediaUploader(),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Media content with optimized layout for mobile
            MediaContent(
              allowMultipleSelection: false,
              allowSelection: false,
              onSelectedImage: (val) {
                mediaController.selectedImages.value = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
