import 'package:ecommerce_dashboard/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/strip_loader.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
// ignore: unused_import
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/shop/shop_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../images/t_rounded_image.dart';
import 'menu/menu_item.dart';

class TSideBar extends StatelessWidget {
  const TSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final MediaController mediaController = Get.find<MediaController>();

    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    final image = mediaController.displayImage.value;

                    if (image != null &&
                        mediaController.displayImageOwner ==
                            MediaCategory.shop.toString().split('.').last) {
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          MediaCategory.shop.toString().split('.').last,
                          image.filename ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TShimmerEffect(width: 80, height: 80);
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return const Icon(Icons.error);
                          } else {
                            return TRoundedImage(
                              isNetworkImage: true,
                              width: 80,
                              height: 80,
                              imageurl: snapshot.data!,
                            );
                          }
                        },
                      );
                    }

                    /// ✅ Use cached sidebar image if available
                    return Obx(() {
                      if (mediaController.cachedSidebarImage.value != null) {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 80,
                          height: 80,
                          imageurl: mediaController.cachedSidebarImage.value!,
                        );
                      }

                      return FutureBuilder<String?>(
                        future: mediaController.fetchAndCacheSidebarImage(
                          shopController.selectedShop?.value.shopId ?? -1,
                          MediaCategory.shop.toString().split('.').last,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TShimmerEffect(width: 80, height: 80);
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return const Text('No image available');
                          } else {
                            return TCircularImage(
                              isNetworkImage: true,
                              width: 80,
                              height: 80,
                              image: snapshot.data!,
                            );
                          }
                        },
                      );
                    });
                  }),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Obx(() {
                    if (shopController.isLoading.value) {
                      return const TStripLoader(width: 80, height: 40);
                    }

                    return Text(
                      shopController.selectedShop?.value.shopname ?? '',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 2,
                    );
                  })
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MENU',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),

                    //Menu Items
                    const TMenuItem(
                      icon: Iconsax.status_up,
                      itemName: 'DashBoard',
                      route: TRoutes.dashboard,
                    ),
                    Text(
                      'BUY/SELL',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    const TMenuItem(
                      icon: Iconsax.money_send,
                      itemName: 'Sale',
                      route: TRoutes.sales,
                    ),
                    const TMenuItem(
                      icon: Iconsax.receive_square,
                      itemName: 'Purchase',
                      route: TRoutes.purchaseSales,
                    ),
                    Text(
                      'LOGS',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    const TMenuItem(
                      icon: Iconsax.box_time,
                      itemName: 'Orders',
                      route: TRoutes.orders,
                    ),
                    const TMenuItem(
                      icon: Iconsax.buy_crypto,
                      itemName: 'Purchases',
                      route: TRoutes.purchases,
                    ),
                    const TMenuItem(
                      icon: Iconsax.receipt_1,
                      itemName: 'Account Book',
                      route: TRoutes.accountBook,
                    ),
                    const TMenuItem(
                      icon: Iconsax.ticket_star,
                      itemName: 'Expenses',
                      route: TRoutes.expenseScreen,
                    ),
                    Text(
                      'PEOPLE',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),

                    const TMenuItem(
                      icon: Iconsax.user_tag,
                      itemName: 'Customers',
                      route: TRoutes.customer,
                    ),
                    const TMenuItem(
                      icon: Iconsax.profile_add,
                      itemName: 'Vendors',
                      route: TRoutes.vendor,
                    ),
                    const TMenuItem(
                      icon: Iconsax.user_octagon,
                      itemName: 'Salesman',
                      route: TRoutes.salesman,
                    ),
                    Text(
                      'INVENTORY',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    const TMenuItem(
                      icon: Iconsax.box_search,
                      itemName: 'Products',
                      route: TRoutes.products,
                    ),
                    const TMenuItem(
                      icon: Iconsax.bookmark_2,
                      itemName: 'Brands',
                      route: TRoutes.brand,
                    ),
                    const TMenuItem(
                      icon: Iconsax.category,
                      itemName: 'Categories',
                      route: TRoutes.category,
                    ),

                    Text(
                      'OTHER',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    const TMenuItem(
                        icon: Iconsax.image,
                        itemName: 'Media',
                        route: TRoutes.mediaScreen),
                    const TMenuItem(
                      icon: Iconsax.chart_1,
                      itemName: 'Reports',
                      route: TRoutes.reportScreen,
                    ),

                    const TMenuItem(
                      icon: Iconsax.profile_circle,
                      itemName: 'Profile',
                      route: TRoutes.profileScreen,
                    ),
                    const TMenuItem(
                      icon: Iconsax.shop,
                      itemName: 'Store',
                      route: TRoutes.storeScreen,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
