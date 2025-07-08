import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SerialVariantSelector extends StatelessWidget {
  const SerialVariantSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final ProductController productController = Get.find<ProductController>();

    return Obx(() {
      // Only show for products with serial numbers that have been selected
      if (salesController.selectedProductId.value == -1 ||
          salesController.isManualTextEntry.value) {
        return const SizedBox.shrink();
      }

      final product = productController.allProducts.firstWhere(
        (p) => p.productId == salesController.selectedProductId.value,
        orElse: () => ProductModel.empty(),
      );

      // if (!product.hasSerialNumbers) {
      //   return const SizedBox.shrink();
      // }

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Serial Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TSizes.sm),
            Obx(() {
              if (salesController.isLoadingVariants.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(TSizes.md),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (salesController.availableVariants.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(TSizes.sm),
                  child: Text('No serial numbers available for this product'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Serial Number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(), // For the select button
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // List of variants
                  SizedBox(
                    height: salesController.availableVariants.length > 3
                        ? 200 // Fixed height with scroll when many items
                        : null, // Auto height for few items
                    child: ListView.separated(
                      shrinkWrap: salesController.availableVariants.length <= 3,
                      physics: salesController.availableVariants.length > 3
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      itemCount: salesController.availableVariants.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final variant =
                            salesController.availableVariants[index];
                        return _buildVariantRow(
                          context,
                          salesController,
                          variant,
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
    });
  }

  Widget _buildVariantRow(BuildContext context, SalesController controller,
      ProductVariantModel variant) {
    return Obx(() {
      final isInCart = controller.allSales
          .any((sale) => sale.variantId == variant.variantId);
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(variant.variantId.toString()),
          ),
          Expanded(
            flex: 2,
            child: Text('Rs ${variant.sellPrice.toStringAsFixed(2)}'),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: isInCart ||
                      controller.selectedVariantId.value == variant.variantId
                  ? null // Disable if already in cart or selected
                  : () => controller.selectVariant(variant),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                minimumSize: const Size(80, 36),
                backgroundColor: isInCart ? Colors.grey : TColors.primary,
              ),
              child: Text(
                isInCart ||
                        controller.selectedVariantId.value == variant.variantId
                    ? 'Selected'
                    : 'Select',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      );
    });
  }
}
