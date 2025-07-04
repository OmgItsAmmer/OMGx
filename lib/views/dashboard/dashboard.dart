import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/dashboard/responsive_screens/dashboard_desktp.dart';
import 'package:ecommerce_dashboard/views/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:ecommerce_dashboard/views/dashboard/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/dashboard_controoler.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  late DashboardController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller if needed, or get existing one
    if (!Get.isRegistered<DashboardController>()) {
      controller = Get.put(DashboardController());
    } else {
      controller = Get.find<DashboardController>();
      // Force refresh metrics when revisiting dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.recalculateAllMetrics();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Setup for route observer can be added here if needed
  }

  @override
  void didPopNext() {
    // Called when returning to this page from another page
    super.didPopNext();
    if (mounted) {
      controller.recalculateAllMetrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: DashboardDesktop(),
      tablet: DashboardTablet(),
      mobile: DashboardMobile(),
    );
  }
}
