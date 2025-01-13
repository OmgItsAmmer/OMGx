import 'package:admin_dashboard_v3/common/widgets/appbar/TAppBar.dart';
import 'package:admin_dashboard_v3/views/products/add_product_form.dart';
import 'package:admin_dashboard_v3/views/products/widgets/product_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

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
        title: Text('Products'),
        showBackArrow: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 4,
                    child: SizedBox(
                  width: double.infinity,
                )),
                Expanded(
                  flex: 1,
                    child: ElevatedButton(
                        onPressed: () {


                          Get.to(() => AddProductForm());

                        }, child: const Text('Add Products')))
              ],
            ),
            Expanded(
              child: ProductTable(
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
                innerColumnKeys: const ['ProductName', 'Cost'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
