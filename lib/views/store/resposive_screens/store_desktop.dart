import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/validators/validation.dart';
import '../../../controllers/shop/shop_controller.dart';

class StoreDesktop extends StatelessWidget {
  const StoreDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

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
                    'Store',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  //BRead Crumbs

                  const Row(
                    children: [
                      //Image card
                      Expanded(child: StoreImageInfo()),
                      SizedBox(
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
    final ShopController shopController = Get.find<ShopController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Heading
          Text(
            'Store Details',
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
                        TValidator.validateEmptyText('Store Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Store Name'),


                  ),
                ),
              ),

            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          Wrap(
            spacing: TSizes.spaceBtwSections, // Horizontal space between children
            runSpacing: TSizes.spaceBtwItems, // Vertical space between lines
            children: [
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Tax Rate(%)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Tax Rate(%)'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Shipping Cost(🚵)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Shipping Cost(🚵)'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Free Shipping Threshold(🚵)', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Free Shipping Threshold(🚵)'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height    : TSizes.spaceBtwSections,
          ),
          //Prifles
          Wrap(
            spacing: TSizes.spaceBtwSections, // Horizontal space between children
            runSpacing: TSizes.spaceBtwItems, // Vertical space between lines
            children: [
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility
                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 1', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 1'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 2', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 2'),
                ),
              ),
              SizedBox(
                width: TDeviceUtils.isDesktopScreen(context) ? 250 : 200, // Set a fixed width or use `double.infinity` for flexibility

                child: TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Profile 3', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Profile 3'),
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
              Expanded(child: ElevatedButton(onPressed: (){}, child: Text('Update Store Details',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),))),
            ],
          )
        ],
      ),
    );
  }
}

class StoreImageInfo extends StatelessWidget {
  const StoreImageInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
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
                isNetworkImage: true,
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
            shopController.selectedShop?.value.shopname ?? ' ',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
