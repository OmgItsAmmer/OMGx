import 'package:admin_dashboard_v3/common/widgets/images/t_circular_image.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'menu/menu_item.dart';

class TSideBar extends StatelessWidget {
  const TSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape:  const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child:   SingleChildScrollView(
          child: Column(
            children: [
              const TCircularImage(
                width: 100,
                height: 100,
                image: TImages.darkAppLogo,
                isNetworkImage: false,
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

