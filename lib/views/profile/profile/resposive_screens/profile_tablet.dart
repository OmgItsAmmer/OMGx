import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/validators/validation.dart';

class ProfileTablet extends StatelessWidget {
  const ProfileTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
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

            // In tablet view, we can show the image and top profile info side by side
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image
                Expanded(flex: 1, child: ProfileImageInfoTablet()),
                SizedBox(
                  width: TSizes.spaceBtwItems,
                ),
                // Profile header and top two fields
                Expanded(flex: 2, child: ProfileHeaderTablet()),
              ],
            ),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            // Additional profile fields below
            const ProfileDetailsTablet(),
          ],
        ),
      ),
    );
  }
}

class ProfileImageInfoTablet extends StatelessWidget {
  const ProfileImageInfoTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Profile Image',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Profile image
          Obx(() {
            final isLoading = mediaController.isLoading.value;
            final img = mediaController.displayImage.value;

            if (isLoading) {
              return const TShimmerEffect(
                width: 180,
                height: 180,
                radius: 100,
              );
            }

            return Stack(
              children: [
                img != null
                    ? TRoundedImage(
                        imageurl: img.toString(),
                        width: 180,
                        height: 180,
                        border: Border.all(color: TColors.primary, width: 0.5),
                        isNetworkImage: true,
                        borderRadius: 100,
                        fit: BoxFit.cover,
                        padding: const EdgeInsets.all(0),
                      )
                    : TRoundedImage(
                        imageurl: '',
                        width: 180,
                        height: 180,
                        border: Border.all(color: TColors.primary, width: 0.5),
                        borderRadius: 100,
                        fit: BoxFit.cover,
                        padding: const EdgeInsets.all(0),
                        applyImageRadius: true,
                        backgroundColor: Colors.white,
                        isNetworkImage: false,
                      ),

                // Edit button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: TCircularIcon(
                    icon: Iconsax.edit,
                    onPressed: () {
                      // Handle image upload here
                    },
                    backgroundColor: TColors.primary,
                    width: 40,
                    height: 40,
                    size: 20,
                    color: TColors.white,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: TSizes.spaceBtwItems),

          const Text(
            'Change profile picture',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderTablet extends StatelessWidget {
  const ProfileHeaderTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logout button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TCircularIcon(
                icon: Iconsax.logout,
                color: TColors.white,
                backgroundColor: TColors.buttonPrimary,
                onPressed: () {
                  userController.logOut();
                },
              ),
            ],
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // First Name and Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: userController.firstName,
                  validator: (value) =>
                      TValidator.validateEmptyText('First Name', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Expanded(
                child: TextFormField(
                  controller: userController.lastName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Last Name', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsTablet extends StatelessWidget {
  const ProfileDetailsTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Email and Phone in a row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: userController.email,
                  validator: (value) => TValidator.validateEmail('Email'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Iconsax.sms),
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Expanded(
                child: TextFormField(
                  controller: userController.phoneNumber,
                  validator: (value) =>
                      TValidator.validateEmptyText('Phone Number', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Update Button
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  userController.updateProfile();
                },
                child: userController.isUpdating.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Update Profile'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
