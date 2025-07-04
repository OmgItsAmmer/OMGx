import 'package:ecommerce_dashboard/controllers/expenses/expense_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/icons/table_action_icon_buttons.dart';

class ExpenseRow extends DataTableSource {
  ExpenseRow({required this.itemCount});

  final ExpenseController expenseController = Get.find<ExpenseController>();
  final itemCount;
  @override
  DataRow? getRow(int index) {
    final expense = expenseController.expenses[index];
    return DataRow2(
        onTap: () async {},
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            expense.description.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            expense.amount.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: false,
            delete: true,
            onDeletePressed: () async {
              await expenseController.deleteExpense(expense.expenseId);
            },
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => itemCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
