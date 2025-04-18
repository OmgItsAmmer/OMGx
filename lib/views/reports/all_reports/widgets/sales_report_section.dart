import 'package:admin_dashboard_v3/controllers/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class SalesReportSection extends StatelessWidget {
  const SalesReportSection({
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
          Text('Sales', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Wrap(
            spacing: TSizes.spaceBtwItems,
            runSpacing: TSizes.spaceBtwItems,
            children: [
              HoverableCard(
                text: 'All Products Report',
                animation: TImages.docerAnimation,
                onPressed: () {
                  // Existing functionality
                },
              ),
              HoverableCard(
                text: 'Simple P&L Report',
                animation: TImages.docerAnimation,
                onPressed: () {
                  reportController.showDateRangePickerDialogSimplePnL(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}