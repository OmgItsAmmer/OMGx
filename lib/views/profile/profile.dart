import 'package:admin_dashboard_v3/views/profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/widgets/appbar/TAppBar.dart';
import '../../common/widgets/images/t_circular_image.dart';
import '../../common/widgets/texts/heading_text.dart';
import '../../controllers/user/user_controller.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/effects/shimmer effect.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();


    return Scaffold(
      appBar: TAppBar(
        title: Text("Profile"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                          () {
                        return controller.imageUploading.value
                            ? TShimmerEffect(width: 80, height: 80, radius: 80)
                            : TCircularImage(
                          image: TImages.user,
                          width: 80,
                          height: 80,
                          isNetworkImage: false,
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () => {}, //controller.uploadUserProfilePicture()
                      child: Text("Change Profile Picture"),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              Divider(),
              SizedBox(height: TSizes.spaceBtwItems),

              TSectionHeading(
                title: "Profile Information",
                showActionButton: false,
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              TProfilemenu(
                title: "Name",
                value: controller.current_user?.value['first_name'] +
                    " " +
                    controller.current_user?.value['last_name'] ??
                    "", // Fallback to empty string if null
                onPressed: () {},
              ),
              TProfilemenu(
                onPressed: () {},
                title: "Username",
                value: controller.current_user?.value['first_name'] +
                    " " +
                    controller.current_user?.value['last_name'] ??
                    "", // Fallback to empty string if null
              ),

              SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              Divider(),
              SizedBox(height: TSizes.spaceBtwItems),

              TSectionHeading(
                title: "Personal Information",
                showActionButton: false,
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              TProfilemenu(
                onPressed: () {},
                title: "User ID",
                value: controller.current_user?.value['user_id'].toString() ??
                    "", // Fallback to empty string if null
                icon: Iconsax.copy,
              ),
              TProfilemenu(
                onPressed: () {},
                title: "E-mail",
                value: controller.current_user?.value['email'] ?? "", // Fallback to empty string if null
              ),
              TProfilemenu(
                onPressed: () {},
                title: "Phone Number",
                value: controller.current_user?.value['phone_number'] ?? "", // Fallback to empty string if null
              ),
              TProfilemenu(
                onPressed: () {},
                title: 'Gender',
                value: controller.current_user?.value['gender'] ??
                    'Not Available', // Fallback if null
              ),
              TProfilemenu(
                onPressed: () {},
                title: 'Date of Birth',
                value: controller.current_user?.value['dob'] ??
                    'Not Available', // Fallback if null
              ),

              Divider(),
              SizedBox(height: TSizes.spaceBtwItems),

              TextButton(
                onPressed: () => controller.DeleteAccountWarning(),
                child: Text(
                  "Close Account",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
