import 'package:ecommerce_dashboard/views/purchases/all_purchases/table/purchase_table.dart';
import 'package:flutter/material.dart';

class PurchasesTabletScreen extends StatelessWidget {
  const PurchasesTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Text(
              'Purchase Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            /// Data Table
            PurchaseTable(),
          ],
        ),
      ),
    );
  }
}
