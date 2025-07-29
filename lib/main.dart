import 'package:ecommerce_dashboard/utils/security/secure_keys.dart';
import 'package:ecommerce_dashboard/supabase_strings.dart';
import 'package:ecommerce_dashboard/utils/network/supabase_network_manager.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:async';

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

  // Only initialize window_manager for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
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
  }

  // remove # sign from url
  setPathUrlStrategy();
  //Get Local Storage
  await GetStorage.init();

  // // Initialize SecureKeys instance
  // final secureKeys = SecureKeys.instance;
  // await secureKeys.initialize();

  // Get Supabase credentials securely
  const supabaseUrl =
        SupabaseStrings.projectUrl;
  const supabaseAnonKey = SupabaseStrings.anonKey;

  // Initialize SupabaseNetworkManager first for better connection handling
  final networkManager = SupabaseNetworkManager.instance;
  networkManager.initialize();

  //Await Splash until other issues Load
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 10,
      ),
    );

    // Check connection after initialization
    if (!kDebugMode) {
      await networkManager.checkSupabaseConnection();
    }

    if (kDebugMode) {
      print('Supabase initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Supabase: $e');
    }
    // Add fallback initialization with increased timeout for release mode
    if (!kDebugMode) {
      try {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
      } catch (retryError) {
        if (kDebugMode) {
          print('Error on retry: $retryError');
        }
      }
    }
  }

  // Initialize repositories
  Get.put(SignUpRepository());
  Get.put(AuthenticationRepository());

  runApp(const App());
}
