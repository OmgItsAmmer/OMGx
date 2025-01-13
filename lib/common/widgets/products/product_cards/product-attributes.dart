
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../chips/choice_chip.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../texts/currency_text.dart';
import '../../texts/heading_text.dart';
import '../../texts/product_title_text.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        TRoundedContainer(
          padding: EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Column(
            children: [
              //Title
              Row(
                children: [
                  TSectionHeading(
                    title: "Variation",
                    showActionButton: false,
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          TProductTitleText(
                            title: 'Calories: ',
                            smallSize: true,
                          ),

                          //Actual Price
                          // Text(
                          //   '\$25',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .titleSmall!
                          //       .apply(decoration: TextDecoration.lineThrough),
                          // ),
                          SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          // Sale Price
                          TProductPriceText(price: '20'+' grams',currencySign: "",)
                        ],
                      ),

                      //Stock
                      Row(
                        children: [
                          TProductTitleText(
                            title: "Stock:",
                            smallSize: true,
                          ),
                          SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          Text(
                            ' In Stock',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),

              //Variation Description
              TProductTitleText(
                title:
                    'This is the Description of the Product and it can go upto max 4 lines',
                smallSize: true,
                maxLines: 4,
              ),
            ],
          ),
        ),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        //Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            TSectionHeading(title: 'Colors',showActionButton: false,),
            SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
           Wrap(
             spacing: 8,
             children: [
               TChoiceChip(text: "Green",selected: true,onSelected: (value){},),
               TChoiceChip(text: "Blue",selected: false,onSelected: (value){}),
               TChoiceChip(text: "Yellow",selected: false,onSelected: (value){}),


             ],
           )

          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            TSectionHeading(title: 'Size'),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(text: "EU 34",selected: true,onSelected: (value){}),
                TChoiceChip(text: "EU 36",selected: false,onSelected: (value){}),
                TChoiceChip(text: "EU 38",selected: false,onSelected: (value){}),

              ],
            )

          ],
        ),
      ],
    );
  }
}

