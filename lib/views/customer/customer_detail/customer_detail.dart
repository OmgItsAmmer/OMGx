import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/customer/customer_detail/responsive_screens/customer_detail_desktop.dart';
import 'package:ecommerce_dashboard/views/customer/customer_detail/responsive_screens/customer_detail_mobile.dart';
import 'package:ecommerce_dashboard/views/customer/customer_detail/responsive_screens/customer_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = Get.arguments;
    return TSiteTemplate(
      desktop: CustomerDetailDesktop(customerModel: customer),
      tablet: CustomerDetailTablet(customerModel: customer),
      mobile: CustomerDetailMobile(customerModel: customer),
    );
  }
}
