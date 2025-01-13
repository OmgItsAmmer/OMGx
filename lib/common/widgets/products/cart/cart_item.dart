// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../../features/shop/controllers/product_controller.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/image_strings.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../images/t_rounded_image.dart';
// import '../../texts/brand_title_with_verification.dart';
// import '../../texts/product_title_text.dart';
//
// class TCartItem extends StatelessWidget {
//   const TCartItem({
//     super.key,
//     required this.dark,
//     required this.imageUrl,       // Accept image URL as a parameter
//     required this.brand,          // Accept brand name as a parameter
//     required this.productTitle,   // Accept product title as a parameter
//     required this.size,           // Accept size as a parameter
//     required this.calories,           // Accept size as a parameter
//   });
//
//   final bool dark;
//   final String imageUrl;         // Image URL
//   final String brand;            // Brand Name
//   final String productTitle;     // Product Title
//   final String size;             // Product Size
//   final String calories;             // Product Size
//
//   @override
//   Widget build(BuildContext context) {
//     final ProductController productController = Get.find<ProductController>();
//
//     return Row(
//       children: [
//         // Image
//         TRoundedImage(
//           imageurl: imageUrl,               // Use the passed image URL
//           width: 60,
//           isNetworkImage: true,
//           height: 60,
//           padding: EdgeInsets.all(TSizes.sm),
//           backgroundColor:
//           dark ? TColors.darkerGrey : TColors.light,
//         ),
//         const SizedBox(
//           width: TSizes.spaceBtwItems,
//         ),
//
//         // Title/Price & Size
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TBrandTitleWithVerification(
//              isVerified:  productController.currentProduct?.value['isVerified'] ?? false ,
//               title: brand,                  // Use the passed brand
//             ),
//             Flexible(
//                 child: TProductTitleText(
//                   title: productTitle,        // Use the passed product title
//                   maxLines: 1,
//                 )),
//             // Attributes (Size)
//             Text.rich(TextSpan(children: [
//               TextSpan(
//                   text: 'Size:  ',
//                   style: Theme.of(context).textTheme.bodySmall),
//               TextSpan(
//                   text: size,                  // Use the passed size
//                   style: Theme.of(context).textTheme.bodyLarge),
//
//             ])),
//             Text.rich(TextSpan(children: [
//               TextSpan(
//                   text: 'Calories:  ',
//                   style: Theme.of(context).textTheme.bodySmall),
//               TextSpan(
//                   text: calories,                  // Use the passed size
//                   style: Theme.of(context).textTheme.bodyLarge),
//
//             ]))
//           ],
//         )
//       ],
//     );
//   }
// }
