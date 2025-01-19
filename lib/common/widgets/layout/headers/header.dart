import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../images/t_rounded_image.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key,  this.scaffoldKey});
final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey,width: 1)),
      ),
      padding:  const EdgeInsets.symmetric(horizontal: TSizes.md,vertical: TSizes.sm),
      child: AppBar(
        leading: !TDeviceUtils.isDesktopScreen(context) ? IconButton(onPressed: () => scaffoldKey?.currentState?.openDrawer(), icon:const Icon(Iconsax.menu)) : null,
        title: TDeviceUtils.isDesktopScreen(context) ?  SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
          ),
        ) : null,
actions: [
      if(!TDeviceUtils.isDesktopScreen(context)) IconButton(onPressed: (){}, icon: const Icon(Iconsax.search_normal)),
      IconButton(onPressed: (){}, icon: const Icon(Iconsax.notification  )),
      const SizedBox(width: TSizes.spaceBtwItems/2,),
      //User Data
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TRoundedImage(
            width: 40,
            padding: EdgeInsets.all(2),
            height: 40,
            imageurl: TImages.user,

          ),
          const SizedBox(width: TSizes.sm,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ammer Saeed', style: Theme.of(context).textTheme.titleLarge,),
              Text('ammersaeed21@gmail.com', style: Theme.of(context).textTheme.labelMedium,),

            ],
          )
    ]

      )

],

      ),
    ) ;
  }

  @override

  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight()+15);
}
