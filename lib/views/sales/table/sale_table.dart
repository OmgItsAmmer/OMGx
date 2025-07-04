import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/views/sales/table/sale_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/sales/sales_controller.dart';
import '../../paginated_data_table.dart';

class SaleTable extends StatelessWidget {
  const SaleTable({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

    // Use a unique instance of TableSearchController for sales
    if (!Get.isRegistered<TableSearchController>(tag: 'sales')) {
      Get.put(TableSearchController(), tag: 'sales');
    }
    final tableSearchController = Get.find<TableSearchController>(tag: 'sales');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered sales list based on search term
      var filteredSales = [...salesController.allSales]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredSales = salesController.allSales.where((sale) {
          // Add search criteria based on SaleModel properties
          return (sale.name.toLowerCase()).contains(searchTerm) ||
              (sale.salePrice.toLowerCase()).contains(searchTerm) ||
              (sale.quantity.toLowerCase()).contains(searchTerm) ||
              (sale.totalPrice.toLowerCase()).contains(searchTerm);
        }).toList();
      }

      return TPaginatedDataTable(
        showCheckBox: false,
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        rowsperPage: 5,
        availableRowsPerPage: const [5, 10],
        controllerTag: 'sales',
        onSortChanged: (columnIndex, ascending) {
          tableSearchController.sort(columnIndex, ascending);
          // Add sorting logic here if needed
        },
        columns: const [
          DataColumn2(label: Text('Product'), tooltip: 'Product Name'),
          DataColumn2(
              label: Text('Unit Price'),
              tooltip: 'Price per Unit',
              numeric: true),
          DataColumn2(
              label: Text('Quantity'),
              tooltip: 'Number of Units',
              numeric: true),
          DataColumn2(label: Text('Unit'), tooltip: 'Unit of Measurement'),
          DataColumn2(
              label: Text('Total Price'),
              tooltip: 'Total Price',
              numeric: true),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: SaleRow(
          saleCount: filteredSales.length,
          filteredSales: filteredSales,
        ),
      );
    });
  }
}
