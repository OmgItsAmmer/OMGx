import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DurationInfo extends StatelessWidget {
  const DurationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace/2 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity  ,
            child: TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: DropdownButton<DurationType>(
                value: DurationType.Duration,
                underline: SizedBox.shrink(), // Remove the default underline
                isExpanded: true, // Ensures proper alignment and resizing
                items: DurationType.values.map((DurationType duration) {
                  return DropdownMenuItem<DurationType>(
                    value: duration,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18), // Add your desired icon here
                        const SizedBox(width: 8), // Space between icon and text
                        Text(
                          duration.name.capitalize.toString(),
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  // Add your onChanged logic here
                },
              ),
            )

          ),


          const SizedBox(height: TSizes.spaceBtwInputFields,),

          //DatePicker

          TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Installment Date',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  SfDateRangePicker(  ),
                ],
              )),






        ],

      ),

    );
  }
}
