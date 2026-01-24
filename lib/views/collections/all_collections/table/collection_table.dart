import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/views/collections/all_collections/table/collection_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../paginated_data_table.dart';

class CollectionTable extends StatelessWidget {
  const CollectionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionController collectionController = Get.find<CollectionController>();
    final TableSearchController tableSearchController =
        Get.find<TableSearchController>(tag: 'collections');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered collection list based on search term
      var filteredCollections = [
        ...collectionController.allCollections
      ]; // Create a copy to avoid modifying the original
      if (searchTerm.isNotEmpty) {
        filteredCollections = collectionController.allCollections
            .where((collection) =>
                (collection.name.toLowerCase()).contains(searchTerm) ||
                (collection.description?.toLowerCase() ?? '').contains(searchTerm))
            .toList();
      }

      // Apply sorting if needed
      if (tableSearchController.sortColumnIndex.value == 2) {
        filteredCollections.sort((a, b) {
          // Sort by display order
          if (tableSearchController.sortAscending.value) {
            return a.displayOrder.compareTo(b.displayOrder);
          } else {
            return b.displayOrder.compareTo(a.displayOrder);
          }
        });
      }

      return TPaginatedDataTable(
        tableHeight: 840,
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        rowsperPage: tableSearchController.rowsPerPage.value,
        availableRowsPerPage: tableSearchController.availableRowsPerPage,
        onSortChanged: (columnIndex, ascending) {
          // Only allow sorting on the display order column (index 2)
          if (columnIndex == 2) {
            tableSearchController.sort(columnIndex, ascending);
          }
        },
        showCheckBox: false,
        minWidth: 900,
        onPageChanged: (pageIndex) {
          // Handle page changes if needed
        },
        columns: [
          const DataColumn2(
            label: Text('Collection Name'),
            tooltip: 'Collection Name',
          ),
          const DataColumn2(
            label: Text('Description'),
            tooltip: 'Collection Description',
          ),
          DataColumn2(
            label: const Text('Display Order'),
            tooltip: 'Display Order',
            numeric: true,
            onSort: (columnIndex, ascending) {
              tableSearchController.sort(2, ascending);
            },
          ),
          const DataColumn2(
            label: Text('Status'),
            tooltip: 'Active/Inactive',
          ),
          const DataColumn2(
            label: Text('Featured'),
            tooltip: 'Featured Status',
          ),
          const DataColumn2(
            label: Text('Premium'),
            tooltip: 'Premium Status',
          ),
          DataColumn2(
            label: const Text('Actions'),
            tooltip: 'Actions',
            fixedWidth: TDeviceUtils.isDesktopScreen(Get.context!) ? 200 : 150,
          ),
        ],
        source: CollectionTableSource(
          collections: filteredCollections,
        ),
      );
    });
  }
}
