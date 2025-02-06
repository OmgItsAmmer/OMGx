import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/validators/validation.dart';

class ProfileDesktop extends StatelessWidget {
  const ProfileDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              //BRead Crumbs

              const Row(
                children: [
                  //Image card
                  Expanded(child: ProfileImageInfo()),
                  const SizedBox(
                    width: TSizes.spaceBtwSections,
                  ),
                  //info card
                  Expanded(
                      flex: 2,
                      child: ProfileDetails()),

                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections,),
            //

            ],
          ),
        ),
      ),
    ));
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          //Heading
          Text(
            'Profile Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),


          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),




          //fields row
           Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    // controller:
                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('First Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'First Name'),
                
                
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwSections,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    // controller:
                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Last Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Last   Name'),
                
                
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    // controller:
                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Email', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Email'),
                
                
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwSections,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    // controller:
                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Phone Number', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                
                
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(
            height    : TSizes.spaceBtwSections,
          ),
          //save button
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: (){}, child: Text('Update Profile',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),))),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileImageInfo extends StatelessWidget {
  const ProfileImageInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: double.infinity,
      height:   400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Stack(
            alignment: Alignment
                .bottomRight, // Align the camera icon to the bottom right
            children: [
              // Rounded Image
              TRoundedImage(
                width: 160,
                height: 160,
                imageurl: TImages.user,
              ),
              // Camera Icon
              TRoundedContainer(
                borderColor: TColors.white,
                backgroundColor: TColors.primary,

                padding:
                    EdgeInsets.all(6), // Add padding around the icon

                child: Icon(
                  Iconsax.camera, // Camera icon
                  size: 25, // Icon size
                  color: Colors.white, // Icon color
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          Text(
            'Ammer Saeed',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
