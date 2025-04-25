import 'package:admin_dashboard_v3/supabase_strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'repositories/authentication/authicatioon_repository.dart';
import 'repositories/signup/signup_repository.dart';

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   //minimumSize: Size(800, 800),
  //   center: true,
  //   title: "OMG POS : NEXUS",
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  // remove # sign from url
  setPathUrlStrategy();
  //Get Local Storage
  await GetStorage.init();

  //Await Splash until other issues Load
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Supabase.initialize(
    url: SupabaseStrings.projectUrl,
    anonKey: SupabaseStrings.anonKey,
  );

  // Initialize repositories
  Get.put(SignUpRepository());
  Get.put(AuthenticationRepository());

  runApp(const App());
}
