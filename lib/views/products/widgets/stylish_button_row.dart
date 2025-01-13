import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class StylishButtonsRow extends StatelessWidget {
  final bool isDeleteEnabled;  // This will control whether the "Delete" button is enabled or not

  StylishButtonsRow({required this.isDeleteEnabled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add Variant button
        ElevatedButton(
          onPressed: () {
            // Add your functionality here
          },
          style: ElevatedButton.styleFrom(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Add Variant',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems,),

        ElevatedButton(
          onPressed: () {
            // Add your functionality here
          },
          style: ElevatedButton.styleFrom(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Edit',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems,),


        ElevatedButton(
          onPressed: () {
            // Add your functionality here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.error, // Background color

            // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(fontSize: 16),
          ),
        ),


      ],
    );
  }
}
