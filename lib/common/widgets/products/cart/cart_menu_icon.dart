// import 'package:ecommerenceapp/features/shop/screens/cart/cart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../features/dashboard/screens/add_product_screen.dart';
// import '../../../../features/dashboard/screens/dashboard.dart';
// import '../../../../features/shop/controllers/cart_controller.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/effects/shimmer effect.dart';
// //TCartCounterIcon
// class TCartCounterIcon extends StatelessWidget {
//   const TCartCounterIcon({super.key, this.iconColor});
//
//   final Color? iconColor;
//
//   Future<CartController> _loadCartController() async {
//     // Wait for the controller to be available
//     while (!Get.isRegistered<CartController>()) {
//       await Future.delayed(const Duration(milliseconds: 50));
//     }
//     return Get.find<CartController>();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<CartController>(
//       future: _loadCartController(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While waiting, show shimmer effect
//           return Center(
//             child: TShimmerEffect(width: 20, height: 20),
//           );
//         } else if (snapshot.hasError) {
//           // Handle error if necessary
//           return const Icon(Icons.error, color: Colors.red);
//         } else {
//           // When controller is available, build the UI
//           final cartController = snapshot.data!;
//           return Obx(() => Stack(
//             children: [
//               IconButton(
//                 onPressed: () => Get.to(() =>  CartScreen()),
//                 icon: Icon(
//                   Iconsax.shopping_bag,
//                   color: iconColor,
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 child: Container(
//                   width: 18,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                     color: TColors.black.withOpacity(0.5),
//                   ),
//                   child: Center(
//                     child: Text(
//                       cartController.cartItemQuantity.length.toString(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .labelLarge!
//                           .apply(color: TColors.white, fontSizeFactor: 0.8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ));
//         }
//       },
//     );
//   }
// }
//
//
