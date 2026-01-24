import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/widgets/collection_basic_info.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/widgets/collection_bottom_bar.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/widgets/collection_image_uploader.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/widgets/collection_items_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CollectionDetailDesktop extends StatelessWidget {
  const CollectionDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.collectionId.value == -1
                  ? 'Add New Collection'
                  : 'Edit Collection',
            )),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
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
        ),
      ),
      body: Form(
        key: controller.collectionForm,
        child: const Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Basic Info and Image
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          CollectionBasicInfo(),
                          SizedBox(height: TSizes.spaceBtwSections),
                          CollectionImageUploader(),
                        ],
                      ),
                    ),
                    SizedBox(width: TSizes.spaceBtwSections),

                    // Right Column - Collection Items
                    Expanded(
                      flex: 3,
                      child: CollectionItemsManager(),
                    ),
                  ],
                ),
              ),
            ),
            CollectionBottomBar(),
          ],
        ),
      ),
    );
  }
}
