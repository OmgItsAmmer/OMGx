import 'package:admin_dashboard_v3/Models/user/user_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../utils/constants/enums.dart';
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
    final UserController userController =
    Get.find<UserController>();
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
                    controller: userController.firstName,
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
                    controller: userController.lastName,

                    // salesController.customerCNICController.value,
                    validator: (value) =>
                        TValidator.validateEmptyText('Last Name', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                
                
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
                    controller: userController.email,

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
                    controller: userController.phoneNumber,
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
              Expanded(child: Obx(
                () => ElevatedButton(onPressed: (){
                userController.updateProfile();

                }, child: (userController.isUpdating.value) ? const CircularProgressIndicator(color: TColors.white,)  : Text('Update Profile',style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),)),
              )),
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
    final ProductImagesController productImagesController = Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();
    final UserController userController = Get.find<UserController>();
    return TRoundedContainer(
      width: double.infinity,
      height:   400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Stack(
            alignment: Alignment
                .bottomRight, // Align the camera icon to the bottom right
            children: [
              // Rounded Image
              Obx(
                    () {
                      final image = mediaController.displayImage.value;

                      if (image != null) {
                        //print(image.filename);
                        return FutureBuilder<String?>(
                          future: mediaController.getImageFromBucket(
                            MediaCategory.users.toString().split('.').last,
                            image.filename ?? '',
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const TShimmerEffect(width: 150, height: 150);
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return const Icon(Icons.error);
                            } else {
                              return TRoundedImage(
                                isNetworkImage: true,
                                width: 150,
                                height: 150,
                                imageurl: snapshot.data!,
                              );
                            }
                          },
                        );
                      }
                  // Check if selectedImages is empty
                  return FutureBuilder<String?>(
                    future: mediaController.fetchMainImage(userController.currentUser.value.userId, MediaCategory.users.toString().split('.').last),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(width: 350, height: 170); // Show shimmer while loading
                      } else if (snapshot.hasError) {
                        return const Text('Error loading image'); // Handle error case
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 150,
                          height: 150,
                          imageurl: snapshot.data!,
                        );
                      } else {
                        return const Text('No image available'); // Handle case where no image is available
                      }
                    },
                  );
                },
              ),
              // Camera Icon
               TRoundedContainer(
                onTap: () {
                  productImagesController.selectThumbnailImage();
                },
                borderColor: TColors.white,
                backgroundColor: TColors.primary,

                padding:
                    const EdgeInsets.all(6), // Add padding around the icon

                child: const Icon(
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
