import 'package:admin_dashboard_v3/common/widgets/appbar/TAppBar.dart';
import 'package:admin_dashboard_v3/views/products/add_product_form.dart';
import 'package:admin_dashboard_v3/common/widgets/table/big_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'add_brand_form.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

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
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Brands'),
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


                          Get.to(() => AddBrandForm(formTitle: 'Add Brand',));

                        }, child: const Text('Add New Brand')))
              ],
            ),
            Expanded(
              child: OBigTable(
                items: listOfMaps,
                columnKeys: const [
                  'Name',
                  'Verified',
                  'Featured',
                  'Product Count',

                ],
                enableDoubleTap: true,
                innerTableItems: [],
                innerColumnKeys:  [],
                enableInnerTableDoubleTap: false,
                button1Title: 'Add Variant',
                button2Title: 'Edit',
                button3Title: 'Delete',
                showButton1: false,
                showButton2: true,
                showButton3: true,
                showChip1: true,
                showChip2: true,
                showChip3: false,



              ),
            ),
          ],
        ),
      ),
    );
  }
}
