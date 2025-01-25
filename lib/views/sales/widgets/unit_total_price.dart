import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/validators/validation.dart';

class UnitTotalPrice extends StatelessWidget {
  const UnitTotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

    return Form(
      key: salesController.addUnitTotalKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
                width: double.infinity  ,
              //  height: 60,
                child: TRoundedContainer(
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
                      salesController.selectedUnit.value = value ?? UnitType.Unit;
                    },
                  ),
                )
            
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems,),
          Expanded(
            child: SizedBox(
              width: double.infinity  ,
            
              //  height: 80,
              child: Obx(
                () => TextFormField(
                  validator: (value)=> TValidator.validateEmptyText('Total Price',value),
                  controller: salesController.totalPrice.value,
                  decoration: const InputDecoration(labelText: 'Total Price'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                    ),
                  ],


                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
