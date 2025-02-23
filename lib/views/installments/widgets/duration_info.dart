import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../controllers/installments/installments_controller.dart';

class DurationInfo extends StatelessWidget {
  const DurationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace/2 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity  ,
            child: TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Obx(
                () => DropdownButton<DurationType>(
                  value: installmentController.durationController.value,
                  underline: const SizedBox.shrink(), // Remove the default underline
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
                   installmentController.durationController.value = value ?? DurationType.Duration;
                  },
                ),
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

                  SfDateRangePicker(

                    onSelectionChanged: (val) {
                      // Extract the selected date from the DateRangePickerSelectionChangedArgs
                      // For single date selection
                      DateTime? selectedDateTime = val.value as DateTime?;

                      if (selectedDateTime != null) {
                        // Format the selected date as dd/MM/yyyy
                        String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDateTime);

                        // Store the formatted date in the variable
                       installmentController.selectedDate = selectedDateTime;
                      // TLoader.successSnackBar(title: installmentController.selectedDate.toString());

                        // Now you can use this selectedDate variable to store it in Supabase
                        // Example: You can call a function to store this in Supabase
                        // saveToSupabase(formattedDate);  // Replace with your Supabase function
                      } else {
                        // Handle case if no date is selected
                        print('No date selected');
                      }
                    },

                  ),
                ],
              )),






        ],

      ),

    );
  }
}
