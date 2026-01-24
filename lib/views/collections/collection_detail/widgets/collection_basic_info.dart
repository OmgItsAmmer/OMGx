import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CollectionBasicInfo extends StatelessWidget {
  const CollectionBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Collection Name
          TextFormField(
            controller: controller.collectionName,
            validator: (value) => TValidator.validateEmptyText('Collection Name', value),
            decoration: const InputDecoration(
              labelText: 'Collection Name *',
              hintText: 'e.g., Premium Starter Pack',
              prefixIcon: Icon(Icons.collections_bookmark),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Description
          TextFormField(
            controller: controller.collectionDescription,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter collection description',
              prefixIcon: Icon(Icons.description),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Display Order
          TextFormField(
            controller: controller.displayOrder,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => TValidator.validateEmptyText('Display Order', value),
            decoration: const InputDecoration(
              labelText: 'Display Order *',
              hintText: 'e.g., 1',
              prefixIcon: Icon(Icons.sort),
              helperText: 'Lower numbers appear first',
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Status Toggles
          Obx(() => Column(
                children: [
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Collection visible to customers'),
                    value: controller.isActive.value,
                    onChanged: (value) {
                      controller.isActive.value = value;
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Featured'),
                    subtitle: const Text('Show in hero section'),
                    value: controller.isFeatured.value,
                    onChanged: (value) {
                      controller.isFeatured.value = value;
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Premium'),
                    subtitle: const Text('Display as premium collection (only one allowed)'),
                    value: controller.isPremium.value,
                    onChanged: (value) {
                      controller.isPremium.value = value;
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
