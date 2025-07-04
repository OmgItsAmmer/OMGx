import 'package:ecommerce_dashboard/controllers/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class SalesmanReportSection extends StatelessWidget {
  const SalesmanReportSection({
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
          Text('Salesman', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Wrap(
            clipBehavior: Clip.none,
            spacing: TSizes.spaceBtwItems,
            runSpacing: TSizes.spaceBtwItems,
            children: [
              // HoverableCard(
              //   text: 'All Products Report',
              //   animation: TImages.docerAnimation,
              //   onPressed: () {
              //     // Existing functionality
              //   },
              // ),

              HoverableCard(
                text: 'Salesman',
                animation: TImages.docerAnimation,
                onPressed: () {
                  reportController.showDateRangePickerDialogSalesman(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
