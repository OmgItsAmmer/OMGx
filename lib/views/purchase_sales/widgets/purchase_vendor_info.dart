import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/media/media_controller.dart';
import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/validators/validation.dart';
import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';

class PurchaseVendorInfo extends StatelessWidget {
  final String hintText;
  final List<String> namesList;
  final Function(String) onSelectedName;
  final TextEditingController userNameTextController;

  const PurchaseVendorInfo({
    super.key,
    required this.hintText,
    required this.namesList,
    required this.onSelectedName,
    required this.userNameTextController,
  });

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();
    final MediaController mediaController = Get.find<MediaController>();

    return Form(
      key: purchaseSalesController.vendorFormKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vendor Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TCircularIcon(
                  icon: Iconsax.refresh,
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  color: TColors.primary,
                  onPressed: () {
                    // Reset all vendor fields
                    userNameTextController.text = '';
                    purchaseSalesController.vendorPhoneNoController.value
                        .clear();
                    purchaseSalesController.vendorEmailController.value.clear();
                    purchaseSalesController.vendorAddressController.value
                        .clear();
                    purchaseSalesController.selectedAddressId = null;
                    purchaseSalesController.entityId.value = -1;
                    mediaController.displayImage.value = null;

                    // Force update text selection which triggers the controller listener
                    userNameTextController.selection =
                        TextSelection.fromPosition(
                            const TextPosition(offset: 0));

                    // Trigger callbacks
                    onSelectedName('');

                    // Set a very short delay to ensure UI updates
                    Future.microtask(() {
                      if (purchaseSalesController.vendorFormKey.currentState !=
                          null) {
                        purchaseSalesController.update();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final id = purchaseSalesController.entityId.value;
                    final image = mediaController.displayImage.value;

                    if (image != null) {
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          MediaCategory.shop.toString().split('.').last,
                          image.filename ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TShimmerEffect(
                                width: 120, height: 120);
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return const Icon(Icons.error);
                          } else {
                            return TRoundedImage(
                              isNetworkImage: true,
                              width: 120,
                              height: 120,
                              imageurl: snapshot.data!,
                            );
                          }
                        },
                      );
                    }

                    return FutureBuilder<String?>(
                      future: mediaController.fetchMainImage(
                        id,
                        MediaCategory.vendors.toString().split('.').last,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(
                              width: 120, height: 120);
                        } else if (snapshot.hasError ||
                            snapshot.data == null) {
                          return const TCircularIcon(
                            icon: Iconsax.image,
                            width: 120,
                            height: 120,
                            backgroundColor: TColors.primaryBackground,
                          );
                        } else {
                          return TRoundedImage(
                            isNetworkImage: true,
                            width: 120,
                            height: 120,
                            imageurl: snapshot.data!,
                          );
                        }
                      },
                    );
                  }),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: 300,
                    child: EnhancedAutocomplete<String>(
                      showOptionsOnFocus: true,
                      labelText: hintText,
                      hintText: 'Select a vendor',
                      options: namesList,
                      externalController: userNameTextController,
                      displayStringForOption: (String option) => option,
                      onSelected: onSelectedName,
                      validator: (value) =>
                          TValidator.validateEmptyText(hintText, value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
