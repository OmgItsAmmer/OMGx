import 'package:admin_dashboard_v3/common/widgets/images/t_circular_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/user/user_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../images/t_rounded_image.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key,  this.scaffoldKey});
final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.find<NotificationController>();
    final UserController userController =
    Get.find<UserController>();
    final MediaController mediaController = Get.find<MediaController>();


    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey,width: 1)),
      ),
      padding:  const EdgeInsets.symmetric(horizontal: TSizes.md,vertical: TSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: !TDeviceUtils.isDesktopScreen(context) ? IconButton(onPressed: () => scaffoldKey?.currentState?.openDrawer(), icon:const Icon(Iconsax.menu)) : null,
        title: TDeviceUtils.isDesktopScreen(context) ?  SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal),hintText: 'Search Anything'),
          ),
        ) : null,
actions: [
      if(!TDeviceUtils.isDesktopScreen(context)) IconButton(onPressed: (){}, icon: const Icon(Iconsax.search_normal)),
      IconButton(onPressed: (){
        notificationController.showNotificationsBottomSheet();
      }, icon: const Icon(Iconsax.notification  )),
      const SizedBox(width: TSizes.spaceBtwItems/2,),
      //User Data
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
                () {
              final image = mediaController.displayImage.value;

              if (image != null && mediaController.displayImageOwner == MediaCategory.users.toString().split('.').last) {
                //print(image.filename);
                return FutureBuilder<String?>(
                  future: mediaController.getImageFromBucket(
                    MediaCategory.users.toString().split('.').last,
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
                        width: 150,
                        height: 150,
                        imageurl: snapshot.data!,
                      );
                    }
                  },
                );
              }
              // Check if selectedImages is empty
              return FutureBuilder<String?>(
                future: mediaController.fetchAndCacheProfileImage(userController.currentUser.value.userId, MediaCategory.users.toString().split('.').last),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const TShimmerEffect(width: 80, height: 80); // Show shimmer while loading
                  } else if (snapshot.hasError) {
                    return const Text('Error loading image'); // Handle error case
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return TCircularImage(
                      image: snapshot.data!,
                      isNetworkImage: true,
                      width: 80,
                      height: 80,
                    //  imageurl: ,
                    );
                  } else {
                    return const Text('No image available'); // Handle case where no image is available
                  }
                },
              );
            },
          ),
          const SizedBox(width: TSizes.sm,),
          Obx(
        () {
          if(userController.profileLoading.value)
            {
              return const TShimmerEffect(width: 20, height: 20);
            }
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userController.currentUser.value.fullName, style: Theme.of(context).textTheme.titleLarge,),
                Text(userController.currentUser.value.email, style: Theme.of(context).textTheme.labelMedium,),

              ],
            ); }
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
