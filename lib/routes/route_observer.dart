import 'package:admin_dashboard_v3/common/widgets/layout/sidebar/controller/sidebar_controller.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/product/product_images_controller.dart';

class TRouteObserver extends GetObserver{


  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
      final sidebarController = Get.put(SideBarController());

        if(previousRoute != null)
        {
          // check the route name and update the active item in the sidebar accordingly
          for(var routeName in TRoutes.sidebarMenuItems) {
            if(previousRoute.settings.name == routeName) {
              sidebarController.activeItem.value = routeName;
            }
          }

        }

  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SideBarController());

    if (route != null) {
      // Check the route name and update the active item in the sidebar accordingly
      for (var routeName in TRoutes.sidebarMenuItems) {
        if (route.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }

      // TLoader.successSnackBar(title: 'worked outsidie');
      // // Run function when navigating to ProfileScreen
      // if (route.settings.name == TRoutes.profileScreen) {
      //   // fetchProfileImage();
      // }
      // if (route.settings.name == TRoutes.profileScreen) {
      // //  fetchStoreImage();
      // }
    }
  }





  }



