import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/views/products/add_product_form.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../paginated_data_table.dart';

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
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
      },
      {
        'Order No': '002',
        'Order ID': 'B456',
        'Customer Name': 'Jane Smith',
        'Status': 'Pending',
        'Cost': '\$200',
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
        title: Text(
          'Products',
          style: TextStyle(
            fontSize: 25, // Set the desired font size
          ),
        ),
        showBackArrow: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Material(
          color: TColors.pureBlack,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: TColors.pureBlack,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2), // Shadow color
                  spreadRadius: 5, // Spread of the shadow
                  blurRadius: 10, // Blur intensity
                  offset:
                      Offset(0, 5), // Offset for horizontal and vertical shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  const SizedBox(height: TSizes.spaceBtwInputFields,),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => AddProductForm());
                        },
                        child: const Text('Add Products'),
                      ),
                    ),
                  ),
                ),
                // const Expanded(child: TPaginatedDataTable(
                //
                //   columnNames: ['Option 1', 'Option 2'],
                //   rowData:  ['Option 1', 'Option 2'],
                // ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
