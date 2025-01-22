import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BasicInfo extends StatelessWidget {
  const BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
       // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information',style: Theme.of(context).textTheme.bodyLarge,),
          const SizedBox(height: TSizes.spaceBtwSections,),
          TextFormField(
            maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          const SizedBox(height: TSizes.spaceBtwSections,),

          TextFormField(
            maxLines: 5,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
    );
  }
}
