import 'package:admin_dashboard_v3/Models/entity/entity_model.dart';
import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/validators/validation.dart';
import 'package:admin_dashboard_v3/common/widgets/dropdown_search/enhanced_autocomplete.dart';
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
                                    .where((type) =>
                                        type !=
                                        EntityType.user) // Exclude user type
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

                    // Entity Selection Autocomplete
                    Obx(() => Container(
                          child: controller.isLoadingEntities.value
                              ? Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: TColors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Loading ${controller.selectedEntityType.value.toString().split('.').last.toLowerCase()}s...',
                                        style:
                                            const TextStyle(color: TColors.darkGrey),
                                      ),
                                    ],
                                  ),
                                )
                              : controller.availableEntities.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: TColors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Iconsax.info_circle,
                                              color: TColors.warning, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            'No ${controller.selectedEntityType.value.toString().split('.').last.toLowerCase()}s found',
                                            style: const TextStyle(
                                                color: TColors.darkGrey),
                                          ),
                                        ],
                                      ),
                                    )
                                  : EnhancedAutocomplete<EntityModel>(
                                      labelText:
                                          '${controller.selectedEntityType.value.toString().split('.').last.capitalize!} *',
                                      hintText:
                                          'Search and select a ${controller.selectedEntityType.value.toString().split('.').last.toLowerCase()}',
                                      displayStringForOption: (entity) {
                                        String display = entity.name;
                                        if (entity.phoneNumber != null &&
                                            entity.phoneNumber!.isNotEmpty) {
                                          display += ' - ${entity.phoneNumber}';
                                        }
                                        return display;
                                      },
                                      options: controller.availableEntities,
                                      externalController:
                                          controller.entitySearchController,
                                      showOptionsOnFocus: true,
                                      getItemId: (entity) => entity.id,
                                      onSelected: (entity) {
                                        controller.onEntitySelected(entity);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a ${controller.selectedEntityType.value.toString().split('.').last.toLowerCase()}';
                                        }
                                        // Check if the entered value matches any entity
                                        bool isValid = controller
                                            .availableEntities
                                            .any((entity) {
                                          String display = entity.name;
                                          if (entity.phoneNumber != null &&
                                              entity.phoneNumber!.isNotEmpty) {
                                            display += ' - ${entity.phoneNumber}';
                                          }
                                          return display.toLowerCase() ==
                                              value.toLowerCase();
                                        });
                                        if (!isValid) {
                                          return 'Please select a valid ${controller.selectedEntityType.value.toString().split('.').last.toLowerCase()} from the list';
                                        }
                                        return null;
                                      },
                                    ),
                        )),
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
                              prefixIcon: Icon(Iconsax.money),
                              prefixText: 'Rs ',
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
