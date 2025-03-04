import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/validators/validation.dart';

class SaleActionButtons extends StatelessWidget {
  const SaleActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OutlinedButton(
            onPressed: () {},
            child: Text(
              'Discard',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  if (salesController.selectedSaleType == SaleType.Installment) {
                    installmentController.billAmount.value.text = salesController.netTotal.value.toString();
                    installmentController.installmentPlans.clear();
                    Get.toNamed(TRoutes.installment );
                  } else {
                    Get.defaultDialog(
                      title: "CheckOut Details",
                      content: TRoundedContainer(
                        width: 400,
                       // height: 400,
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                try {
                                  // Parse the entered value (paidAmount) safely
                                  double paidAmount = double.tryParse(salesController.paidAmount.value.text) ?? 0.0;

                                  // Ensure paidAmount does not exceed netTotal
                                  if (paidAmount > salesController.netTotal.value) {
                                    // Reset paidAmount and remainingAmount to default
                                    salesController.paidAmount.text = "0.0";
                                    salesController.remainingAmount.value.text = salesController.netTotal.value.toStringAsFixed(2);

                                    // Optionally show a message to the user
                                    TLoader.errorSnackBar(
                                      title: "Invalid Payment",
                                      message: "Paid amount cannot exceed the total amount.",
                                    );
                                  } else {
                                    // Update remainingAmount with the valid paidAmount
                                    salesController.remainingAmount.value.text =
                                        (salesController.netTotal.value - paidAmount).toStringAsFixed(2);
                                  }
                                } catch (e) {
                                  print("Error parsing double: $e");
                                  // Reset remainingAmount to default value
                                  salesController.remainingAmount.value.text = "0.00";
                                }
                              },

                              controller: salesController.paidAmount,
                              validator: (value) =>
                                  TValidator.validateEmptyText('Paid Amount', value),
                              decoration: const InputDecoration(labelText: 'Paid Amount'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                                ),
                              ],
                            ),
                        
                            const SizedBox(height: TSizes.spaceBtwSections,),
                            Obx(
                            () => TextFormField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                                readOnly: true,
                                controller: salesController.remainingAmount.value,
                                validator: (value) =>
                                    TValidator.validateEmptyText('Remaining Amount', value),
                                decoration: const InputDecoration(labelText: 'Remaining Amount'),
                                style: Theme.of(context).textTheme.bodyMedium,
                        
                              ),
                            ),
                            
                            const SizedBox(height: TSizes.spaceBtwSections),
                             Row(
                              children: [
                                Expanded(
                                    flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 0,
                                    child: SizedBox()),
                                Expanded(child: OutlinedButton(onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                    child: Text('Cancel',style: Theme.of(context).textTheme.bodyMedium,))),
                                const SizedBox(width: TSizes.spaceBtwInputFields  ,),
                                Expanded(child: ElevatedButton(onPressed: () {
                                  salesController.checkOut();
                                  Navigator.of(context).pop(); // Close the dialog

                                }, child: Text('Confirm',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),))),
                              ],
                            )
                          ],
                        ),
                      ),
                     
                    );
                  }
                },
                child: Text(
                  'Checkout',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                ))),
      ],
    );
  }
}
