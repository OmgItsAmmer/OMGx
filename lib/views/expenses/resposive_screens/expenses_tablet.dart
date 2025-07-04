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

class ExpensesTablet extends StatelessWidget {
  const ExpensesTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.put(ExpenseController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Heading
            const TSectionHeading(title: 'Expenses'),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Input Form - Row layout but with adjusted proportions for tablet
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description field
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          validator: (value) => TValidator.validateEmptyText(
                              'Description', value),
                          controller: expenseController.description,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      const SizedBox(width: TSizes.spaceBtwItems),

                      // Amount field
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          validator: (value) =>
                              TValidator.validateEmptyText('Amount', value),
                          controller: expenseController.amount,
                          decoration:
                              const InputDecoration(labelText: 'Amount'),
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Add button - Right aligned for tablet
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 60,
                      width: 200,
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Expenses Table
            const TRoundedContainer(
                padding: EdgeInsets.all(TSizes.md), child: ExpenseTable()),
          ],
        ),
      ),
    );
  }
}
