import 'package:admin_dashboard_v3/controllers/expenses/expense_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data_table.dart';
import 'expense_table_source.dart';

class ExpenseTable extends StatelessWidget {
  const ExpenseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find<ExpenseController>();

    return Obx(
      () => TPaginatedDataTable(
        sortAscending: true,
        minWidth: 700,
        showCheckBox: false,
        columns: const [
          //    DataColumn2(label: Text('')),
          DataColumn2(label: Text('Description')),

          DataColumn2(label: Text('Amount')),

          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: ExpenseRow(itemCount: expenseController.expenses.length),
      ),
    );
  }
}
