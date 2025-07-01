import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddAccountBookDialog extends StatelessWidget {
  final bool isEditing;

  const AddAccountBookDialog({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final controller = AccountBookController.instance;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing
                        ? 'Edit Account Book Entry'
                        : 'Add Account Book Entry',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              Form(
                key: controller.accountBookFormKey,
                child: Column(
                  children: [
                    // Entity Type and Transaction Type Row
                    Row(
                      children: [
                        // Entity Type Dropdown
                        Expanded(
                          child: Obx(() => DropdownButtonFormField<EntityType>(
                                value: controller.selectedEntityType.value,
                                decoration: const InputDecoration(
                                  labelText: 'Entity Type *',
                                  prefixIcon: Icon(Iconsax.category),
                                ),
                                validator: (value) => value == null
                                    ? 'Please select entity type'
                                    : null,
                                items: EntityType.values
                                    .map((type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(type
                                              .toString()
                                              .split('.')
                                              .last
                                              .capitalize!),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedEntityType.value = value;
                                  }
                                },
                              )),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),

                        // Transaction Type Dropdown
                        Expanded(
                          child: Obx(() =>
                              DropdownButtonFormField<TransactionType>(
                                value: controller.selectedTransactionType.value,
                                decoration: const InputDecoration(
                                  labelText: 'Transaction Type *',
                                  prefixIcon:
                                      Icon(Iconsax.arrow_swap_horizontal),
                                ),
                                validator: (value) => value == null
                                    ? 'Please select transaction type'
                                    : null,
                                items: TransactionType.values
                                    .map((type) => DropdownMenuItem(
                                          value: type,
                                          child: Row(
                                            children: [
                                              Icon(
                                                type == TransactionType.buy
                                                    ? Iconsax.arrow_down_1
                                                    : Iconsax.arrow_up_3,
                                                size: 16,
                                                color:
                                                    type == TransactionType.buy
                                                        ? TColors.success
                                                        : TColors.error,
                                              ),
                                              const SizedBox(width: TSizes.xs),
                                              Text(type == TransactionType.buy
                                                  ? 'Incoming'
                                                  : 'Outgoing'),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedTransactionType.value =
                                        value;
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Entity ID and Entity Name Row
                    Row(
                      children: [
                        // Entity ID
                        Expanded(
                          child: TextFormField(
                            controller: controller.entityIdController,
                            decoration: const InputDecoration(
                              labelText: 'Entity ID *',
                              prefixIcon: Icon(Iconsax.hashtag_1),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'Entity ID', value),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),

                        // Entity Name
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: controller.entityNameController,
                            decoration: const InputDecoration(
                              labelText: 'Entity Name *',
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'Entity Name', value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Amount and Date Row
                    Row(
                      children: [
                        // Amount
                        Expanded(
                          child: TextFormField(
                            controller: controller.amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount *',
                              prefixIcon: Icon(Iconsax.dollar_circle),
                              prefixText: '\$ ',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Amount must be greater than 0';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),

                        // Transaction Date
                        Expanded(
                          child: Obx(() => TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Transaction Date *',
                                  prefixIcon: Icon(Iconsax.calendar),
                                ),
                                readOnly: true,
                                controller: TextEditingController(
                                  text: controller.selectedTransactionDate.value
                                      .toString()
                                      .split(' ')[0],
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: controller
                                        .selectedTransactionDate.value,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    controller.selectedTransactionDate.value =
                                        date;
                                  }
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please select date'
                                        : null,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Description
                    TextFormField(
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        prefixIcon: Icon(Iconsax.note),
                      ),
                      validator: (value) =>
                          TValidator.validateEmptyText('Description', value),
                      maxLines: 3,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Reference (Optional)
                    TextFormField(
                      controller: controller.referenceController,
                      decoration: const InputDecoration(
                        labelText: 'Reference (Optional)',
                        prefixIcon: Icon(Iconsax.receipt_item),
                        hintText: 'Invoice number, receipt number, etc.',
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Obx(() => ElevatedButton(
                              onPressed: controller.isUpdating.value
                                  ? null
                                  : () async {
                                      if (isEditing) {
                                        await controller.updateAccountBookEntry(
                                          controller.selectedEntry.value
                                              .accountBookId!,
                                        );
                                      } else {
                                        await controller
                                            .insertAccountBookEntry();
                                      }

                                      if (!controller.isUpdating.value) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                              child: controller.isUpdating.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Text(
                                      isEditing ? 'Update Entry' : 'Add Entry'),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
