import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AdvanceInfo extends StatelessWidget {
  const AdvanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          const SizedBox(height: TSizes.spaceBtwItems,),
          // bill amount
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Frequency in month'),

              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Other Charges'),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Payable Ex-Margin'),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Payable INCL-Margin'),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),


        ],

      ),

    );
  }
}
