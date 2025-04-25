import 'package:admin_dashboard_v3/controllers/report/report_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/orders_report_section.dart';
import '../widgets/product_report_section.dart';
import '../widgets/salesman_report_section.dart';

class AllReportsMobile extends StatelessWidget {
  const AllReportsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController());

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // All report sections stacked vertically with smaller spacing
              const ProductReportSection(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const OrderReportSection(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const SalesmanReportSection(),
            ],
          ),
        ),
      ),
    );
  }
}
