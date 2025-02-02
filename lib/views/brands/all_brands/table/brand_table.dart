import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/brands/brand_controller.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../data_table.dart';
import 'brand_table_source.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();

    return  Obx(
            () {

          return TPaginatedDataTable(

            sortAscending: true,
            minWidth: 700,
            columns: const [
              DataColumn2(label: Text('Product')),
              DataColumn2(label: Text('Products')),
              // DataColumn2(label: Text('Sold')),
              // DataColumn2(label: Text('Brand')),
              DataColumn2(label: Text('Action'), fixedWidth: 100),
            ],
            source: BrandRow(
              brandCount: brandController.allBrands.length,
            )
          );


        }
    );

  }
}
