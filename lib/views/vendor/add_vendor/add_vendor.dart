import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/vendor/add_vendor/resposive_screens/add_vendor_desktop.dart';
import 'package:ecommerce_dashboard/views/vendor/add_vendor/resposive_screens/add_vendor_mobile.dart';
import 'package:flutter/material.dart';

import 'resposive_screens/add_vendor_tablet.dart';

class AddVendorScreen extends StatelessWidget {
  const AddVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
//    final customerModel = Get.arguments;
    return const TSiteTemplate(
      useLayout: false,
      desktop: AddVendorDesktop(),
      tablet: AddVendorTablet(),
      mobile: AddVendorMobile(),
    );
  }
}
