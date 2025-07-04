import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/installments/installments_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/validators/validation.dart';

class ChargesForm extends StatelessWidget {
  const ChargesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController =
        Get.find<InstallmentController>();

    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(
          TSizes.defaultSpace), // Added const for optimization
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.spaceBtwItems),

          // Bill Amount (Read-Only)
          _buildReadOnlyField(
            context: context,
            label: 'Bill Amount',
            controller: installmentController.billAmount.value,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // No of Installments
          _buildInputField(
            context: context,
            label: 'No of Installments',
            controller: installmentController.NoOfInstallments,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // ADV/Down Payment
          _buildInputField(
            context: context,
            label: 'ADV/Down Payment',
            controller: installmentController.DownPayment,
            onChanged: (_) => installmentController.updateINCLExMargin(),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Document Charges
          _buildInputField(
            context: context,
            label: 'Document Charges',
            controller: installmentController.DocumentCharges,
            onChanged: (_) => installmentController.updateINCLExMargin(),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // MARGIN-%
          _buildInputField(
            context: context,
            label: 'MARGIN-%',
            controller: installmentController.margin,
            onChanged: (_) => installmentController.updateINCLExMargin(),
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // NOTE (Optional)
          _buildMultilineField(
            context: context,
            label: 'NOTE (Optional)',
            controller: installmentController.note,
          ),
        ],
      ),
    );
  }

  // Helper for input fields
  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    Function(String)? onChanged,
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

  // Helper for multiline fields
  Widget _buildMultilineField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(labelText: label),
        maxLines: 5,
        controller: controller,
      ),
    );
  }
}
