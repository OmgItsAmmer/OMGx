// import 'package:ecommerenceapp/features/authentication/controllers/login/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../utils/constants/colors.dart';
// import '../../utils/constants/image_strings.dart';
// import '../../utils/constants/sizes.dart';
//
// class TLoginSocialButtons extends StatelessWidget {
//   const TLoginSocialButtons({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//       final controller = Get.put(LoginController());
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               border: Border.all(color: TColors.grey),
//               borderRadius: BorderRadius.circular(100)),
//           child: IconButton(
//             onPressed: () => controller.googleSignIn(),
//             icon: const Image(
//               width: TSizes.iconMd,
//               height: TSizes.iconMd,
//               image: AssetImage(TImages.google),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: TSizes.spaceBtwItems,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               border: Border.all(color: TColors.grey),
//               borderRadius: BorderRadius.circular(100)),
//           child: IconButton(
//             onPressed: () {},
//             icon: const Image(
//               width: TSizes.iconMd,
//               height: TSizes.iconMd,
//               image: AssetImage(TImages.facebook),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
