import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/enums.dart';

class EntityThumbnailInfo<T> extends StatelessWidget {
  const EntityThumbnailInfo({
    super.key,
    required this.controller,
    required this.entityType,
  });

  final dynamic controller; // Use GetX controller
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
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
                  Obx(() {
                    final image = mediaController.displayImage.value;

                    if (image != null) {
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          _getMediaCategory().toString().split('.').last,
                          image.filename ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TShimmerEffect(
                                width: 150, height: 150);
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return const Icon(Icons.error);
                          } else {
                            return TRoundedImage(
                              isNetworkImage: true,
                              width: 150,
                              height: 150,
                              imageurl: snapshot.data!,
                            );
                          }
                        },
                      );
                    }
                    return FutureBuilder<String?>(
                      future: mediaController.fetchMainImage(
                        _getEntityId(controller),
                        _getMediaCategory().toString().split('.').last,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(width: 150, height: 150);
                        } else if (snapshot.hasError) {
                          return const Text('Error loading image');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return TRoundedImage(
                            isNetworkImage: true,
                            width: 150,
                            height: 150,
                            imageurl: snapshot.data!,
                          );
                        } else {
                          return const TCircularIcon(
                            icon: Iconsax.image,
                            width: 150,
                            height: 150,
                            backgroundColor: TColors.primaryBackground,
                          );
                        }
                      },
                    );
                  }),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  OutlinedButton(
                    onPressed: () {
                      mediaController.selectImagesFromMedia();
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

  MediaCategory _getMediaCategory() {
    switch (entityType) {
      case EntityType.customer:
        return MediaCategory.customers;
      case EntityType.salesman:
        return MediaCategory.salesman;
      case EntityType.vendor:
        return MediaCategory.shop;
      case EntityType.user:
        return MediaCategory.users;
    }
  }

  int _getEntityId(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.customerId ?? -1;
      case EntityType.salesman:
        return controller.salesmanId ?? -1;
      case EntityType.vendor:
        return controller.vendorId ?? -1;
      case EntityType.user:
        return -1;
    }
  }
}
