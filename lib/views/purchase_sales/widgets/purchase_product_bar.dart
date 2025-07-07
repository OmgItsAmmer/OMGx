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
          purchaseSalesController.availableVariants.clear();
          purchaseSalesController.selectedVariantId.value = -1;
          purchaseSalesController.isSerializedProduct.value = false;
          purchaseSalesController
              .clearPurchaseVariants(); // Clear purchase variants
        },
        onSelected: (ProductModel selectedProduct) async {
          // Check if this product has variants by loading them
          await productController
              .fetchProductVariants(selectedProduct.productId ?? -1);
          final hasVariants = productController.productVariants.isNotEmpty;

          purchaseSalesController.isSerializedProduct.value = hasVariants;

          if (hasVariants) {
            // For variant-based products - clear any existing variants and prepare for variant manager
            purchaseSalesController.clearPurchaseVariants();
            purchaseSalesController.availableVariants.clear();
            purchaseSalesController.selectedVariantId.value = -1;

            // Set base price from product for new variants
            purchaseSalesController.purchaseVariantPurchasePrice.text =
                selectedProduct.basePrice ?? "0";
            purchaseSalesController.purchaseVariantSellingPrice.text =
                selectedProduct.salePrice ?? "0";

            // Clear the unit price and quantity fields since we'll use variant manager
            purchaseSalesController.unitPrice.value.clear();
            purchaseSalesController.quantity.text = '';
            purchaseSalesController.totalPrice.value.clear();
          } else {
            // For non-variant products - use base price for purchases (cost price)
            purchaseSalesController.unitPrice.value.text =
                selectedProduct.basePrice ?? "0";

            // Clear any previously loaded variants
            purchaseSalesController.availableVariants.clear();
            purchaseSalesController.selectedVariantId.value = -1;
            purchaseSalesController.clearPurchaseVariants();

            // Request focus on the unit price field after selection logic is complete
            purchaseSalesController.unitPriceFocus.requestFocus();
          }
        },
        validator: (value) =>
            TValidator.validateEmptyText('Product Name', value),
      ),
    );
  }
}
