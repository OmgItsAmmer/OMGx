import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/salesman/add_salesman/responsive_screen/add_salesman_desktop.dart';
import 'package:admin_dashboard_v3/views/salesman/add_salesman/responsive_screen/add_salesman_mobile.dart';
import 'package:admin_dashboard_v3/views/salesman/add_salesman/responsive_screen/add_salesman_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/salesman/salesman_model.dart';

class AddSalesmanScreen extends StatelessWidget {
  const AddSalesmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesmanModel salesmanModel = Get.arguments;
    return TSiteTemplate(
      desktop: AddSalesmanDesktop(salesmanModel: salesmanModel),
      tablet: AddSalesmanTablet(salesmanModel: salesmanModel),
      mobile: AddSalesmanMobile(salesmanModel: salesmanModel),
    );
  }
}
