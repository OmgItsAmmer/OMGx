import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../paginated_data_table.dart';
import 'purchase_table_source.dart';

class PurchaseTable extends StatelessWidget {
  const PurchaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

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
        ...purchaseSalesController.allPurchases
      ]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredPurchases =
            purchaseSalesController.allPurchases.where((purchase) {
          // Add search criteria based on PurchaseCartItem properties
          return (purchase.name.toLowerCase()).contains(searchTerm) ||
              (purchase.purchasePrice.toLowerCase()).contains(searchTerm) ||
              (purchase.quantity.toLowerCase()).contains(searchTerm) ||
              (purchase.totalPrice.toLowerCase()).contains(searchTerm);
        }).toList();
      }

      return TPaginatedDataTable(
        showCheckBox: false,
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        rowsperPage: 5,
        availableRowsPerPage: const [5, 10],
        controllerTag: 'purchases',
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
        source: PurchaseRow(
          purchaseCount: filteredPurchases.length,
          filteredPurchases: filteredPurchases,
        ),
      );
    });
  }
}
