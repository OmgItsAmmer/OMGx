import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CollectionItemsManager extends StatelessWidget {
  const CollectionItemsManager({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollectionController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collection Items',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (controller.collectionId.value != -1)
                ElevatedButton.icon(
                  onPressed: () => _showAddItemDialog(context, controller),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Add Item'),
                ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Items List
          Obx(() {
            if (controller.collectionId.value == -1) {
              return Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.info_circle, color: TColors.grey),
                    SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                        'Save the collection first to add items',
                        style: TextStyle(color: TColors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.isLoadingItems.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(TSizes.md),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.collectionItems.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                child: const Center(
                  child: Text(
                    'No items added yet',
                    style: TextStyle(color: TColors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.collectionItems.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: TSizes.sm),
              itemBuilder: (context, index) {
                final item = controller.collectionItems[index];
                return _buildItemCard(context, controller, item);
              },
            );
          }),

          // Total Price
          if (controller.collectionId.value != -1)
            Obx(() {
              final total = controller.calculateTotalPrice();
              return Container(
                margin: const EdgeInsets.only(top: TSizes.md),
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Collection Price:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Rs. ${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge!.apply(
                            color: TColors.primary,
                            fontWeightDelta: 2,
                          ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, CollectionController controller,
      dynamic item) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: TColors.primary.withOpacity(0.1),
          child: const Icon(Iconsax.box, color: TColors.primary),
        ),
        title: Text(item.productName ?? 'Unknown Product'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Variant: ${item.variantName ?? 'N/A'}'),
            Text('Price: Rs. ${item.sellPrice ?? 0}'),
            Text('Stock: ${item.stock ?? 0}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity controls
            IconButton(
              icon: const Icon(Iconsax.minus),
              onPressed: item.defaultQuantity > 1
                  ? () {
                      controller.updateCollectionItemQuantity(
                        item.collectionItemId,
                        item.defaultQuantity - 1,
                      );
                    }
                  : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: TColors.grey),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: Text(
                '${item.defaultQuantity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.add),
              onPressed: () {
                controller.updateCollectionItemQuantity(
                  item.collectionItemId,
                  item.defaultQuantity + 1,
                );
              },
            ),
            // Delete button
            IconButton(
              icon: const Icon(Iconsax.trash, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(context, controller, item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, CollectionController controller) {
    int? selectedVariantId;
    int quantity = 1;
    final quantityController = TextEditingController(text: '1');

    Get.defaultDialog(
      title: 'Add Item to Collection',
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Variant Dropdown
              Obx(() {
                if (controller.isLoadingVariants.value) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Product Variant',
                    prefixIcon: Icon(Iconsax.box),
                  ),
                  items: controller.availableVariants.map((variant) {
                  final productName = variant['products']['name'];
                  final variantName = variant['variant_name'];
                  final price = variant['sell_price'];
                  final stock = variant['stock'];

                  return DropdownMenuItem<int>(
                    value: variant['variant_id'],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$productName - $variantName',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(
                          'Price: Rs. $price | Stock: $stock',
                          style: const TextStyle(
                            fontSize: 12,
                            color: TColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedVariantId = value;
                },
              );
              }),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Quantity Input
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Default Quantity',
                  prefixIcon: Icon(Iconsax.math),
                ),
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (selectedVariantId != null && quantity > 0) {
          Get.back();
          await controller.addCollectionItem(
            variantId: selectedVariantId!,
            defaultQuantity: quantity,
          );
        }
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, CollectionController controller, dynamic item) {
    Get.defaultDialog(
      title: 'Remove Item',
      middleText: 'Are you sure you want to remove "${item.productName}" from this collection?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await controller.removeCollectionItem(item.collectionItemId);
      },
    );
  }
}
