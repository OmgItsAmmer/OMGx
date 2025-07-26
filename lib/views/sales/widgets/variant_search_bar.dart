// import 'package:ecommerce_dashboard/Models/products/product_model.dart';
// import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/products/product_variant_model.dart';
import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';

class VariantSearchBar extends StatelessWidget {
  const VariantSearchBar({super.key, required this.variantNameFocus});

  final FocusNode variantNameFocus;

  @override
  Widget build(BuildContext context) {
    final salesController = Get.find<SalesController>();

    // Wrap EnhancedAutocomplete with a Focus widget for external traversal
    return Focus(
      focusNode: variantNameFocus,
      child: Obx(
          () => EnhancedAutocomplete<ProductVariantModel>(
          // No focusNode passed internally anymore
          labelText: 'Variant Name',
          hintText: 'Select a variant',
          displayStringForOption: (ProductVariantModel variant) =>
              variant.variantName,
          options: salesController.availableVariants.value,
          externalController: salesController.variantDropdownController,
          isManualTextEntry: salesController.isManualTextEntry,
          selectedItemName: salesController.selectedVariantName,
          selectedItemId: salesController.selectedVariantId,
          getItemId: (ProductVariantModel variant) => variant.variantId,
          onManualTextEntry: (String text) {
            // Clear variants and product id if the user is typing manually
            salesController.clearVariantSelection();
          },
          onSelected: (ProductVariantModel selectedVariant) async {
            print('Selected variant: ${selectedVariant.variantName}');
            // Set the selected variant ID
            salesController.selectedVariantId.value =
                selectedVariant.variantId ?? -1;
            salesController.selectedVariantName.value = selectedVariant.variantName;

            // Set default unit price from variant sell price
            salesController.unitPrice.value.text =
                selectedVariant.sellPrice.toString();

            // Calculate buying price for profit calculation
            salesController.buyingPriceIndividual = selectedVariant.buyPrice;

            // Set quantity to 1 for serialized products
            salesController.quantity.text = "1";

            // Calculate total price
            salesController.totalPrice.value.text =
                selectedVariant.sellPrice.toString();

            // Request focus on the unit price field after selection logic is complete
            salesController.unitPriceFocus.requestFocus();
          },
        ),
      ),
    );
  }
}

// SizedBox(
//   width: 300  ,
//  height: 60,
//   child: OSearchDropDown(
//    // key: salesController.searchDropDownKey,
//     hintText: 'Product Name',
//     suggestions: productController.productNames,
//
//     onSelected: (value){
//       final selectedProduct = productController.allProducts
//           .firstWhere((product) => product.name == value);
//
//       salesController.selectedProductName.value = value;
//       salesController.selectedProductId.value = selectedProduct.productId;
//
//
//
//     },
//
//
//   ),
// ),
