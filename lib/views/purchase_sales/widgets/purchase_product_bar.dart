import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/products/product_model.dart';
import '../../../utils/validators/validation.dart';
import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';

class PurchaseProductSearchBar extends StatelessWidget {
  final FocusNode productNameFocus;

  const PurchaseProductSearchBar({
    super.key,
    required this.productNameFocus,
  });

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();
    final ProductController productController = Get.find<ProductController>();

    return Focus(
      focusNode: productNameFocus,
      child: EnhancedAutocomplete<ProductModel>(
        labelText: 'Product Name',
        hintText: 'Select a product',
        displayStringForOption: (ProductModel product) => product.name,
        options: productController.allProducts,
        externalController: purchaseSalesController.dropdownController,
        isManualTextEntry: purchaseSalesController.isManualTextEntry,
        selectedItemName: purchaseSalesController.selectedProductName,
        selectedItemId: purchaseSalesController.selectedProductId,
        getItemId: (ProductModel product) => product.productId,
        onManualTextEntry: (String text) {
          // Clear variants and product id if the user is typing manually
          purchaseSalesController.clearVariantSelection();
        },
        onSelected: (ProductModel selectedProduct) async {
          try {
            // Clear any previous variant data
            purchaseSalesController.clearVariantSelection();

            // Set base price from product for purchases (cost price)
            purchaseSalesController.purchaseVariantPurchasePrice.text =
                selectedProduct.basePrice ?? "0";
            purchaseSalesController.purchaseVariantSellingPrice.text =
                selectedProduct.salePrice ?? "0";

            // Load all available variants for this product
            await purchaseSalesController
                .loadAvailableVariants(selectedProduct.productId!);

            // Check if product has variants
            if (purchaseSalesController.availableVariants.isNotEmpty) {
              // Product has variants - show them for selection
              purchaseSalesController.showVariantSelectionMode.value = true;

              // Clear unit price fields to encourage variant selection
              purchaseSalesController.unitPrice.value.clear();
              purchaseSalesController.quantity.text = "";
              purchaseSalesController.totalPrice.value.clear();

              // Show message to user
              Get.snackbar(
                'Product Variants Available',
                'This product has ${purchaseSalesController.availableVariants.length} variants. Please select variants below or use the variant manager to add new ones.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.blue.withOpacity(0.8),
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else {
              // No variants - treat as regular product
              purchaseSalesController.showVariantSelectionMode.value = false;

              // For regular purchase entry, use base price as unit price
              purchaseSalesController.unitPrice.value.text =
                  selectedProduct.basePrice ?? "0";

              // Focus on quantity for regular products
              purchaseSalesController.quantityFocus.requestFocus();
            }
          } catch (e) {
            print('Error loading product variants: $e');
            Get.snackbar(
              'Error',
              'Failed to load product variants. You can still add this product manually.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );

            // Fallback to regular product mode
            purchaseSalesController.showVariantSelectionMode.value = false;
            purchaseSalesController.unitPrice.value.text =
                selectedProduct.basePrice ?? "0";
            purchaseSalesController.quantityFocus.requestFocus();
          }
        },
        validator: (value) =>
            TValidator.validateEmptyText('Product Name', value),
      ),
    );
  }
}
