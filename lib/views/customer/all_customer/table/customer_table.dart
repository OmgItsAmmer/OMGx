import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/customer/customer_controller.dart';
import '../../../paginated_data_table.dart';
import 'customer_table_soruce.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController =
        Get.find<CustomerController>();

    // Use a unique instance of TableSearchController for customers
    if (!Get.isRegistered<TableSearchController>(tag: 'customers')) {
      Get.put(TableSearchController(), tag: 'customers');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'customers');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered customers list based on search term
      var filteredCustomers = [
        ...customerController.allCustomers
      ]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredCustomers = customerController.allCustomers.where((customer) {
          // Search using correct property names
          return customer.fullName.toLowerCase().contains(searchTerm) ||
              customer.email.toLowerCase().contains(searchTerm) ||
              customer.phoneNumber.toLowerCase().contains(searchTerm);
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
          DataColumn2(label: Text('Customer'), tooltip: 'Customer Name'),
          DataColumn2(label: Text('Email'), tooltip: 'Email Address'),
          DataColumn2(label: Text('Phone Number'), tooltip: 'Contact Number'),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: CustomerRow(
          customerCount: filteredCustomers.length,
          filteredCustomers: filteredCustomers,
        ),
      );
    });
  }
}
