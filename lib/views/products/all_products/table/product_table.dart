import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../data_table.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    return  TPaginatedDataTable(
      sortAscending: true,
      minWidth: 700,
      columns:  [
        const DataColumn2(label: Text('Order ID')),
        const DataColumn2(label: Text('Date')),
        const DataColumn2(label: Text('Items')),
        DataColumn2(
            label: const Text('Status'),
            fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null), // no mobile screen fucntion yey
        const DataColumn2(label: Text('Amount')),
        const DataColumn2(label: Text('Action'), fixedWidth: 100),
      ],
      source: ,
    );;
  }
}

