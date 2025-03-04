import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/customer/customer_controller.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../data_table.dart';
import 'customer_table_soruce.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find<CustomerController>();

    return Obx(
      () => TPaginatedDataTable(
        sortAscending: true,
        minWidth: 700,
        showCheckBox: true,
        columns: const [
        //    DataColumn2(label: Text('')),
          DataColumn2(label: Text('Customer')),

          DataColumn2(label: Text('Email')),
          DataColumn2(label: Text('Phone Number')),

          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: CustomerRow(
          customerCount: customerController.allCustomers.length
        ),
      ),
    );
  }
}
