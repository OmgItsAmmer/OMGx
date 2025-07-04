import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/customer/all_customer/responsive_screens/customer_desktop.dart';
import 'package:ecommerce_dashboard/views/customer/all_customer/responsive_screens/customer_tablet.dart';
import 'package:ecommerce_dashboard/views/customer/all_customer/responsive_screens/customer_mobile.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: CustomerDesktop(),
      tablet: CustomerTablet(),
      mobile: CustomerMobile(),
    );
  }
}
