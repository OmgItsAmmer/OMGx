import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/tiles/user_advance_info_tile.dart';
import '../../../../controllers/address/address_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/orders/orders_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.customerModel});
  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    // final AddressController addressController = Get.find<AddressController>();
    final OrderController orderController = Get.find<OrderController>();
    final MediaController mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Customer Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          //pfp and name&email
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () {
                  final image = mediaController.displayImage.value;

                  if (image != null) {
                    return FutureBuilder<String?>(
                      future: mediaController.getImageFromBucket(
                        MediaCategory.customers.toString().split('.').last,
                        image.filename ?? '',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                  // Fetch main image from the bucket and show it
                  return FutureBuilder<String?>(
                    future: mediaController.fetchMainImage(
                      customerModel.customerId ?? -1,
                      MediaCategory.customers.toString().split('.').last,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(
                            width: 80,
                            height: 80); // Show shimmer while loading
                      } else if (snapshot.hasError) {
                        return const Text(
                            'Error loading image'); // Handle error case
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 80,
                          height: 80,
                          imageurl: snapshot.data!,
                        );
                      } else {
                        return const TCircularIcon(
                          icon: Iconsax.image,
                          width: 80,
                          height: 80,
                          backgroundColor: TColors.primaryBackground,
                        ); // Handle case where no image is available
                        // Handle case where no image is available
                      }
                    },
                  );
                },
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerModel.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 2,
                  ),
                  Text(
                    customerModel.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          TProfilemenu(
            title: "Name",
            value: customerModel.fullName,
            onPressed: () {},
            isTap: false,
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          TProfilemenu(
            title: "Phone Number",
            value: customerModel.phoneNumber,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          const Divider(),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: OUserAdvanceInfoTile(
                      firstTile: 'Last Order',
                      secondTile: (orderController.recentOrderDay == '0')
                          ? 'No Orders yet'
                          : orderController.recentOrderDay)),
              Expanded(
                  child: OUserAdvanceInfoTile(
                      firstTile: 'Average Order',
                      secondTile: (orderController.averageTotalAmount == '0.0')
                          ? 'No Orders yet'
                          : orderController.averageTotalAmount)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Registered At',
                  secondTile: customerModel.createdAt != null
                      ? DateFormat('dd MMM yyyy, hh:mm a')
                          .format(customerModel.createdAt!)
                      : 'N/A', // Fallback text if createdAt is null
                ),
              ),
              const Expanded(
                  child: OUserAdvanceInfoTile(
                      firstTile: 'Email Marketing',
                      secondTile: 'UnSubscribed')),
            ],
          ),
        ],
      ),
    );
  }
}
