import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/brands/brand_controller.dart';
import '../../../data_table.dart';
import 'category_table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();

    return  Obx(
            () {

          return TPaginatedDataTable(

              showCheckBox: false,
              sortAscending: true,
              minWidth: 700,
              columns: const [
                DataColumn2(label: Text('Name')),
                DataColumn2(label: Text('Products')),
                // DataColumn2(label: Text('Sold')),
                // DataColumn2(label: Text('Brand')),
                DataColumn2(label: Text('Action'), fixedWidth: 100),
              ],
              source: CategoryRow(
                categoryCount: categoryController.allCategories.length,
              )
          );


        }
    );

  }
}
