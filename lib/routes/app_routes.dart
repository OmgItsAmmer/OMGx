import 'package:admin_dashboard_v3/app.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/routes/routes_MIDDLEWARE.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repsonsive_screen.dart';

class TAppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.firstScreen, page: () => const Scaffold(body: Text('my dick'),),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.login, page: () => const LoginScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.responsiveScreenDesignScreen, page: () => const ResponsiveDesignScreen(),middlewares: [TRouteMiddleeare()] ),


  ];
}
