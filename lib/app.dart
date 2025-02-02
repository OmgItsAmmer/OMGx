import 'package:admin_dashboard_v3/routes/app_routes.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'common/widgets/containers/rounded_container.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        initialBinding: GeneralBindings(),
        getPages: TAppRoutes.pages,

        initialRoute: TRoutes.orders,
        unknownRoute: GetPage(
            name: '/page-not-found',
            page: () => const Scaffold(
                  body: Center(child: Text('Page not found')),
                )),
        );
  }
}


