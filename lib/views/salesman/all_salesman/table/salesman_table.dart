import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/table/salesman_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../data_table.dart';

class SalesmanTable extends StatelessWidget {
  const SalesmanTable({super.key});


  @override
  Widget build(BuildContext context) {
    final SalesmanController salesmanController = Get.find<SalesmanController>();

    return Obx(
      () => TPaginatedDataTable(
        sortAscending: true,
        minWidth: 700,
        showCheckBox: true,
        columns: const [
          DataColumn2(label: Text('Salesman')),
          DataColumn2(label: Text('Email')),
          DataColumn2(label: Text('Phone Number')),

          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: SalesmanRow(
          itemCount: salesmanController.allSalesman.length,
        ),
      ),
    );
  }
}
