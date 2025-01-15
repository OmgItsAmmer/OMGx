import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';

class VariationItem extends StatelessWidget {
  VariationItem({
    super.key,
  });
  final List<String> items = [
    'Small',
    'Medium',
    'Big',
  ];
  String selectedItem = 'Small';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue, // Blue background color
              shape: BoxShape.circle, // Optional: Makes the background circular
            ),
            padding: const EdgeInsets.all(8.0), // Adds spacing around the icon
            child: const Icon(Iconsax.image,
                color: Colors.white), // White icon for contrast
          ),
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Size'),
            readOnly: true,
            initialValue: 'Small',
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwInputFields,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Stock'),
            readOnly: true,
            initialValue: '200',
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwInputFields,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Base Price'),
            readOnly: true,
            initialValue: '200',
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwInputFields,
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Discounted Price'),
            readOnly: true,
            initialValue: '200',
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwInputFields,
        ),
        Expanded(
          flex: 0,
          child: InkWell(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red, // Blue background color
                shape:
                    BoxShape.circle, // Optional: Makes the background circular
              ),
              padding:
                  const EdgeInsets.all(6.0), // Adds spacing around the icon
              child: const Icon(Iconsax.profile_delete,
                  color: Colors.white), // White icon for contrast
            ),
          ),
        ),
      ],
    );
  }
}
