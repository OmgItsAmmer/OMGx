//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:iconsax/iconsax.dart';
//
//
// import '../../controllers/user/user_controller.dart';
// import '../../utils/constants/colors.dart';
// import '../../utils/constants/sizes.dart';
// import '../profile/profile.dart';
//
//
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller   = Get.put(UserController());
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             //Header
//             TPrimaryHeaderContainer(
//                 child: Column(
//                   children: [
//                     TAppBar(
//                       title: Text(
//                         "Account",
//                         style: Theme.of(context)
//                             .textTheme
//                             .headlineMedium!
//                             .apply(color: TColors.white),
//                       ),
//                       showBackArrow: false,
//                     ),
//                     //User Profile Card
//                     TUserProfileTile(onPressed: ()=> Get.to(() => const ProfileScreen()),),
//                     const SizedBox(
//                       height: TSizes.spaceBtwSections,
//                     ),
//                   ],
//                 )),
//             //Body
//             Padding(
//               padding: const EdgeInsets.all(TSizes.defaultSpace),
//               child: Column(
//                 children:  [
//                   // Account Settings
//                   const TSectionHeading(title: "Account Settings",showActionButton: false,),
//                   const SizedBox(
//                     height: TSizes.spaceBtwItems,
//                   ),
//
//                   const TSettingMenuTile(icon: Iconsax.bank, title: 'Bank Account', subTitle: 'Withdraw balance to registered bank account'),
//                   const TSettingMenuTile(icon: Iconsax.notification, title: 'Notifications', subTitle: 'Set any kind of notification message'),
//                   const TSettingMenuTile(icon: Iconsax.security_card, title: 'Account Privacy', subTitle: 'Manage data usage and connected accounts'),
//
//
//                   /// -- App Settings i
//                   const SizedBox(height: TSizes.spaceBtwSections),
//                   const TSectionHeading(title: 'App Settings', showActionButton: false),
//                   const SizedBox(height: TSizes.spaceBtwItems),
//                   const TSettingMenuTile(icon: Iconsax.document_upload, title: 'Load Data', subTitle: 'Upload Data to your Cloud Database (only for admins)'),
//
//                   TSettingMenuTile(
//                     icon: Iconsax.location,
//                     title: 'Geolocation',
//                     subTitle: 'Set recommendation based on location',
//                     trailing: Switch(value: true, onChanged: (value) {}),
//
//                   ), // TsettingsMenuTile
//
//                   TSettingMenuTile(
//                     icon: Iconsax.security_user,
//                     title: 'Safe Mode',
//                     subTitle: 'Search result is safe for all ages',
//                     trailing: Switch(value: false, onChanged: (value) {}),
//
//                   ), // TsettingsMenuTile
//
//                   TSettingMenuTile(
//                     icon: Iconsax.image,
//                     title: 'HD Image Quality',
//                     subTitle: 'Set image quality to be seen',
//                     trailing: Switch(value: false, onChanged: (value) {}),
//
//                   ),
//                   TSettingMenuTile(icon: Iconsax.security_card, title: 'Log Out', subTitle: 'Log out from your current account',onTap:(){controller.logOut();},),
//                   // TsettingsMenuTite
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
