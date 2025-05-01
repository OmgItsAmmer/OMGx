import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/brands/brand_controller.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../paginated_data_table.dart';
import 'brand_table_source.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();

    // Get the tagged instance of TableSearchController for brands
    final TableSearchController tableSearchController =
        Get.find<TableSearchController>(tag: 'brands');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Filter brands based on search term
      var filteredBrands = [...brandController.allBrands]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredBrands = brandController.allBrands.where((brand) {
          return (brand.bname?.toLowerCase() ?? '').contains(searchTerm);
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
            DataColumn2(label: Text('Brand')),
            DataColumn2(label: Text('Products')),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: BrandRow(
            brandCount: filteredBrands.length,
            filteredBrands: filteredBrands,
          ));
    });
  }
}
