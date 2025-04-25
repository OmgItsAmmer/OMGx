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
                            if (productController.productId.value == -1) {
                              await productController.insertProduct();
                              if (productController.productId.value != -1 &&
                                  productController.hasSerialNumbers.value &&
                                  productController
                                      .currentProductVariants.isEmpty) {
                                // Product is created but needs variants
                                TLoader.successSnackBar(
                                  title: "Product Created",
                                  message:
                                      "Now add serial number variants for this product",
                                );
                                return; // Don't close the screen
                              }
                            } else {
                              await productController.updateProduct();
                            }

                            // Refresh product list to ensure all UI components have the latest data
                            await productController.refreshProducts();

                            if (!productController.hasSerialNumbers.value ||
                                !productController
                                    .currentProductVariants.isEmpty) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            TLoader.errorSnackBar(
                              title: "Error",
                              message: e.toString(),
                            );
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
