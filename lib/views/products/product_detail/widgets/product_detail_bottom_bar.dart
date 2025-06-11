import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/tloaders.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: TDeviceUtils.isDesktopScreen(context) ? 4 : 0,
              child: const SizedBox()),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: productController.isUpdating.value
                    ? null
                    : () {
                        // Handle Discard action
                        productController.cleanProductDetail();
                        Navigator.of(context).pop();
                      },
                child: const Text('Discard'),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: productController.isUpdating.value
                      ? null
                      : () async {
                          try {
                            // Set updating flag to prevent multiple clicks
                            productController.isUpdating.value = true;

                            // Check if adding new product or updating existing one
                            if (productController.productId.value == -1) {
                              debugPrint('Saving new product...');

                              // Insert new product
                              await productController.insertProduct();

                              // Verify product was saved
                              if (productController.productId.value <= 0) {
                                debugPrint(
                                    'Product was not saved correctly, productId is invalid');
                                throw Exception(
                                    'Failed to save product - invalid ID returned');
                              }

                              debugPrint(
                                  '✓ New product saved with ID: ${productController.productId.value}');

                              // If it's a serialized product with no variants, prompt user to add them
                              if (productController.hasSerialNumbers.value &&
                                  productController
                                      .currentProductVariants.isEmpty) {
                                TLoaders.successSnackBar(
                                  title: "Product Created",
                                  message:
                                      "Now add serial number variants for this product",
                                );
                                productController.isUpdating.value = false;
                                return; // Don't close the screen
                              }
                            } else {
                              debugPrint(
                                  'Updating existing product ${productController.productId.value}...');

                              // Update existing product
                              await productController.updateProduct();
                              debugPrint('✓ Product updated successfully');
                            }

                            // Save any unsaved variants to database
                            if (productController.hasSerialNumbers.value &&
                                productController
                                    .unsavedProductVariants.isNotEmpty) {
                              debugPrint(
                                  'Saving ${productController.unsavedProductVariants.length} variants for product ${productController.productId.value}...');
                              await productController.saveUnsavedVariants();
                            }

                            // Refresh product list to ensure all UI components have the latest data
                            debugPrint('Refreshing products list...');
                            await productController.refreshProducts();
                            debugPrint('✓ Products list refreshed');

                            // Navigate back if everything is complete
                            if (!productController.hasSerialNumbers.value ||
                                !productController
                                    .currentProductVariants.isEmpty) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            debugPrint('❌ ERROR in save/update: $e');
                            TLoaders.errorSnackBar(
                              title: "Error",
                              message: e.toString(),
                            );
                          } finally {
                            // Always reset the updating flag
                            productController.isUpdating.value = false;
                          }
                        },
                  child: productController.isUpdating.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: TColors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          productController.productId.value == -1
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
          ),
        ],
      ),
    );
  }
}
