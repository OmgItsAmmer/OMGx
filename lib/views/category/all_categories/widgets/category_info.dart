import 'package:ecommerce_dashboard/Models/category/category_model.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class CategoryInfo extends StatelessWidget {
  const CategoryInfo({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();
    final MediaController mediaController = Get.find<MediaController>();

    final bool isMobile = TDeviceUtils.isMobileScreen(context);

    return Form(
      key: categoryController.categoryDetail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Text(
            'Category Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Brand name text field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: categoryController.categoryName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Category Name', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Image
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
                      MediaCategory.categories.toString().split('.').last,
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
                    categoryModel.categoryId ?? -1,
                    MediaCategory.categories.toString().split('.').last,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const TShimmerEffect(width: 80, height: 80);
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const TCircularIcon(
                        icon: Iconsax.image,
                        width: 80,
                        height: 80,
                        backgroundColor: TColors.primaryBackground,
                      ); // Handle case where no image is available
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
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (categoryModel.categoryId == null) {
                        categoryController.insertCategory();
                      } else {
                        categoryController
                            .updateCategory(categoryModel.categoryId!);
                      }
                    },
                    child: (categoryController.isUpdating.value)
                        ? const CircularProgressIndicator(color: TColors.white)
                        : Text(
                            (categoryModel.categoryId == null)
                                ? 'Save'
                                : 'Update',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: TColors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),

          // Discard button
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => categoryController.discardChanges(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TColors.error),
                  ),
                  child: Text(
                    'Discard',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.error),
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
