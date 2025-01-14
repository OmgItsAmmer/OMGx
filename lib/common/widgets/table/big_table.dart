import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/products/widgets/stylish_button_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vtable/vtable.dart';

import '../../../views/variants/variation_form_screen.dart';
import '../chips/choice_chip_row.dart';

class OBigTable extends StatelessWidget {
  const OBigTable({
    super.key,
    required this.items,
    required this.columnKeys,
    required this.enableDoubleTap,
    required this.innerTableItems,
    required this.innerColumnKeys, // Add keys for the inner table
    this.enableInnerTableDoubleTap =
        false, // Default false, control double tap for inner table
    this.button1OnPressed, // Optional parameter for first button
    this.button2OnPressed, // Optional parameter for second button
    this.button3OnPressed, // Optional parameter for third button
    this.button1Title = 'Button 1', // Default title for button 1
    this.button2Title = 'Button 2', // Default title for button 2
    this.button3Title = 'Button 3', // Default title for button 3
    this.showButton1 = true, // Default visibility for button 1
    this.showButton2 = true, // Default visibility for button 2
    this.showButton3 = false,
    this.innerTableDescription = '', // Default visibility for button 3
    // Add dynamic chip parameters
    this.chip1Selected = false,
    this.chip2Selected = false,
    this.chip3Selected = false,
    this.onChip1Selected,
    this.onChip2Selected,
    this.onChip3Selected,
    this.showChip1 = false,
    this.showChip2 = false,
    this.showChip3 = false,
    this.popupTitle = '',
  });

  final List<Map<String, dynamic>> items;
  final List<String> columnKeys;
  final bool enableDoubleTap; // Parameter to control double-tap behavior
  final List<Map<String, dynamic>> innerTableItems; // Data for inner VTable
  final List<String> innerColumnKeys; // Keys for the inner table columns
  final bool
      enableInnerTableDoubleTap; // Optional parameter to control double-tap for the inner table
  final VoidCallback? button1OnPressed; // Optional callback for first button
  final VoidCallback? button2OnPressed; // Optional callback for second button
  final VoidCallback? button3OnPressed; // Optional callback for third button
  final String button1Title; // Title for button 1
  final String button2Title; // Title for button 2
  final String button3Title; // Title for button 3
  final bool showButton1; // Show button 1
  final bool showButton2; // Show button 2
  final bool showButton3; // Show button 3
  final String innerTableDescription;
  final String popupTitle;

  // Dynamic chip properties
  final bool chip1Selected;
  final bool chip2Selected;
  final bool chip3Selected;
  final ValueChanged<bool>? onChip1Selected;
  final ValueChanged<bool>? onChip2Selected;
  final ValueChanged<bool>? onChip3Selected;
  final bool showChip1;
  final bool showChip2;
  final bool showChip3;

  @override
  Widget build(BuildContext context) {
    // Dynamically create columns based on the main table keys
    final columns = columnKeys.map((key) {
      return VTableColumn(

        styleFunction: (Map<String, dynamic>? row) =>
            const TextStyle(color: Colors.white),
        label: key,
        width: 100,
        grow: 0.2,
        transformFunction: (Map<String, dynamic>? row) =>
            row?[key]?.toString() ?? 'N/A',
        alignment: Alignment.centerLeft,
      );
    }).toList();

    return Container(
      width: TDeviceUtils.getScreenWidth(context),
      height: TDeviceUtils.getScreenHeight(),
      child: VTable(


        items: items,
        columns: columns,
        onDoubleTap: enableDoubleTap
            ? (row) {
                // Cast row to Map<String, dynamic> to access keys
                final rowData = row as Map<String, dynamic>?;

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(popupTitle),
                        const Icon(Iconsax.message,
                            size: 30, color: TColors.primary),
                      ],
                    ),
                    content: Container(
                      width: 500, // Adjust width as needed
                      height: 400, // Adjust height as needed
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Order ID: ${rowData?['Order ID'] ?? 'Unknown'}'),
                                Text(
                                    'Name: ${rowData?['Customer Name'] ?? 'Unknown'}'),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            StylishButtonsRow(
                              button1OnPressed: button1OnPressed,
                              button2OnPressed: button2OnPressed,
                              button3OnPressed: button3OnPressed,
                              showButton1:
                                  showButton1, // Control visibility for button 1
                              showButton2:
                                  showButton2, // Control visibility for button 2
                              deleteButton:
                                  showButton3, // Control visibility for button 3
                              button1Title: button1Title, // Title for button 1
                              button2Title: button2Title, // Title for button 2
                              button3Title: button3Title, // Title for button 3
                            ),
                            (showChip1)
                                ? const SizedBox(
                                    height: TSizes.spaceBtwSections,
                                  )
                                : const SizedBox(),
                            OChoiceChipRow(
                              chip1Selected: chip1Selected,
                              chip2Selected: chip2Selected,
                              chip3Selected: chip3Selected,
                              onChip1Selected: onChip1Selected,
                              onChip2Selected: onChip2Selected,
                              onChip3Selected: onChip3Selected,
                              showChip1: showChip1,
                              showChip2: showChip2,
                              showChip3: showChip3,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            SizedBox(
                              width: 450, // Adjust width
                              height: 250, // Adjust height
                              child: VTable(
                                tableDescription: innerTableDescription,
                                items: innerTableItems, // Inner table data
                                columns: innerColumnKeys.map((key) {
                                  return VTableColumn(
                                    label: key,
                                    width: 50,
                                    grow: 0.8,
                                    transformFunction:
                                        (Map<String, dynamic>? row) =>
                                            row?[key]?.toString() ?? 'N/A',
                                    alignment: Alignment.centerLeft,
                                  );
                                }).toList(),
                                onDoubleTap: enableInnerTableDoubleTap
                                    ? (row) {
                                        Get.to(() => VariationFormScreen());
                                      }
                                    : null, // Control inner table double tap
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              }
            : null,
      ),
    );
  }
}
