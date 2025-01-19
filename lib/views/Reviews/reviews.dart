
import 'package:admin_dashboard_v3/views/products/add_product_form.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/widgets/appbar/appbar.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfMaps = [
      {
        'Name': '001',
        'Verified': 'A123',
        'Featured': 'John Doe',
        'Product Count': 'Shipped',
      },
      {
        'Name': '002',
        'Verified': 'B123',
        'Featured': 'Sarah Doe',
        'Product Count': 'Shipped',
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
        title: Text('Brands'),
        showBackArrow: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           //new table here
          ],
        ),
      ),
    );
  }
}
