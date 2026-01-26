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
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Get Supabase credentials from .env
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

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
