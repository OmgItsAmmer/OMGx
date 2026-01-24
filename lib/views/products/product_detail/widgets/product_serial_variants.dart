import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductVariantsWidget extends StatelessWidget {
  const ProductVariantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    debugPrint('ProductVariantsWidget.build called');

    return Column(
      key: const ValueKey('product_variants_widget'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TSectionHeading(
          title: 'Product Variants',
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildAddVariantForm(context, controller),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildVariantsListSection(context, controller),
      ],
    );
  }

  Widget _buildAddVariantForm(
      BuildContext context, ProductController controller) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.variantForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Product Variant',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (controller.isLoadingAddProductVariant.value)
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset'),
                    onPressed: () {
                      controller.isLoadingAddProductVariant.value = false;
                    },
                  ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: controller.variantNameController,
                    decoration: const InputDecoration(
                      labelText: 'Variant Name',
                      hintText: 'e.g., 1L, 1.5L, Red, Blue',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Variant name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: controller.variantSkuController,
                    decoration: const InputDecoration(
                      labelText: 'SKU (Optional)',
                      hintText: 'e.g., PEP-1L',
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                Obx(() => SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: controller.isLoadingAddProductVariant.value
                            ? null
                            : () => controller.addProductVariant(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: TColors.white,
                        ),
                        child: controller.isLoadingAddProductVariant.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Add'),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantsListSection(
      BuildContext context, ProductController controller) {
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
                'Product Variants',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  debugPrint('Refresh variants button pressed');
                  if (controller.productId.value > 0) {
                    controller.fetchProductVariants(controller.productId.value);
                  }
                },
                tooltip: 'Refresh variants',
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Obx(() {
            debugPrint(
                'Rebuilding variants list, count=${controller.productVariants.length}');

            // Show loading state
            if (controller.isLoadingVariants.value) {
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

            // Show empty state
            if (controller.productVariants.isEmpty) {
              return _buildEmptyVariantsView();
            }

            // Show variants list
            return Column(
              children: [
                // Header row
                _buildHeaderRow(),
                const Divider(),
                // Variants list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.productVariants.length,
                  itemBuilder: (context, index) {
                    final variant = controller.productVariants[index];
                    return Column(
                      key: ValueKey('variant_${variant.variantId}'),
                      children: [
                        _buildVariantRow(variant, controller),
                        if (index < controller.productVariants.length - 1)
                          const Divider(),
                      ],
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyVariantsView() {
    return const Padding(
      padding: EdgeInsets.all(TSizes.md),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.category_outlined, size: 40, color: Colors.grey),
            SizedBox(height: TSizes.sm),
            Text(
              'No variants found for this product',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: TSizes.xs),
            Text(
              'Add variants like different sizes, colors, or configurations',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
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
              'Variant Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'SKU',
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
            child: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantRow(
      ProductVariantModel variant, ProductController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              variant.variantName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(variant.sku ?? '-'),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm, vertical: TSizes.xs),
              decoration: BoxDecoration(
                color: variant.isVisible ? TColors.success : TColors.warning,
                borderRadius: BorderRadius.circular(TSizes.sm),
              ),
              child: Text(
                variant.isVisible ? 'Visible' : 'Hidden',
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    _showEditVariantDialog(variant, controller);
                  },
                  tooltip: 'Edit variant',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(variant, controller);
                  },
                  tooltip: 'Delete variant',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditVariantDialog(ProductVariantModel variant,
      ProductController controller) {
    final nameController = TextEditingController(text: variant.variantName);
    final skuController = TextEditingController(text: variant.sku ?? '');
    bool isVisible = variant.isVisible;

    Get.defaultDialog(
      title: 'Edit Variant',
      content: StatefulBuilder(
        builder: (context, setState) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Variant Name',
                      hintText: 'e.g., 1L, 1.5L, Red, Blue',
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: skuController,
                    decoration: const InputDecoration(
                      labelText: 'SKU (Optional)',
                      hintText: 'e.g., PEP-1L',
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  Row(
                    children: [
                      Checkbox(
                        value: isVisible,
                        onChanged: (value) {
                          setState(() {
                            isVisible = value ?? false;
                          });
                        },
                      ),
                      const Text('Is Visible'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      textConfirm: 'Update',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: TColors.primary,
      onConfirm: () async {
        if (nameController.text.trim().isEmpty) {
          TLoaders.errorSnackBar(
              title: 'Error', message: 'Variant name is required');
          return;
        }

        Get.back();

        final updatedVariant = variant.copyWith(
          variantName: nameController.text.trim(),
          sku: skuController.text.trim(),
          isVisible: isVisible,
        );

        await controller.updateProductVariant(updatedVariant);
      },
    );
  }

  void _showDeleteConfirmation(ProductVariantModel variant, ProductController controller) {
    Get.defaultDialog(
      title: 'Delete Variant',
      middleText:
          'Are you sure you want to delete variant "${variant.variantName}"? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        if (variant.variantId != null) {
          await controller.deleteProductVariant(variant.variantId!);
        }
      },
    );
  }
}
