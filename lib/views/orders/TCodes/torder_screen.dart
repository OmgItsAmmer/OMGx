import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/orders/TCodes/paginated_Order_Screen.dart';
import 'package:admin_dashboard_v3/views/orders/table/order_table.dart';
import 'package:flutter/material.dart';

class TOrderScreen extends StatelessWidget {
  const TOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: OrderTable(),





    );
  }
}
