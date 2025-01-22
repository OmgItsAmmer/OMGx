import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/enums.dart';

class SalesSalemanInfo extends StatelessWidget {
  const SalesSalemanInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salesman Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          DropdownButton<SaleType>(
            value: SaleType.Cash,
            items: SaleType.values.map((SaleType saletype) {
              return DropdownMenuItem<SaleType>(
                value: saletype,
                child: Text(
                  saletype.name.capitalize.toString(),
                  style: const TextStyle(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              // Add your onChanged logic here
            },
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          DropdownButton<SaleType>(
            value: SaleType.Cash,
            items: SaleType.values.map((SaleType saletype) {
              return DropdownMenuItem<SaleType>(
                value: saletype,
                child: Text(
                  saletype.name.capitalize.toString(),
                  style: const TextStyle(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              // Add your onChanged logic here
            },
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          DropdownButton<SaleType>(
            value: SaleType.Cash,
            items: SaleType.values.map((SaleType saletype) {
              return DropdownMenuItem<SaleType>(
                value: saletype,
                child: Text(
                  saletype.name.capitalize.toString(),
                  style: const TextStyle(),
                ),
              );
            }).toList(),
            onChanged: (value) {
              // Add your onChanged logic here
            },
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
        ],
      ),
    );
  }
}
