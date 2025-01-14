import 'package:admin_dashboard_v3/common/widgets/appbar/TAppBar.dart';
import 'package:admin_dashboard_v3/common/widgets/chips/choice_chip.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/variants/widgets/variant_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/device/device_utility.dart';

class AddCategoryFrom extends StatelessWidget {
  AddCategoryFrom({super.key, required this.formTitle});
  final List<String> items = [
    'Option 1',
    'Option 2',
    'Option 3'
  ]; // List of dropdown items
  String selectedItem = 'Option 1';
  String formTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: Text(formTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use SizedBox to control space
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    InkWell(
                      onTap: () {
                        // Add your onTap action here
                        print("Icon clicked");
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, // Makes the container circular
                          color: Colors.blue, // Background color of the circle
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0), // Padding inside the circle for spacing
                          child: Icon(
                            Iconsax.add,
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields), // Use SizedBox to create space between fields
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: 'Category Name',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(

                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.backward_item),
                    labelText: 'Product Count',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TChoiceChip(
                  text: 'Featured',
                  selected: false,
                  onSelected: (value) {},
                ),

                const SizedBox(height: TSizes.spaceBtwInputFields),

                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(onPressed: (){}, child: const Text('Save'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

