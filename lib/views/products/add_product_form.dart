import 'package:admin_dashboard_v3/common/widgets/chips/choice_chip.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/variants/widgets/variant_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddProductForm extends StatelessWidget {
  AddProductForm({super.key});
  final List<String> items = [
    'Option 1',
    'Option 2',
    'Option 3'
  ]; // List of dropdown items
  String selectedItem = 'Option 1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.user),
                          labelText: 'Product Name'),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.user),
                          labelText: 'Base Price'),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.money_21),
                          labelText: 'Sale Price'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.user),
                          labelText: 'Description'),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  Expanded(
                      flex: 1,
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Select Image'))),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ODropDownMenu(
                      itemsList: items,
                      onChanged: (value) {},
                      chosenValue: selectedItem,
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  Expanded(
                    flex: 2,
                    child: ODropDownMenu(
                      itemsList: items,
                      chosenValue: selectedItem,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  const Expanded(
                    flex: 1,
                    child: TChoiceChip(text: 'Popular', selected: true)
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){}, child: Text('Save'))),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              SizedBox(
                  width: double.infinity,
               child:  OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1), // White border
                    textStyle: const TextStyle(fontSize: 16), // Optional: Adjust font size
                    foregroundColor: Colors.white, // Optional: Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Optional: Adjust padding
                  ),
                  child: const Text('Cancel'),
                )
              )  ],
          ),
        ),
      ),
    );
  }
}
