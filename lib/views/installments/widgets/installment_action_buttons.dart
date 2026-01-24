import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/installments/installments_controller.dart';
import '../../../utils/constants/colors.dart';

class InstallmentActionButtons extends StatelessWidget {
  const InstallmentActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController =
        Get.find<InstallmentController>();

    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  installmentController.generatePlan();
                },
                child: Text(
                  'Generate Plan',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                )),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () {
                  installmentController.clearAllFields();
                },
                child: Text(
                  'Reset',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.black),
                )),
          )
        ],
      ),
    );
  }
}
