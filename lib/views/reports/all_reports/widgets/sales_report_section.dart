import 'package:flutter/material.dart';

import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class SalesReportSection extends StatelessWidget {
  const SalesReportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales',style: Theme.of(context).textTheme.headlineMedium ,),
          const SizedBox(height: TSizes.spaceBtwSections,),
          Wrap(
            spacing: TSizes.spaceBtwItems, // Horizontal space between items
            runSpacing: TSizes.spaceBtwItems, // Vertical space between rows
            children: [
              HoverableCard(
                text: 'All Products Report',
                animation: TImages.docerAnimation,
                onPressed: (){

                },

              ),
              HoverableCard(
                text: 'All Products Report',
                animation: TImages.docerAnimation,
                onPressed: (){

                },

              ),


            ],
          ),
        ],
      ),
    );
  }
}