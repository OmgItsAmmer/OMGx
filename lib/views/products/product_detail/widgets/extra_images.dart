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
                children: [
                  // Add Images Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _addMultipleImages(
                          context, mediaController, productController);
                    },
                    icon: const Icon(Iconsax.add),
                    label: const Text('Add Images'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  // Refresh Button
                  IconButton(
                    onPressed: () {
                      // Trigger refresh of product images
                      productController.update();
                    },
                    icon: const Icon(Iconsax.refresh),
                    tooltip: 'Refresh Images',
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
          // Featured Image Display
          FutureBuilder<String?>(
            future: mediaController.fetchMainImage(
              productController.productId.value,
              MediaCategory.products.toString().split('.').last,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const TShimmerEffect(width: 200, height: 150);
              } else if (snapshot.hasError || snapshot.data == null) {
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
                      Text('No Featured Image',
                          style: TextStyle(color: TColors.darkGrey)),
                    ],
                  ),
                );
              } else {
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
              }
            },
          ),
        ],
      ),
    );
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
          // Images Grid
          FutureBuilder<List<ImageEntityModel>>(
            future: _fetchAllProductImages(
              productController.productId.value,
              MediaCategory.products.toString().split('.').last,
              mediaRepository,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildImageGridShimmer();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading images: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyImagesState();
              } else {
                return _buildImagesGrid(context, snapshot.data!,
                    mediaController, productController, mediaRepository);
              }
            },
          ),
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
      List<ImageEntityModel> imageEntities,
      MediaController mediaController,
      ProductController productController,
      MediaRepository mediaRepository) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: TSizes.sm,
        mainAxisSpacing: TSizes.sm,
        childAspectRatio: 1,
      ),
      itemCount: imageEntities.length,
      itemBuilder: (context, index) {
        final imageEntity = imageEntities[index];
        return _buildImageCard(context, imageEntity, mediaController,
            productController, mediaRepository);
      },
    );
  }

  Widget _buildImageCard(
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
          return Container(
            decoration: BoxDecoration(
              color: TColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
            ),
            child: const Icon(Icons.error, color: TColors.error),
          );
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
              return Container(
                decoration: BoxDecoration(
                  color: TColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
                child: const Icon(Icons.error, color: TColors.error),
              );
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

  Future<List<ImageEntityModel>> _fetchAllProductImages(
      int productId, String entityType, MediaRepository mediaRepository) async {
    try {
      final response = await supabase
          .from('image_entity')
          .select('*')
          .eq('entity_id', productId)
          .eq('entity_category', entityType);

      return response
          .map<ImageEntityModel>((json) => ImageEntityModel.fromJson(json))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching product images: $e');
      }
      return [];
    }
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
        // Assign all selected images as non-featured
        await mediaController.imageAssigner(
          productController.productId.value,
          MediaCategory.products.toString().split('.').last,
          false, // Not featured
        );

        TLoaders.successSnackBar(
          title: 'Success',
          message:
              '${mediaController.selectedImages.length} images added successfully!',
        );

        // Trigger refresh
        productController.update();
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

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Featured image updated successfully!',
      );

      // Trigger refresh
      productController.update();
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

        TLoaders.successSnackBar(
          title: 'Success',
          message: 'Image deleted successfully!',
        );

        // Trigger refresh
        productController.update();
      } catch (e) {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to delete image: $e',
        );
      }
    }
  }
}
