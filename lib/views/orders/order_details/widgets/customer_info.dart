import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String fullName; // Passed directly
  final String email; // Passed directly
  final String phoneNumber; // Passed directly
  final bool isLoading;
  final bool showAddress; // Added parameter to control showing address

  const UserInfo({
    super.key,
    required this.title,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isLoading,
    this.showAddress = true, // Default: Show address
  });

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, // Dynamic Title
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              const Expanded(
                child: TRoundedImage(
                  width: 120,
                  height: 120,
                  imageurl: TImages.user,
                  padding: EdgeInsets.all(0),
                  isNetworkImage: false,
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName, // Using fullName directly
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Text(
                      email, // Using email directly
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Text(
                      phoneNumber, // Using phoneNumber directly
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),

                    // Conditionally Render Address
                    if (showAddress)
                      Obx(() {
                        if (addressController.isLoading.value) {
                          return const TShimmerEffect(width: 20, height: 10);
                        }

                        return Text(
                          addressController.allCustomerAddresses.isNotEmpty
                              ? addressController.allCustomerAddresses[0].location ?? 'No Address Found'
                              : 'No Address Found',
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
