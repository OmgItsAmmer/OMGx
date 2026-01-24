import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/address/address_controller.dart';

class AddressInfo extends StatelessWidget {
  const AddressInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Dropdown for Variation Type
              // Expanded(
              //   child: DropdownButton<VariationType>(
              //     value: VariationType.Regular,
              //     items: VariationType.values.map((VariationType variant) {
              //       return DropdownMenuItem<VariationType>(
              //         value: variant,
              //         child: Text(
              //           variant.name.capitalize.toString(),
              //           style: const TextStyle(),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       // Add your onChanged logic here
              //     },
              //   ),
              // ),
              // const SizedBox(width: TSizes.spaceBtwSections),

              // Attribute Name TextFormField
              // Expanded(
              //   child: TextFormField(
              //     keyboardType: TextInputType
              //         .number, // Ensures the numeric keyboard is shown
              //     inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter
              //           .digitsOnly, // Allows only digits
              //     ],
              //     decoration: const InputDecoration(labelText: 'price'),
              //   ),
              // ),
              //
              // const SizedBox(width: TSizes.spaceBtwSections),
              //
              // // Attribute Name TextFormField
              // Expanded(
              //   child: TextFormField(
              //     keyboardType: TextInputType
              //         .number, // Ensures the numeric keyboard is shown
              //     inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter
              //           .digitsOnly, // Allows only digits
              //     ],
              //     decoration:
              //     const InputDecoration(labelText: 'discounted price'),
              //   ),
              // ),
              // const SizedBox(width: TSizes.spaceBtwSections),
              //
              // // Attribute Name TextFormField
              // Expanded(
              //   child: TextFormField(
              //     keyboardType: TextInputType
              //         .number, // Ensures the numeric keyboard is shown
              //     inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter
              //           .digitsOnly, // Allows only digits
              //     ],
              //
              //     decoration: const InputDecoration(labelText: 'stock'),
              //   ),
              // ),
              // const SizedBox(width: TSizes.spaceBtwSections),

              // Expanded(child: ElevatedButton(onPressed: () {},   child: Text('Add',style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.white),)))
            ],
          ),
        ),
        // const SizedBox(height: TSizes.spaceBtwSections,),

        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(() {
            if (addressController.currentAddresses.isEmpty) {
              return const Text('a');
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              itemCount: addressController.currentAddresses.length,
              itemBuilder: (_, index) {
                return TRoundedContainer(
                    backgroundColor: TColors.primaryBackground,
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                          'Address#$index',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                        const SizedBox(
                          width: TSizes.spaceBtwInputFields,
                        ),

                        Expanded(
                            child: Text(
                          addressController.currentAddresses[index].shippingAddress ??
                              '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                        const SizedBox(
                          width: TSizes.spaceBtwInputFields,
                        ),

                        // Expanded(child: Text('90',style: Theme.of(context).textTheme.bodyMedium,)),
                        // const SizedBox(width: TSizes.spaceBtwInputFields,),
                        //
                        // Expanded(child: Text('98(stock)',style: Theme.of(context).textTheme.bodyMedium,)),
                      ],
                    ));
              },
            );
          }),
        )
      ],
    );
  }
}
