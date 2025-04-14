import 'package:admin_dashboard_v3/controllers/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class OrderReportSection extends StatelessWidget {
  const OrderReportSection({
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
          Text('Orders/Sales',style: Theme.of(context).textTheme.headlineMedium ,),
          const SizedBox(height: TSizes.spaceBtwSections,),
          Wrap(
            spacing: TSizes.spaceBtwItems, // Horizontal space between items
            runSpacing: TSizes.spaceBtwItems, // Vertical space between rows
            children: [
              HoverableCard(
                text: 'Monthly Item Sale Report',
                animation: TImages.docerAnimation,
                onPressed: (){
                   reportController.openMonthYearPicker(context);


                },

              ),

              HoverableCard(
                text: 'Salesman',
                animation: TImages.docerAnimation,
                onPressed: (){
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