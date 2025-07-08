import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

class ProductVariantsWidget extends StatelessWidget {
  const ProductVariantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Variants',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddVariantDialog(context, controller),
                  icon: const Icon(Iconsax.add, color: Colors.white),
                  label: const Text('Add Variant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Variants List
          Obx(() {
            final allVariants = <ProductVariantModel>[];
            allVariants.addAll(controller.currentProductVariants);
            allVariants.addAll(controller.unsavedProductVariants);

            if (allVariants.isEmpty) {
              return _buildEmptyState(controller);
            }

            return Column(
              children: [
                // Variants Header
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: TColors.primaryBackground,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text('Variant Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text('SKU',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text('Buy Price',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text('Sell Price',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 1,
                          child: Text('Stock',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(
                          width: 60,
                          child: Text('Visible',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(
                          width: 100,
                          child: Text('Actions',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.xs),

                // Variants List
                ...allVariants
                    .map((variant) =>
                        _buildVariantItem(context, controller, variant))
                    .toList(),
              ],
            );
          }),

          // Total Stock Summary
          const SizedBox(height: TSizes.spaceBtwItems),
          Obx(() {
            final totalStock = controller.currentProductVariants
                    .fold<int>(0, (sum, variant) => sum + variant.stock) +
                controller.unsavedProductVariants
                    .fold<int>(0, (sum, variant) => sum + variant.stock);
            return Container(
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: TColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border:
                    Border.all(color: TColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Stock:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$totalStock units',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: TColors.success)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ProductController controller) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: TColors.primaryBackground,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(color: TColors.borderPrimary),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.box, size: 48, color: TColors.darkGrey),
            SizedBox(height: TSizes.sm),
            Text(
              'No Variants Added',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: TSizes.xs),
            Text(
              'Add your first variant to get started',
              style: TextStyle(color: TColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantItem(BuildContext context, ProductController controller,
      ProductVariantModel variant) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.xs),
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: TColors.borderPrimary),
      ),
      child: Row(
        children: [
          // Variant Name
          Expanded(
            flex: 2,
            child: Text(
              variant.variantName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          // SKU
          Expanded(
            flex: 1,
            child: Text(variant.sku),
          ),
          // Buy Price
          Expanded(
            flex: 1,
            child: Text('Rs ${variant.buyPrice.toStringAsFixed(2)}'),
          ),
          // Sell Price
          Expanded(
            flex: 1,
            child: Text('Rs ${variant.sellPrice.toStringAsFixed(2)}'),
          ),
          // Stock
          Expanded(
            flex: 1,
            child: Text('${variant.stock}'),
          ),
          // Visible
          SizedBox(
            width: 60,
            child: Center(
              child: Icon(
                variant.isVisible ? Iconsax.eye : Iconsax.eye_slash,
                color: variant.isVisible ? TColors.success : TColors.darkGrey,
                size: 18,
              ),
            ),
          ),
          // Actions
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () =>
                      _showEditVariantDialog(context, controller, variant),
                  icon: const Icon(Iconsax.edit, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: TColors.primary.withValues(alpha: 0.1),
                    foregroundColor: TColors.primary,
                  ),
                ),
                const SizedBox(width: TSizes.xs),
                IconButton(
                  onPressed: () =>
                      _showDeleteVariantDialog(context, controller, variant),
                  icon: const Icon(Iconsax.trash, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: TColors.error.withValues(alpha: 0.1),
                    foregroundColor: TColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVariantDialog(
      BuildContext context, ProductController controller) {
    _showVariantDialog(context, controller, null);
  }

  void _showEditVariantDialog(BuildContext context,
      ProductController controller, ProductVariantModel variant) {
    _showVariantDialog(context, controller, variant);
  }

  void _showVariantDialog(BuildContext context, ProductController controller,
      ProductVariantModel? variant) {
    final isEditing = variant != null;
    final formKey = GlobalKey<FormState>();

    // Controllers for form fields
    final variantNameController =
        TextEditingController(text: variant?.variantName ?? '');
    final skuController = TextEditingController(text: variant?.sku ?? '');
    final buyPriceController =
        TextEditingController(text: variant?.buyPrice.toString() ?? '');
    final sellPriceController =
        TextEditingController(text: variant?.sellPrice.toString() ?? '');
    final stockController =
        TextEditingController(text: variant?.stock.toString() ?? '0');
    final isVisibleNotifier = ValueNotifier<bool>(variant?.isVisible ?? true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Variant' : 'Add New Variant'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Variant Name
                TextFormField(
                  controller: variantNameController,
                  decoration: const InputDecoration(
                    labelText: 'Variant Name *',
                    hintText: 'e.g., Red Large, Blue Medium',
                    prefixIcon: Icon(Iconsax.tag),
                  ),
                  validator: (value) =>
                      TValidator.validateEmptyText('Variant Name', value),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // SKU
                TextFormField(
                  controller: skuController,
                  decoration: InputDecoration(
                    labelText: 'SKU *',
                    hintText:
                        isEditing ? variant!.sku : 'Auto-generated if empty',
                    prefixIcon: const Icon(Iconsax.barcode),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Will be auto-generated
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Buy Price and Sell Price
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: buyPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Buy Price *',
                          hintText: '0.00',
                          prefixIcon: Icon(Iconsax.money_send),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Buy price is required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter valid price';
                          }
                          if (double.parse(value) < 0) {
                            return 'Price cannot be negative';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: sellPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Sell Price *',
                          hintText: '0.00',
                          prefixIcon: Icon(Iconsax.money_recive),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Sell price is required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter valid price';
                          }
                          if (double.parse(value) < 0) {
                            return 'Price cannot be negative';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Stock (Read-only for new, editable for existing)
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    hintText: '0',
                    prefixIcon: Icon(Iconsax.box),
                    helperText: 'Current stock quantity',
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true, // not yet implemented use !isEditing
                  validator: (value) {
                    if (isEditing && value != null && value.isNotEmpty) {
                      if (int.tryParse(value) == null) {
                        return 'Enter valid stock quantity';
                      }
                      if (int.parse(value) < 0) {
                        return 'Stock cannot be negative';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

                // Visibility Toggle
                ValueListenableBuilder<bool>(
                  valueListenable: isVisibleNotifier,
                  builder: (context, isVisible, child) {
                    return SwitchListTile(
                      title: const Text('Visible to Customers'),
                      subtitle: Text(isVisible
                          ? 'This variant is visible'
                          : 'This variant is hidden'),
                      value: isVisible,
                      onChanged: (value) => isVisibleNotifier.value = value,
                      activeColor: TColors.primary,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Auto-generate SKU if empty
                String sku = skuController.text.trim();
                if (sku.isEmpty) {
                  sku = _generateSku(variantNameController.text.trim());
                }

                // Check for duplicate SKU
                if (!isEditing || sku != variant.sku) {
                  final isDuplicate =
                      await controller.productVariantsRepository.isSkuExists(
                    sku,
                    controller.productId.value,
                    excludeVariantId: variant?.variantId,
                  );

                  if (isDuplicate) {
                    TLoaders.errorSnackBar(
                      title: 'Duplicate SKU',
                      message:
                          'This SKU already exists. Please use a different SKU.',
                    );
                    return;
                  }
                }

                final newVariant = ProductVariantModel(
                  variantId: variant?.variantId,
                  productId: controller.productId.value,
                  variantName: variantNameController.text.trim(),
                  sku: sku,
                  buyPrice: double.parse(buyPriceController.text.trim()),
                  sellPrice: double.parse(sellPriceController.text.trim()),
                  stock: isEditing ? int.parse(stockController.text.trim()) : 0,
                  isVisible: isVisibleNotifier.value,
                );

                if (isEditing) {
                  // For editing, we'll add to unsaved list and handle save later
                  controller.addVariantToUnsaved(newVariant);
                } else {
                  // For new variants, add to unsaved list
                  controller.addVariantToUnsaved(newVariant);
                }

                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteVariantDialog(BuildContext context,
      ProductController controller, ProductVariantModel variant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Variant'),
        content: Text(
            'Are you sure you want to delete the variant "${variant.variantName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (variant.variantId != null) {
                await controller.deleteVariant(variant.variantId!);
              } else {
                controller.deleteUnsavedVariant(variant.variantName);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _generateSku(String variantName) {
    // Generate a simple SKU based on variant name and UUID
    final uuid = const Uuid();
    final shortUuid = uuid.v4().substring(0, 8).toUpperCase();
    final cleanName =
        variantName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    final prefix = cleanName.isNotEmpty
        ? cleanName.substring(0, cleanName.length > 3 ? 3 : cleanName.length)
        : 'VAR';
    return '$prefix-$shortUuid';
  }
}
