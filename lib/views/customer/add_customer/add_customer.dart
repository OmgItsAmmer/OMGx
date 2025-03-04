import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/customer/add_customer/resposive_screens/add_customer_desktop.dart';
import 'package:admin_dashboard_v3/views/customer/all_customer/responsive_screens/customer_desktop.dart';
import 'package:admin_dashboard_v3/views/products/product_detail/responsive_screens/product_detail_desktop.dart';
import 'package:flutter/material.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AddCustomerDesktop(),
    );
  }
}
