import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SaleActionButtons extends StatelessWidget {
  const SaleActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
     // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OutlinedButton(onPressed: (){}, child: Text('Discard',style: Theme.of(context).textTheme.bodyMedium,)),
        const SizedBox(width: TSizes.spaceBtwItems,),
        SizedBox(
            width: 100,
            child: ElevatedButton(onPressed: (){}, child: Text('Checkout',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),))),

      ],
    );
  }
}
