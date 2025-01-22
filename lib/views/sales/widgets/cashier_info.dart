import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesCashierInfo extends StatelessWidget {
  const SalesCashierInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cashier Information',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            //Sale Type
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

            //Date

      
            //Branch
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
      
          ],
        ),
      ),
    );
  }
}
