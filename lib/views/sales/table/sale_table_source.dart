import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../Models/orders/order_model.dart';
import '../../../controllers/sales/sales_controller.dart';


class SaleRow extends DataTableSource {
  final SalesController salesController = Get.find<SalesController>();
  SaleRow({required this.saleCount});
  final saleCount;


  @override
  DataRow? getRow(int index) {
   final saleItem = salesController.allSales[index];
    return DataRow2(
        onTap: () {},
        selected: false,

        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            salesController.allSales[index].name, //Dummy
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            salesController.allSales[index].salePrice,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            salesController.allSales[index].quantity,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            salesController.allSales[index].unit,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )), //TODO show brand names

          DataCell(Text(
            salesController.allSales[index].totalPrice,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: false,
            onViewPressed:() => Get.toNamed(TRoutes.productsDetail, arguments: saleItem), // TODO use get argument to send data in order detail screen
            onDeletePressed: () {},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => saleCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
