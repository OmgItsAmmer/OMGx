import 'package:ecommerce_dashboard/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../common/widgets/loaders/tloaders.dart';
import '../../../utils/validators/validation.dart';

class PurchaseUnitTotalPrice extends StatelessWidget {
  const PurchaseUnitTotalPrice({super.key, required this.totalPriceFocus});

  final FocusNode totalPriceFocus;

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

    return Form(
      key: purchaseSalesController.addUnitTotalKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
                width: double.infinity,
                child: Obx(() => TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Standard units dropdown
                          DropdownButtonHideUnderline(
                            child: DropdownButton<UnitType>(
                              onChanged: purchaseSalesController
                                      .isSerializedProduct.value
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        purchaseSalesController
                                            .selectedUnit.value = value;
                                        purchaseSalesController
                                            .calculateTotalPrice();
                                      }
                                    },
                              padding: EdgeInsets.zero,
                              value: purchaseSalesController.selectedUnit.value,
                              isExpanded: true,
                              isDense: true,
                              items: _buildDropdownItems(
                                  purchaseSalesController, context),
                            ),
                          ),

                          // Custom unit label (visible when custom unit is selected)
                          if (purchaseSalesController.selectedUnit.value ==
                                  UnitType.custom &&
                              purchaseSalesController
                                  .customUnitName.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Custom: ${purchaseSalesController.customUnitName.value}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ))),
          ),
          const SizedBox(
            width: TSizes.spaceBtwItems,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => TextFormField(
                  focusNode: totalPriceFocus,
                  validator: (value) =>
                      TValidator.validateEmptyText('Total Price', value),
                  controller: purchaseSalesController.totalPrice.value,
                  decoration: const InputDecoration(labelText: 'Total Price'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                          r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                    ),
                  ],
                  enabled: !purchaseSalesController.isSerializedProduct.value,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Extract the dropdown items building into a separate method
  List<DropdownMenuItem<UnitType>> _buildDropdownItems(
      PurchaseSalesController purchaseSalesController, BuildContext context) {
    // Standard unit types (excluding 'custom' to prevent duplicates)
    final standardItems = UnitType.values
        .where((unit) =>
            unit != UnitType.custom) // Exclude custom from standard items
        .map((unit) => DropdownMenuItem<UnitType>(
              value: unit,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.box, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      unit.name.capitalize.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ))
        .toList();

    // Add the custom unit option at the end
    standardItems.add(
      DropdownMenuItem<UnitType>(
        // Adding an empty value to prevent duplicate values issue
        value: UnitType.custom,
        // Use a GestureDetector instead of InkWell to handle tap without affecting navigation
        child: GestureDetector(
          // Using behavior to avoid issue with nested DropdownButton
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // Delay dialog opening to avoid dropdown navigation conflicts
            Future.delayed(Duration.zero, () {
              _showCustomUnitDialog(context, purchaseSalesController);
            });
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.add_circle, size: 18, color: Colors.blue),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Custom',
                  style: TextStyle(color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return standardItems;
  }

  // Extract dialog to a separate method for cleaner code
  void _showCustomUnitDialog(
      BuildContext context, PurchaseSalesController purchaseSalesController) {
    // Controllers for the dialog
    final TextEditingController nameController = TextEditingController();
    final TextEditingController factorController =
        TextEditingController(text: '1.0');

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      useRootNavigator: true, // Use root navigator to prevent navigation issues
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Custom Unit'),
          content: SizedBox(
            width: 300, // Fixed width to prevent overflow
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Unit Name',
                      hintText: 'Enter custom unit (e.g., kg, box, etc.)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: factorController,
                    decoration: const InputDecoration(
                      labelText: 'Conversion Factor',
                      hintText: 'E.g., 1.0 for base unit, 12.0 for dozen',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,6}'), // Allow decimal numbers
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conversion factor defines how this unit relates to the base unit. '
                    'For example, if your base unit is "item", then a dozen would have '
                    'a factor of 12.0 (12 items in a dozen).',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  // Show existing custom units
                  Obx(
                    () => purchaseSalesController.customUnits.isEmpty
                        ? const Text('No custom units yet')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Existing Custom Unit:'),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: purchaseSalesController.customUnits
                                      .map((unit) => ListTile(
                                            dense: true,
                                            title: Text(unit),
                                            subtitle: Text(
                                              'Factor: ${purchaseSalesController.customUnitFactors[unit] ?? 1.0}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            onTap: () {
                                              purchaseSalesController
                                                  .selectCustomUnit(unit);
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the custom unit with conversion factor
                final name = nameController.text.trim();
                final factor = double.tryParse(factorController.text) ?? 1.0;

                if (name.isNotEmpty) {
                  purchaseSalesController.addCustomUnit(name,
                      conversionFactor: factor);
                  Navigator.of(context).pop();
                  // Recalculate price after changing unit
                  purchaseSalesController.calculateTotalPrice();
                } else {
                  TLoaders.errorSnackBar(
                    title: 'Invalid Unit Name',
                    message: 'Please enter a valid  name',
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
