import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseVariantManager extends StatelessWidget {
  const PurchaseVariantManager({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseSalesController>();

    return Obx(() {
      // Only show when a product is selected
      if (controller.selectedProductId.value == -1) {
        return const SizedBox.shrink();
      }

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TSectionHeading(
              title: 'Variant Management',
              // subtitle:
              //     'Add variants for different configurations, sizes, or colors',
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

            // Show form for adding variants (simplified for new system)
                    _buildAddVariantForm(context, controller),
                    const SizedBox(height: TSizes.spaceBtwItems),

            // Show current variants in purchase
            _buildVariantsList(context, controller),
          ],
        ),
      );
    });
  }

  Widget _buildAddVariantForm(
      BuildContext context, PurchaseSalesController controller) {
    return ExpansionTile(
      title: Row(
        children: [
          const Icon(Icons.add_circle_outline, color: TColors.primary),
          const SizedBox(width: TSizes.sm),
          const Text(
            'Add Product Variant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Obx(() => controller.hasUnsavedVariants()
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm, vertical: TSizes.xs),
                  decoration: BoxDecoration(
                    color: TColors.warning,
                    borderRadius: BorderRadius.circular(TSizes.xs),
                  ),
                  child: Text(
                    '${controller.getPendingVariantsCount()} pending',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Variant Name Input
              TextFormField(
                controller: controller.purchaseVariantSerialNumber,
                decoration: const InputDecoration(
                  labelText: 'Variant Name',
                  hintText: 'e.g., Large, Blue, 1L, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Variant name is required';
                  }

                  // Check for duplicates in current purchase variants
                  final exists = controller.purchaseVariants.any((v) =>
                      v.variantName.toLowerCase() == value.toLowerCase());
                  if (exists) {
                    return 'Variant name already exists';
                  }

                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Purchase and Selling Price Row
              Row(
          children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.purchaseVariantPurchasePrice,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price',
                        hintText: '0.00',
                        border: OutlineInputBorder(),
                        prefixText: 'Rs ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Purchase price is required';
                        }
                        final price = double.tryParse(value.trim());
                        if (price == null || price < 0) {
                          return 'Enter valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: controller.purchaseVariantSellingPrice,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price',
                        hintText: '0.00',
                        border: OutlineInputBorder(),
                        prefixText: 'Rs ',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Selling price is required';
                        }
                        final price = double.tryParse(value.trim());
                        if (price == null || price < 0) {
                          return 'Enter valid price';
                        }
                        return null;
                      },
              ),
            ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoadingPurchaseVariants.value
                          ? null
                          : () => controller.addPurchaseVariant(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: controller.isLoadingPurchaseVariants.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Add Variant'),
                    )),
            ),
          ],
        ),
      ),
      ],
    );
  }

  Widget _buildVariantsList(
      BuildContext context, PurchaseSalesController controller) {
    return Obx(() {
      if (controller.purchaseVariants.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: TColors.light,
            borderRadius: BorderRadius.circular(TSizes.md),
            border: Border.all(color: TColors.grey.withValues(alpha: 0.3)),
          ),
          child: Center(
      child: Column(
                    children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: TColors.grey.withValues(alpha: 0.6),
                      ),
                const SizedBox(height: TSizes.sm),
                Text(
                  'No variants added yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: TColors.grey,
                      ),
                      ),
                const SizedBox(height: TSizes.xs),
                Text(
                  'Add variants for different sizes, colors, or configurations',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TColors.grey,
                      ),
                      ),
                    ],
                  ),
      ),
    );
  }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Purchase Variants (${controller.purchaseVariants.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => controller.clearPurchaseVariants(),
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      foregroundColor: TColors.error,
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  Obx(() => ElevatedButton.icon(
                        onPressed: controller
                                    .isLoadingFinalizePurchaseVariants.value ||
                                controller.purchaseVariants.isEmpty
                            ? null
                            : () => controller.finalizePurchaseVariants(),
                        icon: controller.isLoadingFinalizePurchaseVariants.value
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle, size: 16),
                        label: const Text('Finalize'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.success,
                          foregroundColor: Colors.white,
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),

          // Variants table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: TColors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(TSizes.sm),
            ),
                  child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: const BoxDecoration(
                    color: TColors.light,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TSizes.sm),
                      topRight: Radius.circular(TSizes.sm),
                    ),
                  ),
                  child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
                          'Variant Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Purchase Price',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Selling Price',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
                ),

                // Table rows
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.purchaseVariants.length,
                  itemBuilder: (context, index) {
                    final variant = controller.purchaseVariants[index];
                    return Column(
                      key: ValueKey(
                          'purchase_variant_${index}_${variant.variantName}'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildVariantRow(variant, controller, index),
                        if (index < controller.purchaseVariants.length - 1)
                          Divider(
                            height: 1,
                            color: TColors.grey.withValues(alpha: 0.3),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVariantRow(ProductVariantModel variant,
      PurchaseSalesController controller, int index) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
              variant.variantName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const Expanded(
          flex: 2,
            child: Text('Purchase: Rs 0.00'), // Will show from batch info
        ),
        const Expanded(
          flex: 2,
            child: Text('Selling: Rs 0.00'), // Will show from batch info
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () => controller.removePurchaseVariant(index),
              icon: const Icon(Icons.delete, color: TColors.error, size: 18),
            tooltip: 'Remove variant',
          ),
          ),
        ],
      ),
    );
  }
}
