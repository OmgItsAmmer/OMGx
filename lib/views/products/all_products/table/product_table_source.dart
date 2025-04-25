import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../controllers/media/media_controller.dart';

class ProductRow extends DataTableSource {
  ProductRow({
    required this.productCount,
    this.filteredProducts,
  });

  final ProductController productController = Get.find<ProductController>();
  // final ProductImagesController productImagesController = Get.find<ProductImagesController>();
  final MediaController mediaController = Get.find<MediaController>();
  final BrandController brandController = Get.find<BrandController>();

  final int productCount;
  final List<ProductModel>? filteredProducts;

  @override
  DataRow? getRow(int index) {
    // Use filtered list if provided, otherwise use all products
    final product = filteredProducts != null && filteredProducts!.isNotEmpty
        ? filteredProducts![index]
        : productController.allProducts[index];

    return DataRow2(
        onTap: () async {
          productController.onProductTap(product);
        },
        //   selected: productController.selectedRows[index],
        onSelectChanged: (value) {
          productController.selectedRows[index] = value ?? false;
          // productController.selectedRows.refresh(); // Refresh observable list
        },
        cells: [
          DataCell(Text(
            product.name.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            product.basePrice?.toString() ?? '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            product.salePrice?.toString() ?? '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            product.stockQuantity?.toString() ?? '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            brandController.allBrands
                    .firstWhereOrNull(
                        (element) => element.brandID == product.brandID)
                    ?.bname
                    ?.toString() ??
                '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )), //TODO show brand names
          DataCell(TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              productController.onProductTap(product);
            },
            onDeletePressed: () {},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => productCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
