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

    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: controller.isSerializedProduct.value &&
                  controller.selectedProductId.value > 0
              ? null
              : 0,
          child: controller.isSerializedProduct.value &&
                  controller.selectedProductId.value > 0
              ? Column(
                  key: const ValueKey('purchase_variant_manager'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TSectionHeading(
                      title: 'Purchase Product Variants',
                    ),
                    // const SizedBox(height: TSizes.spaceBtwItems),
                    // _buildBulkImportSection(context, controller),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddVariantForm(context, controller),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildVariantsSection(context, controller),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    _buildFinalizeSection(context, controller),
                  ],
                )
              : const SizedBox.shrink(),
        ));
  }

  Widget _buildEmptyVariantsView() {
    return const Padding(
      padding: EdgeInsets.all(TSizes.md),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
            SizedBox(height: TSizes.sm),
            Text(
              'No variants added for this purchase',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: TSizes.xs),
            Text(
              'Add serial numbers for the products you are purchasing',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Column(
        children: List.generate(
            3,
            (index) => const Padding(
                  padding: EdgeInsets.only(bottom: TSizes.sm),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                            TShimmerEffect(width: double.infinity, height: 16),
                      ),
                      SizedBox(width: TSizes.sm),
                      Expanded(
                        flex: 2,
                        child:
                            TShimmerEffect(width: double.infinity, height: 16),
                      ),
                      SizedBox(width: TSizes.sm),
                      Expanded(
                        flex: 2,
                        child:
                            TShimmerEffect(width: double.infinity, height: 16),
                      ),
                      SizedBox(width: TSizes.sm),
                      Expanded(
                        flex: 1,
                        child:
                            TShimmerEffect(width: 20, height: 20, radius: 10),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _buildVariantsSection(
      BuildContext context, PurchaseSalesController controller) {
    return TRoundedContainer(
      key: const ValueKey('purchase_variants_section'),
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Purchase Variants List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  controller.refreshPurchaseVariants();
                },
                tooltip: 'Refresh variants',
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),

          // Use Obx for reactive updates to the variants list
          Obx(() {
            // Show loading state
            if (controller.isLoadingPurchaseVariants.value) {
              return const Padding(
                padding: EdgeInsets.all(TSizes.md),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: TSizes.sm),
                      Text('Loading variants...'),
                    ],
                  ),
                ),
              );
            }

            // Show empty state or variants list
            final variantsLength = controller.purchaseVariants.length;
            if (variantsLength == 0) {
              return _buildEmptyVariantsView();
            }

            // Show variants list
            return Column(
              children: [
                // Header row
                _buildHeaderRow(),
                const Divider(),
                // Variant rows
                SizedBox(
                  height: variantsLength > 5
                      ? 300
                      : null, // Scrollable height when many items
                  child: ListView.builder(
                    shrinkWrap: variantsLength <= 5,
                    physics: variantsLength > 5
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: variantsLength,
                    itemBuilder: (context, index) {
                      final variant = controller.purchaseVariants[index];
                      return Column(
                        key: ValueKey(
                            'purchase_variant_${index}_${variant.serialNumber}'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildVariantRow(variant, controller, index),
                          if (index < variantsLength - 1) const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Serial Number',
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
    );
  }

  Widget _buildVariantRow(ProductVariantModel variant,
      PurchaseSalesController controller, int index) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            variant.serialNumber,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text('Rs ${variant.purchasePrice.toStringAsFixed(2)}'),
        ),
        Expanded(
          flex: 2,
          child: Text('Rs ${variant.sellingPrice.toStringAsFixed(2)}'),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () => _deletePurchaseVariant(controller, index),
            icon: const Icon(
              Icons.delete,
              color: TColors.error,
              size: 20,
            ),
            tooltip: 'Remove variant',
          ),
        ),
      ],
    );
  }

  Future<void> _deletePurchaseVariant(
      PurchaseSalesController controller, int index) async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Remove Variant'),
        content: const Text(
            'Are you sure you want to remove this variant from the purchase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      controller.removePurchaseVariant(index);
    }
  }

  Widget _buildAddVariantForm(
      BuildContext context, PurchaseSalesController controller) {
    // Create a local form key for this instance only
    final localFormKey = GlobalKey<FormState>();

    return Obx(() {
      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: localFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Purchase Variant',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  // Add reset button for stuck loading state
                  if (controller.isLoadingPurchaseVariants.value)
                    TextButton.icon(
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset'),
                      onPressed: () {
                        controller.isLoadingPurchaseVariants.value = false;
                      },
                    ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.purchaseVariantSerialNumber,
                      decoration: const InputDecoration(
                        labelText: 'Serial Number',
                        hintText: 'Enter serial number',
                      ),
                      enabled: !controller.isLoadingPurchaseVariants.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        // Check for duplicates in current purchase variants
                        final exists = controller.purchaseVariants.any((v) =>
                            v.serialNumber.toLowerCase() ==
                            value.toLowerCase());
                        if (exists) {
                          return 'Serial number already exists';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: controller.purchaseVariantPurchasePrice,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price',
                        hintText: 'Enter purchase price',
                        prefixText: 'Rs ',
                      ),
                      enabled: !controller.isLoadingPurchaseVariants.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be > 0';
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
                        hintText: 'Enter selling price',
                        prefixText: 'Rs ',
                      ),
                      enabled: !controller.isLoadingPurchaseVariants.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be > 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoadingPurchaseVariants.value
                          ? null
                          : () {
                              // Validate form
                              if (localFormKey.currentState?.validate() ??
                                  false) {
                                controller.addPurchaseVariant();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: TColors.white,
                      ),
                      child: controller.isLoadingPurchaseVariants.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Add Variant'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBulkImportSection(
      BuildContext context, PurchaseSalesController controller) {
    return Obx(() {
      final bool isLoading = controller.isLoadingPurchaseVariants.value;

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        backgroundColor: TColors.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bulk Import Purchase Variants',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (isLoading)
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset'),
                    onPressed: () {
                      controller.isLoadingPurchaseVariants.value = false;
                    },
                  ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            const Text(
              'Enter CSV data in the format: SerialNumber,PurchasePrice,SellingPrice (one per line)',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              controller: controller.purchaseVariantCsvData,
              enabled: !isLoading,
              decoration: const InputDecoration(
                hintText: 'SN123456,100.00,150.00\nSN123457,100.00,150.00',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed:
                      isLoading ? null : controller.parsePurchaseVariantCsv,
                  child: const Text('Parse CSV'),
                ),
                const SizedBox(width: TSizes.md),
                Obx(() => ElevatedButton(
                      onPressed:
                          controller.bulkPurchaseVariants.isEmpty || isLoading
                              ? null
                              : controller.bulkImportPurchaseVariants,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: TColors.white,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Import ${controller.bulkPurchaseVariants.length} Variants',
                            ),
                    )),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFinalizeSection(
      BuildContext context, PurchaseSalesController controller) {
    return Obx(() {
      final bool isLoading = controller.isLoadingFinalizePurchaseVariants.value;
      final int variantCount = controller.getPendingVariantsCount();
      final bool hasVariants = variantCount > 0;

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        backgroundColor: hasVariants
            ? TColors.primary.withValues(alpha: 0.05)
            : TColors.light,
        showBorder: hasVariants,
        borderColor: hasVariants
            ? TColors.primary.withValues(alpha: 0.3)
            : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      hasVariants
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: hasVariants ? TColors.primary : TColors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: TSizes.xs),
                    Text(
                      'Finalize Purchase Variants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hasVariants ? TColors.primary : TColors.darkGrey,
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              hasVariants
                  ? 'Ready to add $variantCount variant${variantCount == 1 ? '' : 's'} to purchase cart. Each variant will be added as a separate line item.'
                  : 'Add variants above, then finalize to add them all to the purchase cart as separate items.',
              style: TextStyle(
                fontSize: 12,
                color: hasVariants ? TColors.darkGrey : TColors.grey,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasVariants && !isLoading)
                  OutlinedButton.icon(
                    onPressed: () {
                      controller.clearPurchaseVariants();
                      TLoaders.successSnackBar(
                        title: 'Cleared',
                        message: 'All variants cleared from the list.',
                      );
                    },
                    icon: const Icon(
                      Icons.clear_all,
                      size: 16,
                      color: TColors.error,
                    ),
                    label: const Text(
                      'Clear All',
                      style: TextStyle(color: TColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TColors.error,
                      side: const BorderSide(color: TColors.error),
                    ),
                  ),
                if (hasVariants && !isLoading) const SizedBox(width: TSizes.sm),
                ElevatedButton.icon(
                  onPressed: !hasVariants || isLoading
                      ? null
                      : controller.finalizePurchaseVariants,
                  icon: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: TColors.white,
                          ),
                        ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      isLoading
                          ? 'Adding...'
                          : hasVariants
                              ? 'Add $variantCount to Cart'
                              : 'No Variants to Add',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasVariants ? TColors.primary : TColors.grey,
                    foregroundColor: TColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
