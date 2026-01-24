import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/enums.dart';

class CustomerThumbnailInfo extends StatelessWidget {
  const CustomerThumbnailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final CustomerController customerController =
        Get.find<CustomerController>();

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
                      final image = mediaController.displayImage.value;

                      if (image != null) {
                        //print(image.filename);
                        return FutureBuilder<String?>(
                          future: mediaController.getImageFromBucket(
                            MediaCategory.customers.toString().split('.').last,
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
                      // Check if selectedImages is empty
                      return FutureBuilder<String?>(
                        future: mediaController.fetchMainImage(
                            customerController.customerId,
                            MediaCategory.customers.toString().split('.').last),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TShimmerEffect(
                                width: 150,
                                height: 150); // Show shimmer while loading
                          } else if (snapshot.hasError) {
                            return const Text(
                                'Error loading image'); // Handle error case
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
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
                            ); // Handle case where no image is available
// Handle case where no image is available
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
                      // Trigger the selection of a thumbnail image
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
}
