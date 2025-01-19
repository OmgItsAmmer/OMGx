import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/orders/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../data_table.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return  TPaginatedDataTable(
      sortAscending: true,
      minWidth: 700,
      columns: const [
        DataColumn2(label: Text('Order ID')),
        DataColumn2(label: Text('Date')),
        DataColumn2(label: Text('Items')),
        DataColumn2(
            label: Text('Status'),
            fixedWidth: null), // no mobile screen fucntion yey
        DataColumn2(label: Text('Amount')),
        DataColumn2(label: Text('Action'), fixedWidth: 100),
      ],
      source: OrderRows(),
    );
  }
}
