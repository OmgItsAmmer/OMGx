import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Models/products/product_variant_model.dart';
import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class VariantSelectionWidget extends StatelessWidget {
  const VariantSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController controller =
        Get.find<PurchaseSalesController>();

    return Obx(() {
      if (!controller.showVariantSelectionMode.value ||
          controller.availableVariants.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(top: TSizes.spaceBtwItems),
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.style, color: TColors.primary, size: 20),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Text(
                  'Product Variants Available',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                  ),
                ),
                const Spacer(),
                if (controller.selectedVariantsForPurchase.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.selectedVariantsForPurchase.length} Selected',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Variants List
            ...controller.availableVariants
                .map((variant) => _buildVariantTile(variant, controller))
                .toList(),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.clearVariantSelection(),
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Selection'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.selectedVariantsForPurchase.isNotEmpty
                        ? () => controller.addSelectedVariantsToCart()
                        : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(
                      'Add to Cart (${controller.getTotalSelectedVariantQuantity()})',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Summary
            if (controller.selectedVariantsForPurchase.isNotEmpty) ...[
              const SizedBox(height: TSizes.spaceBtwItems),
              Container(
                padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  border: Border.all(color: TColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Selected: ${controller.getTotalSelectedVariantQuantity()} items',
                      style: Get.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Amount: Rs ${controller.getTotalSelectedVariantAmount().toStringAsFixed(2)}',
                      style: Get.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildVariantTile(
      ProductVariantModel variant, PurchaseSalesController controller) {
    final variantId = variant.variantId!;
    final isSelected = controller.selectedVariantsForPurchase
        .any((v) => v.variantId == variantId);
    final quantity = controller.variantQuantities[variantId] ?? 1;
    final purchasePrice =
        controller.variantPrices[variantId] ?? variant.buyPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems / 2),
      decoration: BoxDecoration(
        color: isSelected ? TColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(
          color: isSelected ? TColors.primary : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ExpansionTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (selected) {
            if (selected == true) {
              controller.selectVariantForPurchase(variant, 1, variant.buyPrice);
            } else {
              controller.removeVariantFromPurchase(variantId);
            }
          },
          activeColor: TColors.primary,
        ),
        title: Text(
          variant.variantName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'SKU: ${variant.sku} | Stock: ${variant.stock} | Sell: Rs ${variant.sellPrice}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$quantity x Rs ${purchasePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                'Rs ${variant.buyPrice.toStringAsFixed(2)}',
                style: Get.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
        children: isSelected
            ? [
                Padding(
                  padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                  child: Row(
                    children: [
                      // Quantity Input
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity',
                              style: Get.textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: quantity.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                              ),
                              onChanged: (value) {
                                final qty = int.tryParse(value) ?? 1;
                                if (qty > 0) {
                                  controller.selectVariantForPurchase(
                                      variant, qty, purchasePrice);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),

                      // Purchase Price Input
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Purchase Price',
                              style: Get.textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: purchasePrice.toStringAsFixed(2),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                prefixText: 'Rs ',
                              ),
                              onChanged: (value) {
                                final price =
                                    double.tryParse(value) ?? variant.buyPrice;
                                if (price > 0) {
                                  controller.selectVariantForPurchase(
                                      variant, quantity, price);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),

                      // Total
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: Get.textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                'Rs ${(quantity * purchasePrice).toStringAsFixed(2)}',
                                style: Get.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
