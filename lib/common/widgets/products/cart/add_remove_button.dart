//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../utils/helpers/helper_functions.dart';
// import '../../texts/currency_text.dart';
//
// class TProductQuantityWithAddRemove extends StatelessWidget {
//   TProductQuantityWithAddRemove({
//     super.key,
//     required this.itemQuantity,
//     required this.indexToRemove,
//     required this.variationStock,
//     required this.variantId,
//     required this.EachItemPrice,
//   });
//
//   final int indexToRemove;
//   final Rx<int> itemQuantity;  // Reactive quantity
//   final String variationStock;
//   final int variantId;
//   final String EachItemPrice;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool dark = THelperFunctions.isDarkMode(context);
//     final cartController = Get.find<CartController>();
//
//     // Calculate price based on quantity
//     double calculateItemPrice() {
//       return itemQuantity.value.toDouble() * double.parse(EachItemPrice);
//     }
//
//     return Obx(
//           () => Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Quantity Controls
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TCircularIcon(
//                 icon: Iconsax.minus,
//                 width: 40,
//                 height: 40,
//                 size: TSizes.md,
//                 color: dark ? TColors.white : TColors.black,
//                 backgroundColor: dark ? TColors.darkerGrey : TColors.light,
//                 onPressed: () {
//                   if (int.parse(cartController.cartItemQuantity[indexToRemove]) > 0) {
//
//                     cartController.cartItemQuantity[indexToRemove] =
//                         (int.parse(cartController.cartItemQuantity[indexToRemove]) - 1).toString();
//
//                     if (cartController.cartItemQuantity[indexToRemove] == '0') {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Dialog(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20.0), // Rounded corners
//                             ),
//                             child: Container(
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.warning_rounded, size: 50, color: Colors.orange),
//                                   SizedBox(height: 15),
//                                   Text(
//                                     "Remove Item",
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: TColors.primary
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     "Are you sure you want to remove this item from the cart?",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(fontSize: 16,color: TColors.primary),
//
//                                   ),
//                                   SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           cartController.cartItemQuantity[indexToRemove] =
//                                               (int.parse(cartController.cartItemQuantity[indexToRemove]) + 1).toString();
//                                           Navigator.of(context).pop(); // Cancel action
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.grey[300],
//                                         ),
//                                         child: Text("Cancel", style: TextStyle(color: Colors.black)),
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Confirm action
//                                           cartController.removeItemFromCart(indexToRemove);
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: Text("OK"),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//
//                     } else {
//                       cartController.updateExistingCartItemWithVariantId(
//                         variantId,
//                         cartController.cartItemQuantity[indexToRemove],
//                       );
//                     }
//                   }
//                 },
//               ),
//               const SizedBox(width: TSizes.spaceBtwItems),
//               Text(
//                 cartController.cartItemQuantity[indexToRemove] ,
//                 style: Theme.of(context).textTheme.titleSmall,
//               ),
//               const SizedBox(width: TSizes.spaceBtwItems),
//               TCircularIcon(
//                 icon: Iconsax.add,
//                 width: 40,
//                 height: 40,
//                 size: TSizes.md,
//                 color: TColors.white,
//                 backgroundColor: TColors.primary,
//                 onPressed: () {
//                   if (int.parse(cartController.cartItemQuantity[indexToRemove]) < 100) { //int.parse(variationStock)
//                     cartController.cartItemQuantity[indexToRemove] =
//                         (int.parse(cartController.cartItemQuantity[indexToRemove]) + 1).toString();
//                     cartController.updateExistingCartItemWithVariantId(
//                       variantId,
//                       cartController.cartItemQuantity[indexToRemove],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//
//           // Display dynamic price
//           // TProductPriceText(
//           //   price: calculateItemPrice().toStringAsFixed(2),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
//
