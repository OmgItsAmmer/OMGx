import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/dashboard/responsive_screens/dashboard_desktp.dart';
import 'package:admin_dashboard_v3/views/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:admin_dashboard_v3/views/dashboard/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/dashboard_controoler.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return const TSiteTemplate(
      desktop: DashboardDesktop(),
      tablet: DashboardTablet(),
      mobile: DashboardMobile(),
    );
  }
}
