import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/controllers/report/report_controller.dart';
import 'package:ecommerce_dashboard/views/reports/all_reports/responsive_screens/all_reports_desktop.dart';
import 'package:ecommerce_dashboard/views/reports/all_reports/responsive_screens/all_reports_mobile.dart';
import 'package:ecommerce_dashboard/views/reports/all_reports/responsive_screens/all_reports_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    if (!Get.isRegistered<ReportController>()) {
      Get.put(ReportController());
    }

    return const TSiteTemplate(
      desktop: AllReportsDesktop(),
      tablet: AllReportsTablet(),
      mobile: AllReportsMobile(),
    );
  }
}
