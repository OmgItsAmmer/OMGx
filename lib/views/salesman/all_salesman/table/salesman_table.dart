import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/table/salesman_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../data_table.dart';

class SalesmanTable extends StatelessWidget {
  const SalesmanTable({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    // Use a unique instance of TableSearchController for salesmen
    if (!Get.isRegistered<TableSearchController>(tag: 'salesmen')) {
      Get.put(TableSearchController(), tag: 'salesmen');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'salesmen');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered salesmen list based on search term
      var filteredSalesmen = [
        ...salesmanController.allSalesman
      ]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredSalesmen = salesmanController.allSalesman.where((salesman) {
          // Add search criteria based on Salesman properties
          return salesman.fullName.toLowerCase().contains(searchTerm) ||
              salesman.email.toLowerCase().contains(searchTerm) ||
              salesman.phoneNumber.toLowerCase().contains(searchTerm);
        }).toList();
      }

      return TPaginatedDataTable(
        sortAscending: false,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        showCheckBox: false,
        rowsperPage: tableSearchController.rowsPerPage.value,
        availableRowsPerPage: tableSearchController.availableRowsPerPage,
        onSortChanged: (columnIndex, ascending) {
          tableSearchController.sort(columnIndex, ascending);
          // Add sorting logic here if needed
        },
        columns: const [
          DataColumn2(label: Text('Salesman'), tooltip: 'Salesman Name'),
          DataColumn2(label: Text('Email'), tooltip: 'Email Address'),
          DataColumn2(label: Text('Phone Number'), tooltip: 'Contact Number'),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: SalesmanRow(
          itemCount: filteredSalesmen.length,
          filteredSalesmen: filteredSalesmen,
        ),
      );
    });
  }
}
