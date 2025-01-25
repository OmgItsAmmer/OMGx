import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../data_table.dart';

class InstallmentTable extends StatelessWidget {
  const InstallmentTable({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return  Obx(
            () {


          return TPaginatedDataTable(

            sortAscending: true,
            minWidth: 300,
            columns: const [
              DataColumn2(label: Text('No')),
              DataColumn2(label: Text('Description')),
              DataColumn2(label: Text('Due Date')),
              DataColumn2(label: Text('Paid Date')),
              DataColumn2(label: Text('Amount')),
              DataColumn2(label: Text('Paid')),
              DataColumn2(label: Text('Remarks')),
              DataColumn2(label: Text('Balance')),
              DataColumn2(label: Text('Status')),
              DataColumn2(label: Text('Action'), fixedWidth: 100),
            ],
            source: ProductRow(
              productCount: productController.allProducts.length,

            ),
          );


        }
    );

  }
}
