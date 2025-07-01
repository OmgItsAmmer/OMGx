import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/vendor/vendor_detail/responsive_screens/vendor_detail_desktop.dart';
import 'package:admin_dashboard_v3/views/vendor/vendor_detail/responsive_screens/vendor_detail_mobile.dart';
import 'package:admin_dashboard_v3/views/vendor/vendor_detail/responsive_screens/vendor_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorDetailScreen extends StatelessWidget {
  const VendorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vendor = Get.arguments;
    return TSiteTemplate(
      desktop: VendorDetailDesktop(vendorModel: vendor),
      tablet: VendorDetailTablet(vendorModel: vendor),
      mobile: VendorDetailMobile(vendorModel: vendor),
    );
  }
}
