import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CollectionBottomBar extends StatelessWidget {
  const CollectionBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionController>();

    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard Button
          OutlinedButton.icon(
            onPressed: () {
              controller.clearForm();
              // Close any open snackbars before navigating back
              try {
                if (Get.isSnackbarOpen) {
                  Get.closeCurrentSnackbar();
                }
              } catch (e) {
                // Ignore snackbar errors when navigating
              }
              Get.back();
            },
            icon: const Icon(Iconsax.close_circle),
            label: const Text('Discard'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.lg,
                vertical: TSizes.md,
              ),
            ),
          ),
          const SizedBox(width: TSizes.sm),

          // Save Button
          Obx(() => ElevatedButton.icon(
                onPressed: controller.isUpdating.value
                    ? null
                    : () async {
                        if (controller.collectionId.value == -1) {
                          final newId = await controller.insertCollection();
                          if (newId != -1) {
                            // Stay on the page after creating to allow adding items
                            Get.snackbar(
                              'Success',
                              'Collection created! You can now add items.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          final success = await controller.updateCollection();
                          if (success) {
                            // Close any open snackbars before navigating back
                            try {
                              if (Get.isSnackbarOpen) {
                                Get.closeCurrentSnackbar();
                              }
                            } catch (e) {
                              // Ignore snackbar errors when navigating
                            }
                            Get.back();
                          }
                        }
                      },
                icon: controller.isUpdating.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Iconsax.tick_circle),
                label: Text(
                  controller.isUpdating.value
                      ? 'Saving...'
                      : (controller.collectionId.value == -1
                          ? 'Create Collection'
                          : 'Update Collection'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.lg,
                    vertical: TSizes.md,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
