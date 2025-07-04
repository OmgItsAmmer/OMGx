import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/salesman/add_salesman/responsive_screen/add_salesman_desktop.dart';
import 'package:ecommerce_dashboard/views/salesman/add_salesman/responsive_screen/add_salesman_mobile.dart';
import 'package:ecommerce_dashboard/views/salesman/add_salesman/responsive_screen/add_salesman_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/salesman/salesman_model.dart';
import '../../../controllers/salesman/salesman_controller.dart';

class AddSalesmanScreen extends StatelessWidget {
  const AddSalesmanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesmanModel salesmanModel = Get.arguments;
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    // Initialize entityId for image fetching when editing an existing salesman
    if (salesmanModel.salesmanId != null) {
      salesmanController.entityId.value = salesmanModel.salesmanId!;
    }

    return TSiteTemplate(
      useLayout: false,
      desktop: AddSalesmanDesktop(salesmanModel: salesmanModel),
      tablet: AddSalesmanTablet(salesmanModel: salesmanModel),
      mobile: AddSalesmanMobile(salesmanModel: salesmanModel),
    );
  }
}
