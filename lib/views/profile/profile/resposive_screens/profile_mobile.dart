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

class ProfileMobile extends StatelessWidget {
  const ProfileMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            // Mobile layout stacks components vertically
            const ProfileImageInfoMobile(),

            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            const ProfileDetailsMobile(),
          ],
        ),
      ),
    );
  }
}

class ProfileImageInfoMobile extends StatelessWidget {
  const ProfileImageInfoMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.sm),
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
                width: 150,
                height: 150,
                radius: 100,
              );
            }

            return Stack(
              children: [
                img != null
                    ? TRoundedImage(
                        imageurl: img.toString(),
                        width: 150,
                        height: 150,
                        border: Border.all(color: TColors.primary, width: 0.5),
                        isNetworkImage: true,
                        borderRadius: 100,
                        fit: BoxFit.cover,
                        padding: const EdgeInsets.all(0),
                      )
                    : TRoundedImage(
                        imageurl: '',
                        width: 150,
                        height: 150,
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
            'Tap edit button to change your profile picture',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailsMobile extends StatelessWidget {
  const ProfileDetailsMobile({
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

          // First Name
          TextFormField(
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

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Last Name
          TextFormField(
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

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Email
          TextFormField(
            controller: userController.email,
            validator: (value) => TValidator.validateEmail('Email'),
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Iconsax.sms),
            ),
          ),

          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Phone Number
          TextFormField(
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
