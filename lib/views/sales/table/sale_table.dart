import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:admin_dashboard_v3/views/sales/table/sale_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../data_table.dart';

class SaleTable extends StatelessWidget {
  const SaleTable({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

    return Obx(
      () {

        return TPaginatedDataTable(
          showCheckBox: false,
          sortAscending: true,
          minWidth: 700,
          rowsperPage: 5,

          columns: const [
            DataColumn2(label: Text('Product')),
            DataColumn2(label: Text('Unit Price')),
            DataColumn2(label: Text('Quantity')),
            DataColumn2(label: Text('Unit')),
            DataColumn2(label: Text('Total Price')),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: SaleRow(
            saleCount: salesController.allSales.length

          ),
        );

      }
    );
  }
}
