import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/purchase_sales/purchase_sales_controller.dart';
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
        },
        onSelected: (ProductModel selectedProduct) async {
          final isSerializedProduct = selectedProduct.hasSerialNumbers;
          purchaseSalesController.isSerializedProduct.value =
              isSerializedProduct;

          // Load variants for serialized products
          if (isSerializedProduct) {
            await purchaseSalesController
                .loadAvailableVariants(selectedProduct.productId ?? -1);

            // For serialized products, quantity is always 1
            purchaseSalesController.quantity.text = "1";
            purchaseSalesController.unitPrice.value
                .clear(); // Will be set when variant is selected
            purchaseSalesController.totalPrice.value
                .clear(); // Will be set when variant is selected
          } else {
            // For non-serialized products - use base price for purchases (cost price)
            purchaseSalesController.unitPrice.value.text =
                selectedProduct.basePrice ?? "0";

            // Clear any previously loaded variants
            purchaseSalesController.availableVariants.clear();
            purchaseSalesController.selectedVariantId.value = -1;
          }

          // Request focus on the unit price field after selection logic is complete
          purchaseSalesController.unitPriceFocus.requestFocus();
        },
        validator: (value) =>
            TValidator.validateEmptyText('Product Name', value),
      ),
    );
  }
}
