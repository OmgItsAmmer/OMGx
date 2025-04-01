import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/installments/installments_controller.dart';
import '../../../utils/validators/validation.dart';

class AdvanceInfo extends StatelessWidget {
  const AdvanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(TSizes.defaultSpace), // Add const for optimization
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.spaceBtwItems),

          // Frequency in month
          _buildInputField(
            context: context,
            label: 'Frequency in month',
            controller: installmentController.frequencyInMonth,
            onChanged: (_) => installmentController.updateINCLExMargin(),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Other Charges
          _buildInputField(
            context: context,
            label: 'Other Charges',
            controller: installmentController.otherCharges,
            onChanged: (_) => installmentController.updateINCLExMargin(),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Payable Ex-Margin (Read-Only)
          _buildReadOnlyField(
            context: context,
            label: 'Payable Ex-Margin',
            controller: installmentController.payableExMargin.value,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Payable INCL-Margin (Read-Only)
          _buildReadOnlyField(
            context: context,
            label: 'Payable INCL-Margin',
            controller: installmentController.payableINCLMargin.value,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
        ],
      ),
    );
  }

  // Helper for standard text fields
  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(labelText: label),
        maxLines: 1,
        controller: controller,
        validator: (value) => TValidator.validateEmptyText(label, value),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d{0,2})?$')),
        ],
        onChanged: onChanged,
      ),
    );
  }

  // Helper for read-only fields
  Widget _buildReadOnlyField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(labelText: label),
        maxLines: 1,
        controller: controller,
        readOnly: true,
      ),
    );
  }
}
