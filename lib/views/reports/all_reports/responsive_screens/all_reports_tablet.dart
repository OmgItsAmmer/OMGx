import 'package:ecommerce_dashboard/controllers/report/report_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/orders_report_section.dart';
import '../widgets/product_report_section.dart';
import '../widgets/salesman_report_section.dart';

class AllReportsTablet extends StatelessWidget {
  const AllReportsTablet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController());

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // For tablet, we'll use the same layout as desktop but with adjusted padding
              // to better fit the tablet form factor
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
