import 'package:ecommerce_dashboard/Models/image/image_entity_model.dart';
import 'package:ecommerce_dashboard/Models/image/image_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/repositories/media/media_repository.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../main.dart';

class ExtraImages extends StatelessWidget {
  const ExtraImages({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final ProductController productController = Get.find<ProductController>();
    final MediaRepository mediaRepository = Get.put(MediaRepository());

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Images',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Add Images Button
                  TCircularIcon(
                    onPressed: () async {
                      await _addMultipleImages(
                          context, mediaController, productController);
                    },
                    icon: Iconsax.add,
                    backgroundColor: TColors.primary,
                    color: TColors.white,
                  ),
                  const SizedBox(width: TSizes.sm),
                  // Refresh Button
                  TCircularIcon(
                    onPressed: () {
                      // Trigger refresh of product images
                      productController.update();
                    },
                    icon: Iconsax.refresh,
                    backgroundColor: TColors.primary.withValues(alpha: 0.1),
                    color: TColors.primary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Main Featured Image Preview
          _buildFeaturedImageSection(
              context, mediaController, productController),

          const SizedBox(height: TSizes.spaceBtwItems),

          // All Product Images Grid
          _buildAllImagesSection(
              context, mediaController, productController, mediaRepository),
        ],
      ),
    );
  }

  Widget _buildFeaturedImageSection(BuildContext context,
      MediaController mediaController, ProductController productController) {
    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Featured Image',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.sm),
          // Featured Image Display - Using Obx for reactive updates
          Obx(() {
            if (productController.isLoadingImages.value) {
              return const TShimmerEffect(width: 200, height: 150);
            }

            // First check for temporary featured image
            if (productController.temporaryImages.isNotEmpty &&
                productController.hasTemporaryFeaturedImage.value) {
              final featuredImage = productController.temporaryImages.first;
              return FutureBuilder<String?>(
                future: _getTemporaryImageUrl(featuredImage, mediaController),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const TShimmerEffect(width: 200, height: 150);
                  } else if (snapshot.hasError) {
                    return _buildErrorContainer();
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Stack(
                      children: [
                        TRoundedImage(
                          isNetworkImage: true,
                          width: 200,
                          height: 150,
                          imageurl: snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                        // Featured Badge
                        Positioned(
                          top: TSizes.xs,
                          left: TSizes.xs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.success,
                              borderRadius: BorderRadius.circular(TSizes.sm),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Temporary Badge
                        Positioned(
                          top: TSizes.xs,
                          right: TSizes.xs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.warning,
                              borderRadius: BorderRadius.circular(TSizes.sm),
                            ),
                            child: const Text(
                              'TEMP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildNoFeaturedImagePlaceholder();
                  }
                },
              );
            }

            // Then check for saved featured image
            final featuredImage = productController.getFeaturedImage();
            if (featuredImage != null) {
              return FutureBuilder<String?>(
                future: _getFeaturedImageUrl(featuredImage, mediaController),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const TShimmerEffect(width: 200, height: 150);
                  } else if (snapshot.hasError) {
                    return _buildErrorContainer();
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Stack(
                      children: [
                        TRoundedImage(
                          isNetworkImage: true,
                          width: 200,
                          height: 150,
                          imageurl: snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                        // Featured Badge
                        Positioned(
                          top: TSizes.xs,
                          left: TSizes.xs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.success,
                              borderRadius: BorderRadius.circular(TSizes.sm),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildNoFeaturedImagePlaceholder();
                  }
                },
              );
            } else {
              return _buildNoFeaturedImagePlaceholder();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: TColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(color: TColors.error),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 48, color: TColors.error),
          SizedBox(height: TSizes.xs),
          Text('Error loading image', style: TextStyle(color: TColors.error)),
        ],
      ),
    );
  }

  Widget _buildNoFeaturedImagePlaceholder() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(color: TColors.borderPrimary),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 48, color: TColors.darkGrey),
          SizedBox(height: TSizes.xs),
          Text('No Featured Image', style: TextStyle(color: TColors.darkGrey)),
          SizedBox(height: TSizes.xs),
          Text('Add images to set featured',
              style: TextStyle(color: TColors.darkGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Future<String?> _getTemporaryImageUrl(
      ImageModel image, MediaController mediaController) async {
    if (image.filename != null) {
      return await mediaController.mediaRepository.fetchImageFromBucket(
        image.filename!,
        MediaCategory.products.toString().split('.').last,
      );
    }
    return null;
  }

  Future<String?> _getFeaturedImageUrl(
      ImageEntityModel featuredImage, MediaController mediaController) async {
    final imageModel = await mediaController.mediaRepository
        .fetchImageFromImageTable(featuredImage.imageId ?? -1);
    if (imageModel.filename != null) {
      return await mediaController.mediaRepository.fetchImageFromBucket(
        imageModel.filename!,
        MediaCategory.products.toString().split('.').last,
      );
    }
    return null;
  }

  Widget _buildAllImagesSection(
      BuildContext context,
      MediaController mediaController,
      ProductController productController,
      MediaRepository mediaRepository) {
    return TRoundedContainer(
      backgroundColor: TColors.light,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Product Images',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.sm),
          // Images Grid - Using Obx for reactive updates
          Obx(() {
            if (productController.isLoadingImages.value) {
              return _buildImageGridShimmer();
            } else if (productController.productImages.isEmpty &&
                productController.temporaryImages.isEmpty) {
              return _buildEmptyImagesState();
            } else {
              return _buildImagesGrid(
                  context, productController, mediaController, mediaRepository);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildImageGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: TSizes.sm,
        mainAxisSpacing: TSizes.sm,
        childAspectRatio: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const TShimmerEffect(width: 100, height: 100);
      },
    );
  }

  Widget _buildEmptyImagesState() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border:
            Border.all(color: TColors.borderPrimary, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.gallery, size: 48, color: TColors.darkGrey),
            SizedBox(height: TSizes.xs),
            Text(
              'No additional images',
              style: TextStyle(color: TColors.darkGrey),
            ),
            Text(
              'Click "Add Images" to upload more',
              style: TextStyle(color: TColors.darkGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGrid(
      BuildContext context,
      ProductController productController,
      MediaController mediaController,
      MediaRepository mediaRepository) {
    // Combine saved and temporary images
    final allImages = <Widget>[];

    // Add saved images
    for (final imageEntity in productController.productImages) {
      allImages.add(_buildSavedImageCard(context, imageEntity, mediaController,
          productController, mediaRepository));
    }

    // Add temporary images
    for (int i = 0; i < productController.temporaryImages.length; i++) {
      final image = productController.temporaryImages[i];
      final isFeatured =
          i == 0 && productController.hasTemporaryFeaturedImage.value;
      allImages.add(_buildTemporaryImageCard(
          context, image, isFeatured, productController, mediaController));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: TSizes.sm,
        mainAxisSpacing: TSizes.sm,
        childAspectRatio: 1,
      ),
      itemCount: allImages.length,
      itemBuilder: (context, index) => allImages[index],
    );
  }

  Widget _buildSavedImageCard(
      BuildContext context,
      ImageEntityModel imageEntity,
      MediaController mediaController,
      ProductController productController,
      MediaRepository mediaRepository) {
    return FutureBuilder<ImageModel>(
      future:
          mediaRepository.fetchImageFromImageTable(imageEntity.imageId ?? -1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const TShimmerEffect(width: 100, height: 100);
        } else if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorImageCard();
        }

        final imageModel = snapshot.data!;
        return FutureBuilder<String?>(
          future: mediaRepository.fetchImageFromBucket(
            imageModel.filename ?? '',
            MediaCategory.products.toString().split('.').last,
          ),
          builder: (context, urlSnapshot) {
            if (urlSnapshot.connectionState == ConnectionState.waiting) {
              return const TShimmerEffect(width: 100, height: 100);
            } else if (urlSnapshot.hasError || !urlSnapshot.hasData) {
              return _buildErrorImageCard();
            }

            return Stack(
              children: [
                // Image
                TRoundedImage(
                  isNetworkImage: true,
                  width: 100,
                  height: 100,
                  imageurl: urlSnapshot.data!,
                  fit: BoxFit.cover,
                ),
                // Featured Badge
                if (imageEntity.isFeatured == true)
                  Positioned(
                    top: TSizes.xs,
                    left: TSizes.xs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.success,
                        borderRadius: BorderRadius.circular(TSizes.xs),
                      ),
                      child: const Text(
                        'MAIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Action Buttons
                Positioned(
                  top: TSizes.xs,
                  right: TSizes.xs,
                  child: Column(
                    children: [
                      // Set as Featured Button
                      if (imageEntity.isFeatured != true)
                        TCircularIcon(
                          icon: Iconsax.star,
                          size: TSizes.iconSm,
                          backgroundColor:
                              TColors.warning.withValues(alpha: 0.8),
                          color: Colors.white,
                          onPressed: () async {
                            await _setAsFeaturedImage(
                                imageEntity,
                                mediaController,
                                productController,
                                mediaRepository);
                          },
                        ),
                      const SizedBox(height: TSizes.xs),
                      // Delete Button
                      TCircularIcon(
                        icon: Iconsax.trash,
                        size: TSizes.iconSm,
                        backgroundColor: TColors.error.withValues(alpha: 0.8),
                        color: Colors.white,
                        onPressed: () async {
                          await _deleteImage(
                              context,
                              imageEntity,
                              mediaController,
                              productController,
                              mediaRepository);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTemporaryImageCard(
      BuildContext context,
      ImageModel image,
      bool isFeatured,
      ProductController productController,
      MediaController mediaController) {
    return FutureBuilder<String?>(
      future: _getTemporaryImageUrl(image, mediaController),
      builder: (context, urlSnapshot) {
        if (urlSnapshot.connectionState == ConnectionState.waiting) {
          return const TShimmerEffect(width: 100, height: 100);
        } else if (urlSnapshot.hasError || !urlSnapshot.hasData) {
          return _buildErrorImageCard();
        }

        return Stack(
          children: [
            // Image
            TRoundedImage(
              isNetworkImage: true,
              width: 100,
              height: 100,
              imageurl: urlSnapshot.data!,
              fit: BoxFit.cover,
            ),
            // Featured Badge
            if (isFeatured)
              Positioned(
                top: TSizes.xs,
                left: TSizes.xs,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.success,
                    borderRadius: BorderRadius.circular(TSizes.xs),
                  ),
                  child: const Text(
                    'MAIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Temporary Badge
            Positioned(
              top: TSizes.xs,
              right: TSizes.xs,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TColors.warning,
                  borderRadius: BorderRadius.circular(TSizes.xs),
                ),
                child: const Text(
                  'TEMP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Action Buttons
            Positioned(
              bottom: TSizes.xs,
              right: TSizes.xs,
              child: Column(
                children: [
                  // Set as Featured Button
                  if (!isFeatured)
                    TCircularIcon(
                      icon: Iconsax.star,
                      size: TSizes.iconSm,
                      backgroundColor: TColors.warning.withValues(alpha: 0.8),
                      color: Colors.white,
                      onPressed: () {
                        productController.setTemporaryImageAsFeatured(image);
                      },
                    ),
                  const SizedBox(height: TSizes.xs),
                  // Delete Button
                  TCircularIcon(
                    icon: Iconsax.trash,
                    size: TSizes.iconSm,
                    backgroundColor: TColors.error.withValues(alpha: 0.8),
                    color: Colors.white,
                    onPressed: () {
                      productController.removeTemporaryImage(image);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorImageCard() {
    return Container(
      decoration: BoxDecoration(
        color: TColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: TColors.error.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: TColors.error, size: 24),
            SizedBox(height: TSizes.xs),
            Text(
              'Failed to load',
              style: TextStyle(color: TColors.error, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMultipleImages(
      BuildContext context,
      MediaController mediaController,
      ProductController productController) async {
    try {
      await mediaController.selectImagesFromMedia(
        multipleSelection: true,
        allowSelection: true,
      );

      if (mediaController.selectedImages.isNotEmpty) {
        // Add selected images to temporary storage
        productController.addTemporaryImages(mediaController.selectedImages);

        TLoaders.successSnackBar(
          title: 'Success',
          message:
              '${mediaController.selectedImages.length} images added! Save to persist changes.',
        );

        // Clear selected images manually
        for (var image in mediaController.allImages) {
          image.isSelected.value = false;
        }
        mediaController.selectedImages.clear();
        mediaController.displayImage.value = null;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to add images: $e',
      );
    }
  }

  Future<void> _setAsFeaturedImage(
      ImageEntityModel imageEntity,
      MediaController mediaController,
      ProductController productController,
      MediaRepository mediaRepository) async {
    try {
      // Update the previous featured image to not be featured
      await supabase
          .from('image_entity')
          .update({'isFeatured': false})
          .eq('entity_id', productController.productId.value)
          .eq('entity_category',
              MediaCategory.products.toString().split('.').last)
          .eq('isFeatured', true);

      // Set this image as featured
      await supabase.from('image_entity').update({'isFeatured': true}).eq(
          'image_entity_id', imageEntity.imageEntityId);

      // Update reactive state
      productController.setImageAsFeatured(imageEntity.imageEntityId);

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Featured image updated successfully!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to set featured image: $e',
      );
    }
  }

  Future<void> _deleteImage(
      BuildContext context,
      ImageEntityModel imageEntity,
      MediaController mediaController,
      ProductController productController,
      MediaRepository mediaRepository) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: Text(
          imageEntity.isFeatured == true
              ? 'Are you sure you want to delete this featured image? You will need to set another image as featured.'
              : 'Are you sure you want to delete this image?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: TColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        // Delete the image-entity relationship
        await supabase
            .from('image_entity')
            .delete()
            .eq('image_entity_id', imageEntity.imageEntityId);

        // Remove from reactive state
        productController.removeProductImage(imageEntity.imageEntityId);

        TLoaders.successSnackBar(
          title: 'Success',
          message: 'Image deleted successfully!',
        );
      } catch (e) {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to delete image: $e',
        );
      }
    }
  }
}
