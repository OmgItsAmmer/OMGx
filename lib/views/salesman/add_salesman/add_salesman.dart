import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/salesman/add_salesman/responsive_screen/add_salesman_desktop.dart';
import 'package:flutter/material.dart';

class AddSalesmanScreen extends StatelessWidget {
  const AddSalesmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AddSalesmanDesktop(),
    );
  }
}
