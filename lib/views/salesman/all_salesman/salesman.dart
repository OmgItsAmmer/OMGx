import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/responsive_screens/salesman_desktop.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/responsive_screens/salesman_mobile.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/responsive_screens/salesman_tablet.dart';
import 'package:flutter/material.dart';

class SalesmanScreen extends StatelessWidget {
  const SalesmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: SalesmanDesktop(),
      tablet: SalesmanTablet(),
      mobile: SalesmanMobile(),
    );
  }
}
