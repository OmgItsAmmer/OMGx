import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/salesman/salesman_detail/responsive_screens/salesman_detail_desktop.dart';
import 'package:ecommerce_dashboard/views/salesman/salesman_detail/responsive_screens/salesman_detail_mobile.dart';
import 'package:ecommerce_dashboard/views/salesman/salesman_detail/responsive_screens/salesman_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesmanDetailScreen extends StatelessWidget {
  const SalesmanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesman = Get.arguments;
    return TSiteTemplate(
      desktop: SalesmanDetailDesktop(salesmanModel: salesman),
      tablet: SalesmanDetailTablet(salesmanModel: salesman),
      mobile: SalesmanDetailMobile(salesmanModel: salesman),
    );
  }
}
