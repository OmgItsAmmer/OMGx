
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/fullscreen/fullscreen_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/notification/notification_controller.dart';
import '../../../../controllers/search/search_controller.dart';
import '../../../../controllers/user/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../images/t_circular_image.dart';
import '../../images/t_rounded_image.dart';
import '../../search/search_overlay.dart';
import '../../shimmers/shimmer.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();
    final UserController userController = Get.find<UserController>();
    final MediaController mediaController = Get.find<MediaController>();
    final FullscreenController fullscreenController =
        Get.put(FullscreenController());
    // Use the singleton instance
    final TSearchController searchController = TSearchController.instance;

    return Stack(
      children: [
        // Main header content
        Container(
          decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md, vertical: TSizes.sm),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: !TDeviceUtils.isDesktopScreen(context)
                ? IconButton(
                    onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                    icon: const Icon(Iconsax.menu))
                : null,
            title: TDeviceUtils.isDesktopScreen(context)
                ? SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: searchController.searchController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.search_normal),
                          hintText: 'Search Anything'),
                      onChanged: (value) {
                        // // Show search overlay when user types
                        // if (!searchController.isSearchOverlayVisible.value) {
                        //   searchController.toggleSearchOverlay();
                        // }
                        // searchController.filterSearchResults(value);
                      },
                      readOnly: false, // Allow direct input
                    ),
                  )
                : null,
            actions: [
              if (!TDeviceUtils.isDesktopScreen(context))
                IconButton(
                    onPressed: () {
                      // // Show search overlay when icon is tapped on mobile/tablet
                      // searchController.toggleSearchOverlay();
                      // // Make sure to focus on the search field after opening
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      // });
                    },
                    icon: const Icon(Iconsax.search_normal)),
              (TDeviceUtils.isDesktopScreen(context))
                  ? Obx(() => IconButton(
                        icon: Icon(
                          fullscreenController.isFullscreen.value
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                        ),
                        onPressed: fullscreenController.toggleFullscreen,
                      ))
                  : const SizedBox.shrink(),

              const SizedBox(
                width: TSizes.spaceBtwItems / 2,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                      onPressed: () {
                        notificationController.showNotifications();
                      },
                      icon: const Icon(Iconsax.notification)),
                  Obx(() {
                    final unreadCount = notificationController.unreadCount;
                    if (unreadCount > 0) {
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: TColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: TColors.white, width: 1.5),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    unreadCount > 9 ? '9+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: TColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems / 2,
              ),
              //User Data
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Obx(
                  () {
                    final image = mediaController.displayImage.value;

                    if (image != null &&
                        mediaController.displayImageOwner ==
                            MediaCategory.users.toString().split('.').last) {
                      //print(image.filename);
                      return FutureBuilder<String?>(
                        future: mediaController.getImageFromBucket(
                          MediaCategory.users.toString().split('.').last,
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
                      future: mediaController.fetchAndCacheProfileImage(
                          userController.currentUser.value.userId,
                          MediaCategory.users.toString().split('.').last),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(
                              width: 80,
                              height: 80); // Show shimmer while loading
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error loading image'); // Handle error case
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return TCircularImage(
                            image: snapshot.data!,
                            isNetworkImage: true,
                            width: 80,
                            height: 80,
                            //  imageurl: ,
                          );
                        } else {
                          return const Text(
                              'No image available'); // Handle case where no image is available
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  width: TSizes.sm,
                ),
                Obx(() {
                  if (userController.profileLoading.value) {
                    return const TShimmerEffect(width: 20, height: 20);
                  }
                  return (TDeviceUtils.isMobileScreen(context))
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userController.currentUser.value.fullName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              userController.currentUser.value.email,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        );
                })
              ])
            ],
          ),
        ),

        // Search overlay (visible when search is active)
        const TSearchOverlay(),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
