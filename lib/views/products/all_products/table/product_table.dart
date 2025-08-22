import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../paginated_data_table.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final TableSearchController tableSearchController =
        Get.find<TableSearchController>(tag: 'products');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered product list based on search term
      var filteredProducts = [
        ...productController.allProducts
      ]; // Create a copy to avoid modifying the original
      if (searchTerm.isNotEmpty) {
        filteredProducts = productController.allProducts
            .where((product) =>
                (product.name?.toString().toLowerCase() ?? '')
                    .contains(searchTerm) ||
                (product.salePrice?.toString().toLowerCase() ?? '')
                    .contains(searchTerm) ||
                (product.stockQuantity?.toString().toLowerCase() ?? '')
                    .contains(searchTerm))
            .toList();
      }

      // Apply sorting if the stock column (index 3) is selected
      if (tableSearchController.sortColumnIndex.value == 3) {
        filteredProducts.sort((a, b) {
          // Get stock quantities (defaulting to 0 if null)
          int stockA = a.stockQuantity ?? 0;
          int stockB = b.stockQuantity ?? 0;

          // Apply sort direction based on ascending flag
          if (tableSearchController.sortAscending.value) {
            return stockA.compareTo(stockB);
          } else {
            return stockB.compareTo(stockA);
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
          // Only allow sorting on the stock column (index 3)
          if (columnIndex == 3) {
            tableSearchController.sort(columnIndex, ascending);
          }
        },
        showCheckBox: false,
        minWidth: 700,
        onPageChanged: (pageIndex) {
          // Handle page changes if needed
        },
        columns: [
          const DataColumn2(
            label: Text('Product'),
            tooltip: 'Product Name',
          ),
          const DataColumn2(
            label: Text('Price-Range'),
            tooltip: 'Buy Price',
            numeric: true,
          ),
          // const DataColumn2(
          //   label: Text('Sale Price'),
          //   tooltip: 'Sale Price',
          //   numeric: true,
          // ),
          DataColumn2(
            label: const Text('Stock'),
            tooltip: 'Available Stock',
            numeric: true,
            onSort: (columnIndex, ascending) {
              // Enable sorting only for this column
              tableSearchController.sort(3, ascending);
            },
          ),
          const DataColumn2(
            label: Text('Brand'),
            tooltip: 'Brand Name',
          ),
          const DataColumn2(
            label: Text('Action'),
            fixedWidth: 100,
          ),
        ],
        source: ProductRow(
          productCount: filteredProducts.length,
          filteredProducts: filteredProducts,
        ),
      );
    });
  }
}
