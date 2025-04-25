import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../Models/sales/sale_model.dart';
import '../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../controllers/sales/sales_controller.dart';

class SaleRow extends DataTableSource {
  final SalesController salesController = Get.find<SalesController>();
  SaleRow({
    required this.saleCount,
    this.filteredSales,
  });

  final int saleCount;
  final List<SaleModel>? filteredSales;

  @override
  DataRow? getRow(int index) {
    // Use filtered list if provided, otherwise use all sales
    final saleItem = filteredSales != null && filteredSales!.isNotEmpty
        ? filteredSales![index]
        : salesController.allSales[index];

    return DataRow2(
        onTap: () {},
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            saleItem.name, // Item name
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.salePrice,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.quantity,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.unit.toString().split('.').last,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.totalPrice,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: false,
            onViewPressed: () =>
                Get.toNamed(TRoutes.productsDetail, arguments: saleItem),
            onDeletePressed: () {
              salesController.deleteItem(saleItem, index);
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => saleCount;

  @override
  int get selectedRowCount => 0;
}
