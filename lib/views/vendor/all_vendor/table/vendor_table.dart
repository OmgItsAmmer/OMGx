import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/vendor/vendor_controller.dart';
import '../../../paginated_data_table.dart';
import 'vendor_table_soruce.dart';

class VendorTable extends StatelessWidget {
  const VendorTable({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.find<VendorController>();

    // Use a unique instance of TableSearchController for vendors
    if (!Get.isRegistered<TableSearchController>(tag: 'vendors')) {
      Get.put(TableSearchController(), tag: 'vendors');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'vendors');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered vendors list based on search term
      var filteredVendors = [...vendorController.allVendors]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredVendors = vendorController.allVendors.where((vendor) {
          // Search using correct property names
          return vendor.fullName.toLowerCase().contains(searchTerm) ||
              vendor.email.toLowerCase().contains(searchTerm) ||
              vendor.phoneNumber.toLowerCase().contains(searchTerm);
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
          DataColumn2(label: Text('Vendor'), tooltip: 'Vendor Name'),
          DataColumn2(label: Text('Email'), tooltip: 'Email Address'),
          DataColumn2(label: Text('Phone Number'), tooltip: 'Contact Number'),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: VendorRow(
          vendorCount: filteredVendors.length,
          filteredVendors: filteredVendors,
        ),
      );
    });
  }
}
