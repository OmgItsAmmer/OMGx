import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VariationInfo extends StatelessWidget {
  const VariationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
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
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType
                      .number, // Ensures the numeric keyboard is shown
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  decoration: const InputDecoration(labelText: 'price'),
                ),
              ),

              const SizedBox(width: TSizes.spaceBtwSections),

              // Attribute Name TextFormField
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType
                      .number, // Ensures the numeric keyboard is shown
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  decoration:
                      const InputDecoration(labelText: 'discounted price'),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwSections),

              // Attribute Name TextFormField
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType
                      .number, // Ensures the numeric keyboard is shown
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],

                  decoration: const InputDecoration(labelText: 'stock'),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwSections),

              Expanded(
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Add',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: TColors.white),
                      )))
            ],
          ),
        ),
        const SizedBox(
          height: TSizes.spaceBtwSections,
        ),
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            itemCount: 4,
            itemBuilder: (_, index) {
              return TRoundedContainer(
                  backgroundColor: TColors.primaryBackground,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          child: TRoundedImage(
                        width: 50,
                        height: 50,
                        imageurl: TImages.productImage1,
                        isNetworkImage: false,
                      )),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                          child: Text(
                        'Regular',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                          child: Text(
                        '100',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                          child: Text(
                        '90',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                      const SizedBox(
                        width: TSizes.spaceBtwInputFields,
                      ),
                      Expanded(
                          child: Text(
                        '98(stock)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                    ],
                  ));
            },
          ),
        )
      ],
    );
  }
}
