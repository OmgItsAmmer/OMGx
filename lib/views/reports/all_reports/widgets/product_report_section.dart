import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/installments/installment_table_model/installment_table_model.dart';
import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/report/report_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../../specific_reports/installment_plans/installment_plan_report.dart';

class ProductReportSection extends StatelessWidget {
  const ProductReportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.find<ReportController>();
  
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          Wrap(
             clipBehavior: Clip.none,
            spacing: TSizes.spaceBtwItems, // Horizontal space between items
            runSpacing: TSizes.spaceBtwItems, // Vertical space between rows
            children: [
              HoverableCard(
                text: 'Stock Summary Report',
                animation: TImages.docerAnimation,
                onPressed: () {
                  reportController.getStockSummaryReport();

                },
              ),
            
             
            ],
          ),
        ],
      ),
    );
  }
}
