import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/controllers/report/report_controller.dart';
import 'package:admin_dashboard_v3/views/reports/all_reports/responsive_screens/all_reports_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController());

    return const TSiteTemplate(
      desktop: AllReportsDesktop(),
    );
  }
}
