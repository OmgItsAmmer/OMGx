import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key, required this.productNameFocus});

  final FocusNode productNameFocus;

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final salesController = Get.find<SalesController>();

    // Wrap EnhancedAutocomplete with a Focus widget for external traversal
    return Focus(
      focusNode: productNameFocus,
      child: EnhancedAutocomplete<ProductModel>(
        // No focusNode passed internally anymore
        labelText: 'Product Name',
        hintText: 'Select a product',
        displayStringForOption: (ProductModel product) => product.name,
        options: productController.allProducts,
        externalController: salesController.dropdownController,
        isManualTextEntry: salesController.isManualTextEntry,
        selectedItemName: salesController.selectedProductName,
        selectedItemId: salesController.selectedProductId,
        getItemId: (ProductModel product) => product.productId,
        onManualTextEntry: (String text) {
          // Clear variants and product id if the user is typing manually
          salesController.clearVariantSelection();
        },
        onSelected: (ProductModel selectedProduct) async {
          // For all products, load their variants since every product has variants now
          await salesController
              .loadAvailableVariants(selectedProduct.productId ?? -1);

          // Request focus on the unit price field after selection logic is complete
          salesController.variantNameFocus.requestFocus();
        },
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
