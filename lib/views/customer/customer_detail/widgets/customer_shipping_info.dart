import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../profile/widgets/profile_menu.dart';

class CustomerShippingInfo extends StatelessWidget {
  const CustomerShippingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Shipping Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          TProfilemenu(
            title: "Name",
            value: 'Ammer Saeed',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),

          TProfilemenu(
            title: "City",
            value: 'Pakistan',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),

          TProfilemenu(
            title: "Phone Number",
            value: '03236508184',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Address",
            value: 'Chishtia park colony',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
        ],
      ),
    );
  }
}