import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/report/report_controller.dart';
import '../../../../utils/constants/sizes.dart';

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
