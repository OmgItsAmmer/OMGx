import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_dashboard/common/widgets/chips/rounded_choice_chips.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSerialVariants extends StatelessWidget {
  const ProductSerialVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    debugPrint('ProductSerialVariants.build called');

    return Column(
      key: const ValueKey('product_serial_variants'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TSectionHeading(
          title: 'Product Variants with Serial Numbers (Read Only)',
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildSerialVariantsSection(context, controller),
      ],
    );
  }

  Widget _buildEmptyVariantsView(ProductController controller) {
    return const Padding(
      padding: EdgeInsets.all(TSizes.md),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
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
              'Variants are managed through the Purchase system',
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
                        flex: 2,
                        child:
                            TShimmerEffect(width: 60, height: 20, radius: 10),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _buildSerialVariantsSection(
      BuildContext context, ProductController controller) {
    debugPrint('Building variants section');

    return TRoundedContainer(
      key: const ValueKey('variants_section'),
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
          //     Row(
          //       children: [
          //         // Chip toggle for showing sold variants
          //         Obx(() => TChoiceChip(
          //               text: 'Show Sold',
          //               selected: controller.showSoldVariants.value,
          //               onSelected: (value) =>
          //                   controller.toggleSoldVariants(value),
          //             )),
          //         const SizedBox(width: TSizes.sm),
          //         // Simple refresh button
          //         IconButton(
          //           icon: const Icon(Icons.refresh, size: 20),
          //           onPressed: () {
          //             debugPrint('Refresh button pressed');
          //             if (controller.productId.value > 0) {
          //               controller
          //                   .fetchProductVariants(controller.productId.value);
          //             }
          //           },
          //           tooltip: 'Refresh variants',
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          const SizedBox(height: TSizes.sm),

          // Use Obx for reactive updates to the variants list
          Obx(() {
            debugPrint(
                'Rebuilding variants list with Obx, count=${controller.currentProductVariants.length}');

            // Show loading state
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

            // Show empty state or variants list
            final variantsLength = controller.currentProductVariants.length;
            if (variantsLength == 0 ) {
              return _buildEmptyVariantsView(controller);
            }

            // Show variants list
            return Column(
              children: [
                // Header row
                _buildHeaderRow(),
                const Divider(),
               
                  // Variant rows with optimized ListView (read-only)
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
                        final variant =
                            controller.currentProductVariants[index];
                        return Column(
                          key: ValueKey(
                              'variant_${variant.variantId ?? index}_${variant.variantId}'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildVariantRow(variant),
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
    ]));
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
        ],
      ),
    );
  }

  Widget _buildVariantRow(ProductVariantModel variant) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(variant.variantId.toString()),
        ),
        Expanded(
          flex: 2,
          child: Text('Rs ${variant.buyPrice  .toStringAsFixed(2)}'),
        ),
        Expanded(
          flex: 2,
          child: Text('Rs ${variant.sellPrice.toStringAsFixed(2)}'),
        ),
        // Expanded(
        //   flex: 2,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(
        //         horizontal: TSizes.sm, vertical: TSizes.xs),
        //     decoration: BoxDecoration(
        //       color: variant.isSold ? TColors.warning : TColors.success,
        //       borderRadius: BorderRadius.circular(TSizes.sm),
        //     ),
        //     child: Text(
        //       variant.isSold ? 'Sold' : 'Available',
        //       textAlign: TextAlign.center,
        //       style: const TextStyle(
        //         color: Colors.white,
        //         fontSize: 12,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
