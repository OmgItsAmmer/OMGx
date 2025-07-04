import 'package:ecommerce_dashboard/Models/salesman/salesman_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/tiles/user_advance_info_tile.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/orders/orders_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class SalesmanInfo extends StatelessWidget {
  const SalesmanInfo({super.key, required this.salesmanModel});
  final SalesmanModel salesmanModel;

  @override
  Widget build(BuildContext context) {
    // final AddressController addressController = Get.find<AddressController>();
    final OrderController orderController = Get.find<OrderController>();
    // final ProductImagesController productImagesController = Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Salesman Information',
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
                    //print(image.filename);
                    return FutureBuilder<String?>(
                      future: mediaController.getImageFromBucket(
                        MediaCategory.salesman.toString().split('.').last,
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
                  // Check if selectedImages is empty
                  return FutureBuilder<String?>(
                    future: mediaController.fetchMainImage(
                        salesmanModel.salesmanId ?? -1,
                        MediaCategory.salesman.toString().split('.').last),
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
                    salesmanModel.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 2,
                  ),
                  Text(
                    salesmanModel.email,
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
            value: salesmanModel.fullName,
            onPressed: () {},
            isTap: false,
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          TProfilemenu(
            title: "Phone Number",
            value: salesmanModel.phoneNumber,
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
                      firstTile: 'Commission',
                      secondTile: (salesmanModel.comission != null)
                          ? salesmanModel.comission.toString()
                          : '0%')),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Registered At',
                  secondTile: salesmanModel.createdAt != null
                      ? DateFormat('dd MMM yyyy, hh:mm a')
                          .format(salesmanModel.createdAt!)
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
