import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class StylishButtonsRow extends StatelessWidget {
  final VoidCallback?
      button1OnPressed; // Optional parameter for Add Variant button
  final VoidCallback? button2OnPressed; // Optional parameter for Edit button
  final VoidCallback? button3OnPressed; // Optional parameter for Delete button

  final bool showButton1; // Control visibility of Add Variant button
  final bool showButton2; // Control visibility of Edit button
  final bool deleteButton; // Control visibility of Delete button

  final String button1Title; // Title for Add Variant button
  final String button2Title; // Title for Edit button
  final String button3Title; // Title for Delete button

  StylishButtonsRow({
    this.button1OnPressed, // Optional
    this.button2OnPressed, // Optional
    this.button3OnPressed, // Optional
    this.showButton1 = true, // Default to true
    this.showButton2 = true, // Default to true
    this.deleteButton =
        false, // Default to false (Delete button will be hidden by default)
    this.button1Title = 'Add Variant', // Default title
    this.button2Title = 'Edit', // Default title
    this.button3Title = 'Delete', // Default title
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add Variant button (conditionally shown)
        if (showButton1)
          ElevatedButton(
            onPressed: button1OnPressed ??
                () {}, // Provide a no-op function if it's null
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              button1Title,
              style: const TextStyle(fontSize: 16),
            ),
          ),

        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),

        // Edit button (conditionally shown)
        if (showButton2)
          ElevatedButton(
            onPressed: button2OnPressed ?? () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              button2Title, // Dynamically set title
              style: const TextStyle(fontSize: 16),
            ),
          ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),

        // Delete button (conditionally shown and enabled based on the flag)
        if (deleteButton)
          ElevatedButton(
            onPressed: button3OnPressed ??
                () {}, // Disable the delete button if not enabled
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              button3Title, // Dynamically set title
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}
