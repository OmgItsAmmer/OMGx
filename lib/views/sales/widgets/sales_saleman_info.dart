import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';

class SalesSalemanInfo extends StatelessWidget {
  const SalesSalemanInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,

      padding: const EdgeInsets.all(TSizes.defaultSpace),
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
          TRoundedContainer(
            // padding: EdgeInsets.all(TSizes.defaultSpace),
            child: DropdownButton<UnitType>(
              padding: EdgeInsets.zero, // Remove all padding
              value: UnitType.Unit,
              underline: SizedBox.shrink(), // Remove the default underline
              isExpanded: true, // Ensures proper alignment and resizing
              isDense: true, // Makes the dropdown less tall vertically
              items: UnitType.values.map((UnitType unit) {
                return DropdownMenuItem<UnitType>(
                  value: unit,
                  child: Row(
                    children: [
                      const Icon(Iconsax.box, size: 18), // Add your desired icon here
                      const SizedBox(width: 8), // Space between icon and text
                      Text(
                        unit.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
              //  salesController.selectedUnit.value = value ?? UnitType.Unit;
              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TRoundedContainer(
            // padding: EdgeInsets.all(TSizes.defaultSpace),
            child: DropdownButton<UnitType>(
              padding: EdgeInsets.zero, // Remove all padding
              value: UnitType.Unit,
              underline: SizedBox.shrink(), // Remove the default underline
              isExpanded: true, // Ensures proper alignment and resizing
              isDense: true, // Makes the dropdown less tall vertically
              items: UnitType.values.map((UnitType unit) {
                return DropdownMenuItem<UnitType>(
                  value: unit,
                  child: Row(
                    children: [
                      const Icon(Iconsax.box, size: 18), // Add your desired icon here
                      const SizedBox(width: 8), // Space between icon and text
                      Text(
                        unit.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
              //  salesController.selectedUnit.value = value ?? UnitType.Unit;
              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TRoundedContainer(
            // padding: EdgeInsets.all(TSizes.defaultSpace),
            child: DropdownButton<UnitType>(
              padding: EdgeInsets.zero, // Remove all padding
              value: UnitType.Unit,
              underline: SizedBox.shrink(), // Remove the default underline
              isExpanded: true, // Ensures proper alignment and resizing
              isDense: true, // Makes the dropdown less tall vertically
              items: UnitType.values.map((UnitType unit) {
                return DropdownMenuItem<UnitType>(
                  value: unit,
                  child: Row(
                    children: [
                      const Icon(Iconsax.box, size: 18), // Add your desired icon here
                      const SizedBox(width: 8), // Space between icon and text
                      Text(
                        unit.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
             //   salesController.selectedUnit.value = value ?? UnitType.Unit;
              },
            ),
          ),
       //   const SizedBox(height: TSizes.spaceBtwItems,),
        ],
      ),
    );
  }
}
