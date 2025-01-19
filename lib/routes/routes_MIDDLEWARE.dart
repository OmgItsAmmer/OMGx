import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TRouteMiddleeare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print('middleware called');
    const isAuthenticated = true;
    return isAuthenticated
        ? null
        : const RouteSettings(name: TRoutes.firstScreen);
  }
}
