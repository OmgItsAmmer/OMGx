import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/appbar.dart';

class AddBrandForm extends StatelessWidget {
  AddBrandForm({super.key, required this.formTitle});

  final List<String> items = ['Option 1', 'Option 2', 'Option 3'];
  String selectedItem = 'Option 1';
  final String formTitle;

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define breakpoints
    final isLargeScreen = screenWidth > 1000;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 1000;

    return Scaffold(
      appBar: TAppBar(title: Text(formTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  Container(
                    width: isLargeScreen
                        ? 500
                        : isMediumScreen
                        ? screenWidth * 0.7
                        : screenWidth * 0.9,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Expanded(
                                child: Text(
                                  formTitle,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Main container tap action
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(Icons.image, size: 50),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 5,
                                    child: InkWell(
                                      onTap: () {
                                        print("Edit icon clicked");
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Brand Name',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.backward_item),
                              labelText: 'Product Count',
                            ),
                          ),
                          const SizedBox(height: 20),
                          CheckboxListTile(
                            title: const Text("Verified"),
                            value: true,
                            onChanged: (bool? value) {},
                          ),
                          CheckboxListTile(
                            title: const Text("Featured"),
                            value: false,
                            onChanged: (bool? value) {},
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
