import 'package:ecommerce_dashboard/Models/purchase/purchase_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/purchase/purchase_controller.dart';

class PurchaseTransaction extends StatelessWidget {
  const PurchaseTransaction({super.key, required this.purchaseModel});
  final PurchaseModel purchaseModel;

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //Adjust as per your needs
          Row(
            children: [
              Expanded(
                  flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Row(
                    children: [
                      const TRoundedImage(
                        imageurl: TImages.paypal,
                        isNetworkImage: false,
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: Theme.of(context).textTheme.titleLarge,
                          ), //TODO add payment method to database
                          //Adjust your payment Method Fee if any
                          Text(
                            'Cash/Bank Transfer',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ))
                    ],
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  //Adjust your payment Method Fee if any
                  Text(
                    DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(purchaseModel.purchaseDate)),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )),
              Expanded(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remaining Amount',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Obx(
                          () => Text(
                            (purchaseController.remainingAmount.value)
                                .toStringAsFixed(2),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    TRoundedContainer(
                        width: 60,
                        height: 60,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final remaining =
                                  purchaseController.remainingAmount.value;

                              return AlertDialog(
                                title: Text(
                                    remaining == 0 ? 'Paid' : 'Update Value'),
                                content: remaining == 0
                                    ? const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            'This purchase is already paid.',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      )
                                    : Obx(
                                        () {
                                          // Check if the newPaidAmount exceeds the remainingAmount
                                          final newValue = double.tryParse(
                                                  purchaseController
                                                      .newPaidAmount.text) ??
                                              0.0;
                                          if (newValue >
                                              purchaseController
                                                  .remainingAmount.value) {
                                            // Reset the newPaidAmount to 0.00
                                            purchaseController
                                                .newPaidAmount.text = '0.00';
                                            // Show error snackbar
                                            TLoaders.errorSnackBar(
                                              title: 'Invalid Amount',
                                              message:
                                                  'Amount cannot exceed remaining amount',
                                            );
                                          }

                                          return TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a value';
                                              }
                                              final newValue =
                                                  double.tryParse(value);
                                              if (newValue == null) {
                                                return 'Please enter a valid number';
                                              }
                                              if (newValue >
                                                  purchaseController
                                                      .remainingAmount.value) {
                                                return 'Amount cannot exceed remaining amount';
                                              }
                                              return null;
                                            },
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*$')),
                                            ],
                                            maxLines: 1,
                                            controller: purchaseController
                                                .newPaidAmount,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter new value',
                                              border: OutlineInputBorder(),
                                            ),
                                          );
                                        },
                                      ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  if (remaining >
                                      0) // Only show Update button if there's remaining amount
                                    ElevatedButton(
                                      onPressed: () async {
                                        final newAmount = double.tryParse(
                                            purchaseController
                                                .newPaidAmount.text);
                                        if (newAmount != null &&
                                            newAmount > 0 &&
                                            newAmount <=
                                                purchaseController
                                                    .remainingAmount.value) {
                                          await purchaseController
                                              .updatePurchasePaidAmount(
                                                  purchaseModel.purchaseId,
                                                  newAmount);
                                          purchaseController.newPaidAmount
                                              .clear();
                                          Navigator.of(context).pop();
                                        } else {
                                          TLoaders.errorSnackBar(
                                            title: 'Invalid Amount',
                                            message:
                                                'Please enter a valid amount within the remaining balance',
                                          );
                                        }
                                      },
                                      child: const Text('Update'),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Iconsax.money_add,
                          color: TColors.primary,
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
