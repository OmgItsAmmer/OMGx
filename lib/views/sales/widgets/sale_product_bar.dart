import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/sales/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/searchable_text_field.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final salesController = Get.find<SalesController>();

    return Autocomplete<ProductModel>(
      displayStringForOption: (ProductModel product) => product.name,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        // Set the initial value of the text field from controller if available
        if (salesController.dropdownController.text.isNotEmpty &&
            textEditingController.text.isEmpty) {
          textEditingController.text = salesController.dropdownController.text;
        }

        // Set up a listener to keep the controllers in sync
        textEditingController.addListener(() {
          final currentText = textEditingController.text;
          salesController.dropdownController.text = currentText;

          // Check if the text was manually edited and doesn't match the selected product
          if (currentText != salesController.selectedProductName.value) {
            // Clear variants and product id if the user is typing manually
            salesController.availableVariants.clear();
            salesController.selectedVariantId.value = -1;
            // Don't immediately clear selectedProductId to avoid flickering
            // but set a flag to indicate manual text entry
            salesController.isManualTextEntry.value = true;
          }
        });

        return TextFormField(
          focusNode: focusNode,
          controller: textEditingController,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: const InputDecoration(
            labelText: 'Product Name',
            hintText: 'Select a product',
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<ProductModel>.empty();
        }

        // Filter products based on the entered text
        return productController.allProducts.where((ProductModel product) {
          return product.name.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
        });
      },
      onSelected: (ProductModel selectedProduct) async {
        // Update the dropdownController with the selected product name
        salesController.dropdownController.text = selectedProduct.name;
        salesController.selectedProductName.value = selectedProduct.name;
        salesController.selectedProductId.value =
            selectedProduct.productId ?? -1;
        salesController.isManualTextEntry.value = false;

        final isSerializedProduct = selectedProduct.hasSerialNumbers;

        // Load variants for serialized products
        if (isSerializedProduct) {
          await salesController
              .loadAvailableVariants(selectedProduct.productId ?? -1);

          // For serialized products, quantity is always 1
          salesController.quantity.text = "1";
          salesController.unitPrice.value
              .clear(); // Will be set when variant is selected
          salesController.totalPrice.value
              .clear(); // Will be set when variant is selected
        } else {
          // For non-serialized products
          salesController.unitPrice.value.text =
              selectedProduct.salePrice ?? "0";

          // Calculate buying price for profit calculation
          salesController.buyingPriceIndividual = double.tryParse(
                selectedProduct.basePrice ?? "0",
              ) ??
              0.0;

          // Clear any previously loaded variants
          salesController.availableVariants.clear();
          salesController.selectedVariantId.value = -1;
        }
      },
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
