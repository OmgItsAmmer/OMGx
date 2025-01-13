// import 'package:ecommerenceapp/features/shop/controllers/product_controller.dart';
// import 'package:ecommerenceapp/features/shop/controllers/wishlist_controller.dart';
// import 'package:ecommerenceapp/utils/effects/shimmer%20effect.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../features/personalization/controllers/user_controller.dart';
// import '../../../../features/shop/controllers/brand_controller.dart';
// import '../../../../main.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../layout/grid_layout.dart';
// import '../product_cards/product_card_vertical.dart';
//
// class TSortableProducts extends StatelessWidget {
//   const TSortableProducts({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final UserController userController = Get.find<UserController>();
//     final WishlistController wishListController = Get.find<WishlistController>();
//
//     final ProductController productController = Get.find<ProductController>();
//     productController.fetchCurrentBrandProducts();
//     return Column(
//       children: [
//         //Drop Down
//         DropdownButtonFormField(
//             decoration: InputDecoration(prefixIcon: Icon(Iconsax.sort)),
//             items: [
//               'Names',
//               'Higher Price',
//               'Lower Price',
//               "Sale",
//               "Newest",
//               "Popularity",
//             ]
//                 .map((option) =>
//                     DropdownMenuItem(value: option, child: Text(option)))
//                 .toList(),
//             onChanged: (value) {}),
//         SizedBox(
//           height: TSizes.spaceBtwSections,
//         ),
//         //Products
//         Obx(
//           () => TGridLayout(
//               itemCount: productController.currentBrandProducts.length,
//               itemBuilder: (_, index) {
//                 if (productController.isLoading.value) {
//                   return Center(child: TShimmerEffect(width: 80, height: 80));
//                 }
//                 if (productController.currentBrandProducts.isEmpty) {
//                   return Center(child: Text("No products"));
//                 }
//
//                 final product = productController.currentBrandProducts[index];
//
//                 return  TProductCardVertical(
//                   title: product["name"],
//                   brand: product["brand"],
//                   product_id: product["product_id"],
//                   price: product["sale_price"],
//                   isFavorite: RxBool(
//                     wishListController.isProductInWishList(
//                       product['product_id'],
//                       userController.current_user?.value['user_id'],
//                     ),
//                   ),
//                   isNetworkImage: true,
//                   imageUrl: supabase
//                       .storage
//                       .from('thumbnails')
//                       .getPublicUrl(product["thumbnail"]),
//                   WishListOnPressed: () {
//                     if (!wishListController.isProductInWishList(
//                       product['product_id'],
//                       userController.current_user?.value['user_id'],
//                     )) {
//                       // Add product to wishlist
//                       wishListController.addItemsToWishList(
//                         product['product_id'],
//                         userController.current_user?.value['user_id'],
//                       );
//                     } else {
//                       // Remove product from wishlist
//                       wishListController.removeItemFromWishList(
//                         product['product_id'],
//                         userController.current_user?.value['user_id'],
//                       );
//                     }
//                   },
//                 );
//               }),
//         )
//       ],
//     );
//   }
// }
