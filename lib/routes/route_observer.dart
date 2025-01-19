import 'package:admin_dashboard_v3/common/widgets/layout/sidebar/controller/sidebar_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RouteObserver extends GetObserver{


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
  void didPush(Route route, Route previousRoute) {
    final sidebarController = Get.put(SideBarController());

    if(route != null )
      {
        //check the route name and update the active item in the sidebar accordingly
        for(var routeName in TRoutes.sidebarMenuItems)
          {
            if(route.settings.name == routeName)
              {
                sidebarController.activeItem.value = routeName;
              }
          }
      }
  }
}

