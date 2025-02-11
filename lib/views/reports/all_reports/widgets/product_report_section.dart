import 'package:admin_dashboard_v3/Models/installments/installemt_plan_model.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/installments/installment_table_model/installment_table_model.dart';
import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../specific_reports/installment_plans/installment_plan_report.dart';

class ProductReportSection extends StatelessWidget {
  const ProductReportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products',style: Theme.of(context).textTheme.headlineMedium ,),
          const SizedBox(height: TSizes.spaceBtwSections,),
          Wrap(
            spacing: TSizes.spaceBtwItems, // Horizontal space between items
            runSpacing: TSizes.spaceBtwItems, // Vertical space between rows
            children: [
              HoverableCard(
                text: 'All Products Report',
                animation: TImages.docerAnimation,
                onPressed: (){
                  Get.to(()=>InstallmentReportPage(
                    installmentPlans: [InstallmentTableModel.empty()],
                    cashierName: 'Ammer',
                    companyName: 'OMGz',
                    branchName: 'MAIN',
                  ));
                },

              ),

            ],
          ),
        ],
      ),
    );
  }
}