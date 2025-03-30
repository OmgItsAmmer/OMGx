  import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
  import 'package:admin_dashboard_v3/views/customer/all_customer/responsive_screens/customer_desktop.dart';
  import 'package:admin_dashboard_v3/views/expenses/resposive_screens/expenses_desktop.dart';
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/expenses/expense_controller.dart';

  class ExpenseScreen extends StatelessWidget {
    const ExpenseScreen({super.key});

    @override
    Widget build(BuildContext context) {
      Get.put(ExpenseController());
      return const TSiteTemplate(
        desktop: ExpensesDesktop(),
      );
    }
  }
