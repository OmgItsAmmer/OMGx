
import 'package:admin_dashboard_v3/repositories/authentication/authicatioon_repository.dart';
import 'package:admin_dashboard_v3/supabase_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';



// Get a reference your Supabase client
final supabase = Supabase.instance.client;

Future<void> main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  //
  // // Set the window to be fullscreen
  // windowManager.waitUntilReadyToShow().then((_) async {
  //   await windowManager.setFullScreen(true);
  // });
  //Widget Binding

  WidgetsFlutterBinding.ensureInitialized();

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
  // .then((_) => Get.put(AuthenticationRepository()));
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  //     .then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  runApp(const App());
}
