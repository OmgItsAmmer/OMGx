import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/brands/brand_controller.dart';
import '../../../paginated_data_table.dart';
import 'category_table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    // Get the tagged instance of TableSearchController for categories
    final TableSearchController tableSearchController =
        Get.find<TableSearchController>(tag: 'categories');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Filter categories based on search term
      var filteredCategories = [
        ...categoryController.allCategories
      ]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredCategories = categoryController.allCategories.where((category) {
          return (category.categoryName?.toLowerCase() ?? '')
              .contains(searchTerm);
        }).toList();
      }

      return TPaginatedDataTable(
          showCheckBox: false,
          sortAscending: false, // Disable sorting
          sortColumnIndex: null, // No sort column
          minWidth: 700,
          rowsperPage: tableSearchController.rowsPerPage.value,
          availableRowsPerPage: tableSearchController.availableRowsPerPage,
          columns: const [
            DataColumn2(label: Text('Name')),
            DataColumn2(label: Text('Products')),
            // DataColumn2(label: Text('Sold')),
            // DataColumn2(label: Text('Brand')),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: CategoryRow(
            categoryCount: filteredCategories.length,
            filteredCategories: filteredCategories,
          ));
    });
  }
}
