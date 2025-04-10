import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/drop_down_searchbar.dart';
import '../../../common/widgets/dropdown_search/dropdown_search.dart';
import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../controllers/product/product_controller.dart';
import '../../../controllers/sales/sales_controller.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});


  @override
  Widget build(BuildContext context) {

    final ProductController productController = Get.find<ProductController>();
    final SalesController salesController = Get.find<SalesController>();

    return  SizedBox(
      width:double.infinity  ,
      //height: 100,
      child: AutoCompleteTextField(


        titleText: 'Product Name',
        optionList: productController.productNames,
        textController: salesController.dropdownController,
        parameterFunc: (val) {
          if (val.isEmpty) {
            // Reset all related fields when input is cleared
            salesController.selectedProductId.value = -1;
            salesController.unitPrice.value.text = '';
            salesController.buyingPriceIndividual = 0.0;
            return;
          }

          final selectedProduct = productController.allProducts
              .firstWhere((product) => product.name == val);

          salesController.selectedProductId.value = selectedProduct.productId ?? -1;
          salesController.unitPrice.value.text = selectedProduct.salePrice ?? ' ';
          salesController.buyingPriceIndividual = double.parse(selectedProduct.basePrice ?? "0.0");
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
