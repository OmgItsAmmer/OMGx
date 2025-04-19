import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../data_table.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return Obx(() {
      return TPaginatedDataTable(
        sortAscending: true,
        
        showCheckBox: false,
        minWidth: 700,
        columns: const [
          DataColumn2(label: Text('Product')),
          DataColumn2(label: Text('Price')),
          DataColumn2(label: Text('Stock')),
          DataColumn2(label: Text('Brand')),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: ProductRow(
          productCount: productController.allProducts.length,
        ),
      );
    });
  }
}
