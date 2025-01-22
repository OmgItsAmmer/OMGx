import 'package:admin_dashboard_v3/common/widgets/chips/rounded_choice_chips.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SalesSummary extends StatelessWidget {
  const SalesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Profiles'),
                    content: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox(
                            width: 150  ,
                             child: TChoiceChip(text: 'Profile 1', selected: true))),
                        const SizedBox(width: TSizes.spaceBtwItems,),
                        Expanded(child: TChoiceChip(text: 'Profile 2', selected: false)),
                        const SizedBox(width: TSizes.spaceBtwItems,),

                        Expanded(child: TChoiceChip(text: 'Profile 3', selected: false)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                color: TColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Discount'),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        TRoundedContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NET TOTAL',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              TRoundedContainer(
                backgroundColor: TColors.primaryBackground,
                width: 150,
                height: 50,
                child: Text(
                  '130000',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
