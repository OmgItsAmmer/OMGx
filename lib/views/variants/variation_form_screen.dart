import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:ecommerce_dashboard/views/variants/widgets/variant_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/sizes.dart';

class VariationFormScreen extends StatelessWidget {
  VariationFormScreen({super.key});
  final List<String> items = [
    'Option 1',
    'Option 2',
    'Option 3'
  ]; // List of dropdown items
  String selectedItem = 'Option 1'; // Initial selected item
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TAppBar(
          title: Text('Add New Product Variant'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: ODropDownMenu(
                            hintText: 'Size',
                            chosenValue: selectedItem,
                            itemsList: items,
                            validator: (value) {},
                            onChanged: (value) {},
                          )),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Description'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwInputFields,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Stock'),
                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Price'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwInputFields,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15), // Adjust padding
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: Colors.red, // Increase font size
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(
                              width:
                                  16), // Replace `TSizes.spaceBtwItems` with a fixed or calculated value
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

// DropdownButton<String>(
// value: selectedItem,
// items: items.map<DropdownMenuItem<String>>((String value) {
// return DropdownMenuItem<String>(
// alignment: Alignment.center,
// value: value,
// child: Text(
// value,
// style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// ),
// );
// }).toList(),
//
// onChanged: (newValue) {
// if (newValue != null) {
// // Update the selected item
// }
// },
//
// style: const TextStyle(
// color: TColors.white, // Style for dropdown text
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// dropdownColor: TColors.black, // Background color of dropdown menu
// icon: const Icon(
// Icons.arrow_drop_down_circle, // Dropdown icon
// color: TColors.primary,
// size: 28,
// ),
// underline: Container(
// height: 2, // Underline style
// color: TColors.white,
// ),
// borderRadius: BorderRadius.circular(10), // Rounded corners for dropdown menu
// )
