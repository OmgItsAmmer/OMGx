import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/sales/sales_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/validators/validation.dart';

class SalesCashierInfo extends StatelessWidget {
  const SalesCashierInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();


    return  Form(
      key:  salesController.cashierFormKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
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
            //Admin Name
            SizedBox(
              width: double.infinity,
              child: Obx(
                  () => TextFormField(
                    onChanged: (value){

                    },
                    readOnly: true,
                  // initialValue: 'Ammer',
                    controller: salesController.cashierNameController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Admin Name', value),
                    decoration: const InputDecoration(labelText: 'Admin'),
                    style: Theme.of(context).textTheme.bodyMedium,

                  ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems,),




            //Sale Type
            TRoundedContainer(

              // padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Obx(
                ()=> DropdownButton<SaleType>(
                  padding: EdgeInsets.zero, // Remove all padding
                  value: salesController.selectedSaleType.value, // Set the initial value from the controller
                  underline: const SizedBox.shrink(), // Remove the default underline
                  isExpanded: true, // Ensures proper alignment and resizing
                  isDense: true, // Makes the dropdown less tall vertically
                  items: SaleType.values.map((SaleType sale) {
                    return DropdownMenuItem<SaleType>(
                      value: sale,
                      child: Row(
                        children: [
                          const Icon(Iconsax.box, size: 18), // Add your desired icon here
                          const SizedBox(width: 8), // Space between icon and text
                          Text(
                            sale.name.capitalize.toString(),
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (SaleType? value) {
                    if (value != null) {
                      // Update the salesController.selectedSaleType value with the selected SaleType
                      salesController.selectedSaleType.value = value;


                      //salesController.updateUIBasedOnSaleType(value);
                    }
                  },
                ),
              ),

            ),

            const SizedBox(height: TSizes.spaceBtwItems,),

            Row(
              children: [
                Expanded(
                  child:Obx(
                () => OutlinedButton(

                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:  const Text('Select Date'),
                              content:  SizedBox(
                                width: 300,
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SfDateRangePicker(
                                      // onSelectionChanged: (val) {

                                      // },
                                      onSubmit: (val) {
                                        // Cast val to DateTime
                                        DateTime selectedDate = val as DateTime;

                                        // Format the selected DateTime to dd/MM/yyyy format
                                        //String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

                                        // Store the formatted date in salesController.selectedDate.value
                                        salesController.selectedDate.value = selectedDate;


                                        // Close the dialog
                                        Navigator.of(context).pop();
                                      },


                                      onCancel: (){
                                        Navigator.of(context).pop(); // Close the dialog

                                      },
                                      showActionButtons: true,
                                    )



                                  ],
                                ),
                              ),
                              actions: [



                              ],
                            );
                          },
                        );
                      },
                      child:  Text(
                        DateFormat('dd/MM/yyyy').format(salesController.selectedDate.value),
                      )
                    ),
                  ),

                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
