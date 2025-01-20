import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Personal Info

        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Row(
                children: [
                  const Expanded(
                    child: TRoundedImage(
                      imageurl: TImages.darkAppLogo,
                      padding: EdgeInsets.all(0),
                      isNetworkImage: false,
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coding with T',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Text(
                        'ammersaeed21@gmail.com',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),
        //Contact Info
        SizedBox(width: double.infinity,
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Person' , style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spaceBtwSections,),
              Text('Ammer Saeed' , style: Theme.of(context).textTheme.titleSmall,),
              const SizedBox(height: TSizes.spaceBtwSections/2,),
              Text('ammersaeed21@gmail.com' , style: Theme.of(context).textTheme.titleSmall,),
              const SizedBox(height: TSizes.spaceBtwSections/2,),
              Text('032356508184' , style: Theme.of(context).textTheme.titleSmall,),
              const SizedBox(height: TSizes.spaceBtwSections/2,),


            ],
          ),
        ),),
        const SizedBox(height: TSizes.spaceBtwSections,),
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shipping address' , style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: TSizes.spaceBtwSections,),
                Text('Ammer Saeed' , style: Theme.of(context).textTheme.titleSmall,),
                const SizedBox(height: TSizes.spaceBtwSections/2,),
                Text('Nust islamabad' , style: Theme.of(context).textTheme.titleSmall,),

              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),
        //Contact Info
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding:  const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text('Billing Address' , style: Theme.of(context).textTheme.headlineMedium,),
                const SizedBox(height: TSizes.spaceBtwSections,),
                Text('Ammer Saeed' , style: Theme.of(context).textTheme.titleSmall,),
                const SizedBox(height: TSizes.spaceBtwSections/2,),
                Text('Nust islamabad' , style: Theme.of(context).textTheme.titleSmall,),
              ],
            ),
          ),
        )


      ],
    );
  }
}
