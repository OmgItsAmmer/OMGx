import 'package:admin_dashboard_v3/common/widgets/appbar/TAppBar.dart';
import 'package:admin_dashboard_v3/views/orders/widgets/AvTable.dart';

import 'package:flutter/material.dart';

class Orderscreen extends StatelessWidget {
  const Orderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfMaps = [
      {
        'Order No': '001',
        'Order ID': 'A123',
        'Customer Name': 'John Doe',
        'Status': 'Shipped',
        'Cost': '\$100',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
    ];
    final innertable = [
      {
        'ProductName': 'Rice',
        'Cost': 'Rs' '100',
      },
      {
        'ProductName': 'biscuits',
        'Cost': 'Rs' '350',
      },
    ];
    return Scaffold(
        appBar: const TAppBar(
          title: Text('Orders'),
          showBackArrow: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                  child: AvTABLE(
                items: listOfMaps,
                columnKeys: const [
                  'Order No',
                  'Order ID',
                  'Customer Name',
                  'Status',
                  'Cost'
                ],
                    enableDoubleTap: true,
                    innerTableItems: innertable,
                    innerColumnKeys: const [ 'ProductName', 'Cost'],
              )),
            ],
          ),
        ));
  }
}
