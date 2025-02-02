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

          final selectedProduct = productController.allProducts
              .firstWhere((product) => product.name == val);

         // salesController.selectedProductName.value = value ?? '';
          salesController.selectedProductId.value = selectedProduct.productId ?? -1;

          //Automatic gives unit price
          salesController.unitPrice.value.text = selectedProduct.salePrice ?? ' ';

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
