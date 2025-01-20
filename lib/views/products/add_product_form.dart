
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/products/widgets/variation_item.dart';
import 'package:admin_dashboard_v3/views/variants/widgets/variant_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';

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
    return Flexible(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: TColors.pureBlack,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2), // Shadow color
                spreadRadius: 5, // Spread of the shadow
                blurRadius: 10, // Blur intensity
                offset: const Offset(0, -5), // Offset the shadow upwards
              ),
            ],
          ),
          width: double.infinity,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 200,
                  child: OutlinedButton(onPressed: (){}, child: Text('Discard'))),
              const SizedBox(width: TSizes.spaceBtwItems,),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(onPressed: () {}, child: Text('Save'))),
              const SizedBox(width: TSizes.spaceBtwItems,),
      
            ],
          ),
        ),
      
      
      
        appBar: const TAppBar(
          title: Text("Add Product:"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0,
                                  5), // Offset for horizontal and vertical shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Basic Information'),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Product Name'),
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Description'),
                                maxLines: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0,
                                  5), // Offset for horizontal and vertical shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text('Pricing & Variations'),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors
                                              .blue, // Blue background color
                                          shape: BoxShape
                                              .circle, // Optional: Makes the background circular
                                        ),
                                        padding: const EdgeInsets.all(
                                            8.0), // Adds spacing around the icon
                                        child: const Icon(Iconsax.image,
                                            color: Colors
                                                .white), // White icon for contrast
                                      ),
                                    ),
                                  ),
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
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Stock'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: TSizes.spaceBtwInputFields,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Base Price'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: TSizes.spaceBtwInputFields,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Discounted Price'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: TSizes.spaceBtwInputFields,
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('Add')))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0, 5), // Offset for shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text('Variation List'),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              ListView.separated(
                                shrinkWrap:
                                    true, // Allows ListView to take only the needed space
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevents internal scrolling
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: TSizes.spaceBtwInputFields,
                                ),
                                itemCount: 4,
                                itemBuilder: (_, index) {
                                  return VariationItem();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: TSizes.spaceBtwInputFields,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0, 5), // Offset for shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text('Thumbnail'),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: TColors.pureBlack,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white
                                            .withOpacity(0.2), // Shadow color
                                        spreadRadius: 5, // Spread of the shadow
                                        blurRadius: 10, // Blur intensity
                                        offset: const Offset(
                                            0, 5), // Offset for shadow
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(
                                      8.0), // Adds spacing around the icon
                                  child: Image.asset(
                                    TImages
                                        .darkAppLogo, // Make sure this is a valid asset path in pubspec.yaml
                                    color: Colors.white,
                                  ) // White icon for contrast
                                  ),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('Select Image'))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0, 5), // Offset for shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text('Other Images'),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: TColors.pureBlack,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white
                                            .withOpacity(0.2), // Shadow color
                                        spreadRadius: 5, // Spread of the shadow
                                        blurRadius: 10, // Blur intensity
                                        offset: const Offset(
                                            0, 5), // Offset for shadow
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(
                                      8.0), // Adds spacing around the icon
                                  child: Image.asset(
                                    TImages
                                        .darkAppLogo, // Make sure this is a valid asset path in pubspec.yaml
                                    color: Colors.white,
                                  ) // White icon for contrast
                                  ),
                              const SizedBox(
                                height: TSizes.spaceBtwSections,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center, // Ensure proper alignment
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      height: 70,
                                      child: ListView.separated(
                                        separatorBuilder: (_, __) => const SizedBox(
                                          width: TSizes.spaceBtwInputFields/3,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 6  ,
                                        physics: const BouncingScrollPhysics(), // Enable scrolling physics
                                        itemBuilder: (_, index) {
                                          return const add_more_product_item();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwInputFields), // Maintain spacing
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white),
                                        onPressed: () {
                                          // Add your onPressed logic here
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
      
      
      
      
      
                            ],
                          ),
                        ),
                      ),
      
                      const SizedBox(height: TSizes.spaceBtwInputFields,),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0, 5), // Offset for shadow
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text('Category'),
                                const SizedBox(height: TSizes.spaceBtwInputFields,),
                                ODropDownMenu(
                                  itemsList: items,
                                  chosenValue: selectedItem,
                                  onChanged: (value){},
                                  hintText: 'Text',
                                ),
                              ],
                            )
                        ),
                      ),
      
                      const SizedBox(height: TSizes.spaceBtwInputFields,),
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.pureBlack,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.white.withOpacity(0.2), // Shadow color
                              spreadRadius: 5, // Spread of the shadow
                              blurRadius: 10, // Blur intensity
                              offset: const Offset(0, 5), // Offset for shadow
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text('Brands'),
                                const SizedBox(height: TSizes.spaceBtwInputFields,),
                                ODropDownMenu(
                                  itemsList: items,
                                  chosenValue: selectedItem,
                                  onChanged: (value){},
                                  hintText: 'Text',
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class add_more_product_item extends StatelessWidget {
  const add_more_product_item({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: TColors.pureBlack,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Iconsax.image, color: Colors.white),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );

  }
}

// const SizedBox(
// width: TSizes.spaceBtwInputFields,
// ),
// TextFormField(
// decoration: const InputDecoration(
// prefixIcon: Icon(Iconsax.money_21),
// labelText: 'Sale Price'),
// ),
// const SizedBox(
// height: TSizes.spaceBtwItems,
// ),
// Row(
// children: [
// Expanded(
// flex: 4,
// child: TextFormField(
// decoration: const InputDecoration(
// prefixIcon: Icon(Iconsax.user),
// labelText: 'Description'),
// ),
// ),
// const SizedBox(
// width: TSizes.spaceBtwInputFields,
// ),
// Expanded(
// flex: 1,
// child: OutlinedButton(
// onPressed: () {}, child: const Text('Select Image'))),
// ],
// ),
// const SizedBox(
// height: TSizes.spaceBtwInputFields,
// ),
// Row(
// children: [
// Expanded(
// flex: 2,
// child: ODropDownMenu(
// itemsList: items,
// onChanged: (value) {},
// chosenValue: selectedItem,
// ),
// ),
// const SizedBox(
// width: TSizes.spaceBtwInputFields,
// ),
// Expanded(
// flex: 2,
// child: ODropDownMenu(
// itemsList: items,
// chosenValue: selectedItem,
// onChanged: (value) {},
// ),
// ),
// const SizedBox(
// width: TSizes.spaceBtwInputFields,
// ),
// const Expanded(
// flex: 1,
// child: TChoiceChip(text: 'Popular', selected: true)),
// ],
// ),
// const SizedBox(
// height: TSizes.spaceBtwInputFields,
// ),
// SizedBox(
// width: double.infinity,
// child: ElevatedButton(onPressed: () {}, child: Text('Save'))),
// const SizedBox(
// height: TSizes.spaceBtwInputFields,
// ),
// SizedBox(
// width: double.infinity,
// child: OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// side: const BorderSide(
// color: Colors.white, width: 1), // White border
// textStyle: const TextStyle(
// fontSize: 16), // Optional: Adjust font size
// foregroundColor: Colors.white, // Optional: Text color
// padding: const EdgeInsets.symmetric(
// horizontal: 20,
// vertical: 15), // Optional: Adjust padding
// ),
// child: const Text('Cancel'),
// ))
