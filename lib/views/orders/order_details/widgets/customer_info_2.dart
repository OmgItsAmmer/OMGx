import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/address/address_model.dart';
import '../../../../Models/orders/order_item_model.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../../utils/constants/enums.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({
    super.key,
    required this.mediaCategory,
    required this.title,
    required this.showAddress,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isLoading,
    required this.order,
  });

  final MediaCategory mediaCategory;
  final String title;
  final bool showAddress;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isLoading;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final AddressController addressController = Get.find<AddressController>();
    // final CustomerController customerController =
    //     Get.find<CustomerController>();
    // final SalesmanController salesmanController =
    //     Get.find<SalesmanController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Loading state
          if (isLoading)
            const Column(
              children: [
                TShimmerEffect(width: double.infinity, height: 80),
                SizedBox(height: TSizes.spaceBtwItems),
                TShimmerEffect(width: double.infinity, height: 60),
                SizedBox(height: TSizes.spaceBtwItems),
                TShimmerEffect(width: double.infinity, height: 60),
              ],
            )
          else
            Column(
              children: [
                // User Image and Basic Info
                Row(
                  children: [
                    // Profile Image
                    FutureBuilder<String?>(
                      future: fullName != 'Not Found'
                          ? mediaController.fetchMainImage(
                              order.customerId ?? 0,
                              mediaCategory.toString().split('.').last,
                            )
                          : Future.value(null),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(
                              width: 60, height: 60, radius: 50);
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data == null) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: TColors.primaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.user,
                              size: 30,
                              color: TColors.primary,
                            ),
                          );
                        } else {
                          return TRoundedImage(
                            isNetworkImage: true,
                            width: 60,
                            height: 60,
                            imageurl: snapshot.data!,
                            borderRadius: 50,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),

                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.call,
                                size: 16,
                                color: TColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  phoneNumber,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.sms,
                                size: 16,
                                color: TColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  email,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Address section
                if (showAddress) ...[
                  order.shippingMethod == 'pickup'
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            const SizedBox(height: TSizes.spaceBtwSections),
                            const Divider(),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Iconsax.location,
                                  size: 20,
                                  color: TColors.primary,
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Shipping Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      //name , location and phone number

                                      Obx(() {
                                        if (addressController.isLoading.value) {
                                          return const TShimmerEffect(
                                              width: double.infinity,
                                              height: 40);
                                        } else if (addressController
                                                .selectedOrderAddress.value ==
                                            AddressModel.empty()) {
                                          return Text(
                                            'No address found',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          );
                                        } else {
                                          final address = addressController
                                              .selectedOrderAddress.value;
                                          return Column(
                                            children: [
                                              Text(
                                                //prefix icon

                                                address.fullName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                  height: TSizes.spaceBtwItems),
                                              Text(
                                                address.location,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                  height: TSizes.spaceBtwItems),
                                              Text(
                                                address.phoneNumber ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
