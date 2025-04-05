import 'package:admin_dashboard_v3/common/widgets/images/t_circular_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
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
      shape:  const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child:   SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: TSizes.spaceBtwSections,),
               Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Obx(() {
                    final image = mediaController.displayImage.value;

                    if (image != null) {
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          MediaCategory.shop.toString().split('.').last,
                          image.filename ?? '',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const TShimmerEffect(width: 80, height: 80);
                          } else if (snapshot.hasError || snapshot.data == null) {
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
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const TShimmerEffect(width: 80, height: 80);
                          } else if (snapshot.hasError || snapshot.data == null) {
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

                  const SizedBox(width: TSizes.spaceBtwItems,),
                  Obx((){

                    if(shopController.isLoading.value){
                      return const TShimmerEffect(width: 80, height: 80);
                    }

                    return Text(shopController.selectedShop?.value.shopname ?? '',style: Theme.of(context).textTheme.headlineLarge,);

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
                    Text('MENU',style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),),


                    //Menu Items
                 const TMenuItem(icon: Iconsax.status,itemName: 'DashBoard', route: TRoutes.dashboard,),
                 const TMenuItem(icon: Iconsax.money,itemName: 'Sales', route: TRoutes.sales,),
                 const TMenuItem(icon: Iconsax.receipt_item,itemName: 'Orders', route: TRoutes.orders,),
                 const TMenuItem(icon: Iconsax.box,itemName: 'Products', route: TRoutes.products,),
                 const TMenuItem(icon: Iconsax.people,itemName: 'Customers', route: TRoutes.customer,),
                 const TMenuItem(icon: Iconsax.profile_2user,itemName: 'Salesman', route: TRoutes.salesman,),
                 const TMenuItem(icon: Iconsax.convert_3d_cube,itemName: 'Brands', route: TRoutes.brand,),
                 const TMenuItem(icon: Iconsax.folder_open,itemName: 'Categories', route: TRoutes.category,),

                   Text('OTHER',style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),),
                    const TMenuItem(icon: Iconsax.image,itemName: 'Media', route: TRoutes.mediaScreen,),
                    const TMenuItem(icon: Iconsax.note ,itemName: 'Reports', route: TRoutes.reportScreen,),
                    const TMenuItem(icon: Iconsax.note ,itemName: 'Expenses', route: TRoutes.expenseScreen,),
                    const TMenuItem(icon: Iconsax.profile_circle,itemName: 'Profile', route: TRoutes.profileScreen,),
                    const TMenuItem(icon: Iconsax.shop,itemName: 'Store', route: TRoutes.storeScreen,),



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

