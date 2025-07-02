import 'package:admin_dashboard_v3/views/purchases/all_purchases/table/purchase_table.dart';
import 'package:flutter/material.dart';

class PurchasesDesktopScreen extends StatelessWidget {
  const PurchasesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Text(
              'Purchase Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),

            /// Data Table
            PurchaseTable(),
          ],
        ),
      ),
    );
  }
}
