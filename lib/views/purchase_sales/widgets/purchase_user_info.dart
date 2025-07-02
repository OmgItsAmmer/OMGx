import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/validators/validation.dart';

class PurchaseUserInfo extends StatelessWidget {
  const PurchaseUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

    return Form(
      key: purchaseSalesController.userFormKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TCircularIcon(
                  icon: Iconsax.refresh,
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  color: TColors.primary,
                  onPressed: () {
                    // Reset user fields
                    purchaseSalesController.userNameController.value.clear();
                    purchaseSalesController.selectedDate.value = DateTime.now();

                    // Set a very short delay to ensure UI updates
                    Future.microtask(() {
                      if (purchaseSalesController.userFormKey.currentState !=
                          null) {
                        purchaseSalesController.update();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // User Name Field
            SizedBox(
              width: double.infinity,
              child: Obx(() => TextFormField(
                    controller:
                        purchaseSalesController.userNameController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('User Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      hintText: 'Enter user name',
                    ),
                  )),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Date Selection
            SizedBox(
              width: double.infinity,
              child: Obx(() => InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            purchaseSalesController.selectedDate.value ??
                                DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        purchaseSalesController.selectedDate.value = picked;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            purchaseSalesController.selectedDate.value != null
                                ? '${purchaseSalesController.selectedDate.value!.day}/${purchaseSalesController.selectedDate.value!.month}/${purchaseSalesController.selectedDate.value!.year}'
                                : 'Select Date',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(Iconsax.calendar, color: TColors.grey),
                        ],
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Information text
            Text(
              'Purchase entry by the current user on the selected date.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: TColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
