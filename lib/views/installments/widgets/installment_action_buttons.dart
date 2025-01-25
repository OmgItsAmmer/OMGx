import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class InstallmentActionButtons extends StatelessWidget {
  const InstallmentActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(onPressed: (){}, child: Text('Generate Plan',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),)),

          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: OutlinedButton(onPressed: (){}, child: Text('Clear',style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.black    ),)),

          )

        ],
      ),

    );
  }
}
