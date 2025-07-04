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

class ExpensesDesktop extends StatelessWidget {
  const ExpensesDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseController = Get.put(ExpenseController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Table Heading
            const TSectionHeading(title: 'Expenses'),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        validator: (value) =>
                            TValidator.validateEmptyText('Description', value),
                        controller: expenseController.description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        validator: (value) =>
                            TValidator.validateEmptyText('Amount', value),
                        controller: expenseController.amount,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        style: Theme.of(context).textTheme.bodyMedium,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(
                                r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  TRoundedContainer(
                      onTap: () {
                        expenseController.addExpense();
                      },
                      backgroundColor: TColors.primary,
                      child: const Icon(
                        Iconsax.add,
                        color: TColors.white,
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            //TABLE(Rounded Container)
            const TRoundedContainer(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: ExpenseTable()),
          ],
        ),
      ),
    );
  }
}
