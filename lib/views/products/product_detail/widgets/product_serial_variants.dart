import 'package:admin_dashboard_v3/Models/products/product_variant_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/texts/section_heading.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSerialVariants extends StatelessWidget {
  const ProductSerialVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Column(
      key: const ValueKey('product_serial_variants'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TSectionHeading(
          title: 'Product Variants with Serial Numbers',
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildSerialVariantsSection(context, controller),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildAddVariantForm(context, controller),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildBulkImportSection(context, controller),
      ],
    );
  }

  Widget _buildSerialVariantsSection(
      BuildContext context, ProductController controller) {
    return TRoundedContainer(
      key: ValueKey(
          'variants_section_${controller.currentProductVariants.length}'),
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Serial Number Variants',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Add a refresh button
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  if (!controller.isAddingVariants.value &&
                      controller.productId.value > 0) {
                    controller.fetchProductVariants(controller.productId.value);
                  }
                },
                tooltip: 'Refresh variants',
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),

          // Use Obx but with minimal dependencies
          Obx(() {
            // First, check loading state
            if (controller.isAddingVariants.value) {
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

            // Check for empty variants - using length is more efficient than isEmpty
            final variantsLength = controller.currentProductVariants.length;
            if (variantsLength == 0) {
              return const Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Center(
                  child: Text('No variants added yet'),
                ),
              );
            }

            return Column(
              children: [
                // Header row
                _buildHeaderRow(),
                const Divider(),
                // Variant rows with optimized ListView
                SizedBox(
                  height: variantsLength > 5
                      ? 300
                      : null, // Scrollable height when many items
                  child: ListView.builder(
                    // No controller needed for simple scrolling
                    shrinkWrap: variantsLength <= 5,
                    physics: variantsLength > 5
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: variantsLength,
                    itemBuilder: (context, index) {
                      // Access the item directly each time to avoid list copying
                      final variant = controller.currentProductVariants[index];
                      return Column(
                        key: ValueKey('variant_${variant.variantId ?? index}'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildVariantRow(variant, controller),
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
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(), // For the delete button
          ),
        ],
      ),
    );
  }

  Widget _buildVariantRow(
      ProductVariantModel variant, ProductController controller) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(variant.serialNumber),
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
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm, vertical: TSizes.xs),
            decoration: BoxDecoration(
              color: variant.isSold ? TColors.warning : TColors.success,
              borderRadius: BorderRadius.circular(TSizes.sm),
            ),
            child: Text(
              variant.isSold ? 'Sold' : 'Available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: !variant.isSold && variant.variantId != null
                ? () => _deleteVariant(variant.variantId!, controller)
                : null, // Disable delete for sold variants
            icon: Icon(
              Icons.delete,
              color: !variant.isSold ? TColors.error : Colors.grey,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteVariant(
      int variantId, ProductController controller) async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this variant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      controller.deleteVariant(variantId);
    }
  }

  Widget _buildAddVariantForm(
      BuildContext context, ProductController controller) {
    // Create a local form key for this instance only
    final localFormKey = GlobalKey<FormState>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: localFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Variant',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.serialNumber,
                    decoration: const InputDecoration(
                      labelText: 'Serial Number',
                      hintText: 'Enter serial number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.purchasePrice,
                    decoration: const InputDecoration(
                      labelText: 'Buy Price',
                      hintText: 'Enter purchase price',
                      prefixText: '₹Rs',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.variantSellingPrice,
                    decoration: const InputDecoration(
                      labelText: 'Sell Price',
                      hintText: 'Enter selling price',
                      prefixText: 'Rs',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isAddingVariants.value
                        ? null
                        : () {
                            // Validate using our local form instead of the controller's form
                            if (localFormKey.currentState?.validate() ??
                                false) {
                              // Call add variant directly - it will check the fields
                              controller.addVariant();
                            }
                          },
                    child: Obx(() => controller.isAddingVariants.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBulkImportSection(
      BuildContext context, ProductController controller) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bulk Import Variants',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: TSizes.sm),
          const Text(
            'Enter CSV data in the format: SerialNumber,PurchasePrice,SellingPrice (one per line)',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller: controller.csvData,
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
                onPressed: controller.parseCsvData,
                child: const Text('Parse CSV'),
              ),
              const SizedBox(width: TSizes.md),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.bulkImportVariants.isEmpty ||
                          controller.isAddingVariants.value
                      ? null
                      : controller.bulkImportVariantsToProduct,
                  child: controller.isAddingVariants.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Import ${controller.bulkImportVariants.length} Variants',
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
