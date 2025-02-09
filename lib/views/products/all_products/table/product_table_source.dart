import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../orders/order_details/order_detail.dart';

class ProductRow extends DataTableSource {

  ProductRow({required this.productCount});
  final ProductController productController = Get.find<ProductController>();
  final ProductImagesController productImagesController = Get.find<ProductImagesController>();
  final MediaController mediaController = Get.find<MediaController>();

  final  productCount;

    @override
    DataRow? getRow(int index) {
      final product = productController.allProducts[index];
      return DataRow2(
          onTap: () async {

          productController.setProductDetail(product);
          await productImagesController.getSpecificImage(MediaCategory.products,product.productId ?? -1);



            Get.toNamed(TRoutes.productsDetail, arguments: product);
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
              product.stockQuantity.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            )),
            DataCell(Text(
              product.basePrice.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            )),
            DataCell(Text(
              product.brandID.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            )), //TODO show brand names
            DataCell(TTableActionButtons(
              view: true,
              edit: false,
              onViewPressed:() => Get.toNamed(TRoutes.productsDetail, arguments: product), // TODO use get argument to send data in order detail screen
              onDeletePressed: () {},
            ))
          ]);
    }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => productController.allProducts.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
