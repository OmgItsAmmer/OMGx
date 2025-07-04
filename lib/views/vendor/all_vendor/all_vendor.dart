import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/vendor/all_vendor/responsive_screens/vendor_desktop.dart';
import 'package:ecommerce_dashboard/views/vendor/all_vendor/responsive_screens/vendor_tablet.dart';
import 'package:ecommerce_dashboard/views/vendor/all_vendor/responsive_screens/vendor_mobile.dart';
import 'package:flutter/material.dart';

class AllVendorScreen extends StatelessWidget {
  const AllVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: VendorDesktop(),
      tablet: VendorTablet(),
      mobile: VendorMobile(),
    );
  }
}
