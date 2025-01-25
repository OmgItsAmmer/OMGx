import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ChargesForm extends StatelessWidget {
  const ChargesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: EdgeInsets.all(TSizes.defaultSpace),
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
              decoration: const InputDecoration(labelText: 'Bill Amount'),
              readOnly: true,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'No of Installments'),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'ADV/Down Payment'),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Document Charges'),
              maxLines: 1,
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'MARGIN(+)%'),
              maxLines: 1,
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'NOTE'),
              maxLines: 5,
            ),
          ),

        ],

      ),

    );
  }
}
