import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../sales/widgets/sale_customer_info.dart';
import '../table/installment_table.dart';
import '../widgets/charges_form.dart';
import '../widgets/advance_info.dart';
import '../widgets/duration_info.dart';
import '../widgets/installment_action_buttons.dart';
import '../widgets/installment_footer_buttons.dart';

class InstallmentDesktop extends StatelessWidget {
  const InstallmentDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TRoundedContainer(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: SaleCustomerInfo(
                      //     suggestionsList: [
                      //       'Muhammad Saeed Sarwar',
                      //       'Ammer Saeed',
                      //       'Muhid Saeed'
                      //     ],
                      //     hintText: 'Customer Name',
                      //   ),
                      // ),
                      SizedBox(
                        width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: SaleCustomerInfo(
                      //     suggestionsList: [
                      //       'Muhammad Saeed Sarwar',
                      //       'Ammer Saeed',
                      //       'Muhid Saeed'
                      //     ],
                      //     hintText: 'Gurrante 1',
                      //   ),
                      // ),
                      SizedBox(
                        width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: SaleCustomerInfo(
                      //     suggestionsList: [
                      //       'Muhammad Saeed Sarwar',
                      //       'Ammer Saeed',
                      //       'Muhid Saeed'
                      //     ],
                      //     hintText: 'Gurrante 2',
                      //   ),
                      // ),
                      SizedBox(
                        width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Installment Setup',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Charges
                          Expanded(child: SizedBox(
                            //  height: 530,
                              child: ChargesForm())),

                          SizedBox(width: TSizes.spaceBtwSections,),

                          // Duration / Time

                          Expanded(child: DurationInfo()),

                          SizedBox(width: TSizes.spaceBtwSections,),
                          // Generate Button
                          Expanded(
                            child: Column(
                              children: [
                                AdvanceInfo(),
                            
                                SizedBox(height: TSizes.spaceBtwSections,),
                            
                            
                                InstallmentActionButtons()
                              ],
                            ),
                          ),





                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections,),

                 TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Tab;e Header
                      Text(
                        'Installment Plan',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),
                      //Table
                      const InstallmentTable(),


                    ],

                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections,),
                 const InstallmentFooterButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

