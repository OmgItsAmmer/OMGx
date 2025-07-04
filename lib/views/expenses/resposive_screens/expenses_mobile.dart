import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/heading/section_heading.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/expenses/expense_controller.dart';
import '../../../utils/validators/validation.dart';
import '../table/expense_table.dart';

class ExpensesMobile extends StatelessWidget {
  const ExpensesMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.put(ExpenseController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const TSectionHeading(title: 'Expenses'),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Input Form - Stacked vertically for mobile
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description field
                  TextFormField(
                    validator: (value) =>
                        TValidator.validateEmptyText('Description', value),
                    controller: expenseController.description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Amount field
                  TextFormField(
                    validator: (value) =>
                        TValidator.validateEmptyText('Amount', value),
                    controller: expenseController.amount,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                            r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Add button - Full width for mobile
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        expenseController.addExpense();
                      },
                      icon: const Icon(Iconsax.add, color: TColors.white),
                      label: const Text('Add Expense'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: TColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Expenses Table
            const TRoundedContainer(
                padding: EdgeInsets.all(TSizes.sm), child: ExpenseTable()),
          ],
        ),
      ),
    );
  }
}
