import 'package:ecommerce_dashboard/routes/app_routes.dart';
import 'package:ecommerce_dashboard/routes/route_observer.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/routes/routes_MIDDLEWARE.dart';
import 'package:ecommerce_dashboard/utils/theme/theme.dart';
import 'package:ecommerce_dashboard/views/unkown_route.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
// ignore: unused_import
import 'common/widgets/containers/rounded_container.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      getPages: TAppRoutes.pages,
      initialRoute: TRoutes.splashScreen,
      navigatorKey: navigatorKey,
      navigatorObservers: [TRouteObserver()],
      unknownRoute: GetPage(
          name: TRoutes.UnkownRoute,
          page: () => const UnkownRoute(),
          middlewares: [TRouteMiddleware()]),
    );
  }
}
