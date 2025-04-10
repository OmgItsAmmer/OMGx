import 'package:admin_dashboard_v3/controllers/report/report_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/orders_report_section.dart';
import '../widgets/product_report_section.dart';
import '../widgets/sales_report_section.dart';

class AllReportsDesktop extends StatelessWidget {
  const AllReportsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
     Get.put(ReportController());

    return  Expanded(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              Text('Reports',style: Theme.of(context).textTheme.headlineMedium ,),
              const SizedBox(height: TSizes.spaceBtwSections,),
              const ProductReportSection(),
              const SizedBox(height: TSizes.spaceBtwSections,),
              const OrderReportSection(),
              const SizedBox(height: TSizes.spaceBtwSections,),
              const SalesReportSection(),


            ],
        ),),
      ),
    ));
  }
}






