import 'package:admin_dashboard_v3/app.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/routes/routes_MIDDLEWARE.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repsonsive_screen.dart';
import '../views/orders/order_details/order_detail.dart';
import '../views/orders/order_details/responsive_screens/order_detail_desktop.dart';

class TAppRoutes {
  static final List<GetPage> pages = [

    GetPage(name: TRoutes.login, page: () => const LoginScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.responsiveScreenDesignScreen, page: () => const ResponsiveDesignScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.orders, page: () => const TOrderScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.orderDetails, page: () => const OrderDetailScreen(),middlewares: [TRouteMiddleeare()] ),


  ];
}
