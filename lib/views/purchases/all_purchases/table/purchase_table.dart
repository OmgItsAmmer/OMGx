import 'package:ecommerce_dashboard/Models/purchase/purchase_model.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:ecommerce_dashboard/views/purchases/all_purchases/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../paginated_data_table.dart';

class PurchaseTable extends StatelessWidget {
  const PurchaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();

    // Use a unique instance of TableSearchController for purchases
    if (!Get.isRegistered<TableSearchController>(tag: 'purchases')) {
      Get.put(TableSearchController(), tag: 'purchases');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'purchases');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered purchases list based on search term
      var filteredPurchases = [
        ...purchaseController.allPurchases
      ]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredPurchases = purchaseController.allPurchases.where((purchase) {
          // Add search criteria based on PurchaseModel properties
          return purchase.purchaseId
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm) ||
              purchase.purchaseDate.toLowerCase().contains(searchTerm) ||
              purchase.status.toLowerCase().contains(searchTerm) ||
              purchase.subTotal.toString().toLowerCase().contains(searchTerm);
        }).toList();
      }

      // Sort purchases by ID in descending order (bigger purchase ID first) by default
      if (tableSearchController.sortColumnIndex.value == null) {
        filteredPurchases.sort((a, b) => b.purchaseId.compareTo(a.purchaseId));
      } else if (tableSearchController.sortColumnIndex.value == 0) {
        // Sort by Purchase ID based on the current sorting state
        filteredPurchases.sort((a, b) {
          if (tableSearchController.sortAscending.value) {
            return a.purchaseId.compareTo(b.purchaseId); // Ascending
          } else {
            return b.purchaseId.compareTo(a.purchaseId); // Descending
          }
        });
      }

      return TPaginatedDataTable(
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        showCheckBox: false,
        dataRowHeight: 60,
        tableHeight: 840,
        rowsperPage: 10,
        availableRowsPerPage: const [5, 10],
        controllerTag: 'purchases',
        onSortChanged: (columnIndex, ascending) {
          // Only sort by Purchase ID (column 0)
          if (columnIndex == 0) {
            tableSearchController.sort(columnIndex, ascending);

            // Sort purchases by ID in descending order (bigger purchase ID first)
            filteredPurchases.sort((a, b) {
              if (ascending) {
                return a.purchaseId.compareTo(b.purchaseId); // Ascending
              } else {
                return b.purchaseId.compareTo(a.purchaseId); // Descending
              }
            });
          }
        },
        columns: [
          DataColumn2(
            label: const Text('Purchase ID'),
            tooltip: 'Purchase ID',
            onSort: (columnIndex, ascending) {
              // Enable sorting only for this column
              tableSearchController.sort(columnIndex, ascending);
            },
          ),
          const DataColumn2(label: Text('Date'), tooltip: 'Purchase Date'),
          const DataColumn2(label: Text('Vendor'), tooltip: 'Vendor Name'),
          DataColumn2(
              label: const Text('Status'),
              tooltip: 'Purchase Status',
              fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null),
          const DataColumn2(
              label: Text('Amount'), tooltip: 'Purchase Amount', numeric: true),
          const DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: PurchaseRows(
          purchasesCount: filteredPurchases.length,
          filteredPurchases: filteredPurchases.cast<PurchaseModel>(),
        ),
      );
    });
  }
}
