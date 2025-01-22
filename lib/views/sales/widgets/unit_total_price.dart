import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class UnitTotalPrice extends StatelessWidget {
  const UnitTotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(

      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 80,

            child: TextFormField(
              decoration:  const InputDecoration(labelText: 'Unit'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems,),
          SizedBox(
            width: 200,
            height: 80,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Total Price'),
              style: Theme.of(context).textTheme.bodyMedium,

            ),
          )
        ],
      ),
    );
  }
}
