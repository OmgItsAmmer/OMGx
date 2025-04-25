import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:admin_dashboard_v3/views/sales/table/sale_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../controllers/installments/installments_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../data_table.dart';
import 'installment_table_source.dart';

class InstallmentTable extends StatelessWidget {
  const InstallmentTable({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController =
        Get.find<InstallmentController>();

    // Use a unique instance of TableSearchController for installments
    if (!Get.isRegistered<TableSearchController>(tag: 'installments')) {
      Get.put(TableSearchController(), tag: 'installments');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'installments');

    return Obx(() {
      return TPaginatedDataTable(
        showCheckBox: false,
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        rowsperPage: 10, // Fixed value that exists in availableRowsPerPage
        availableRowsPerPage: tableSearchController.availableRowsPerPage,
        onSortChanged: (columnIndex, ascending) {
          tableSearchController.sort(columnIndex, ascending);
          // Add sorting logic here if needed
        },
        columns: const [
          DataColumn2(label: Text('#')),
          DataColumn2(label: Text('Description')),
          DataColumn2(label: Text('Due Date')),
          DataColumn2(label: Text('Paid Date')),
          DataColumn2(label: Text('Amount')),
          DataColumn2(label: Text('Paid')),
          DataColumn2(label: Text('Remarks')),
          DataColumn2(label: Text('Balance')),
          DataColumn2(label: Text('Status')),
          DataColumn2(
            label: Text('Action'),
            fixedWidth: 100,
          ),
        ],
        source: InstallmentRow(
            installmentCount:
                installmentController.currentInstallmentPayments.length),
      );
    });
  }
}
