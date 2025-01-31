import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../controllers/installments/installments_controller.dart';
import '../../../controllers/sales/sales_controller.dart';


class InstallmentRow extends DataTableSource {
  final InstallmentController installmentController = Get.find<InstallmentController>();

  InstallmentRow({required this.installmentCount});
  final installmentCount;


  @override
  DataRow? getRow(int index) {
    final saleItem = installmentController.installmentPlans[index];
    return DataRow2(
        onTap: () {},
        selected: false,

        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            saleItem.sequenceNo.toString(), //Dummy
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.description == '' ? 'Installment No${saleItem.sequenceNo}' : saleItem.description,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.dueDate.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.paidDate.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),

          DataCell(Text(
            saleItem.amountDue,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.paidAmount.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.remarks,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.remaining,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.status.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: true,
            delete: false,
            onViewPressed:() => Get.toNamed(TRoutes.productsDetail, arguments: saleItem),
            onDeletePressed: () {},
            onEditPressed: (){TLoader.successSnackBar(title: index );},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => installmentCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
