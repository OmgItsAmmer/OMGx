
import 'package:flutter/material.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../all_orders/table/order_table.dart';

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
    return const Scaffold(
        appBar: TAppBar(
          title: Text('Orders'),
          showBackArrow: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: OrderTable())
                ],
              )
            ],
          ),
        ));
  }
}
