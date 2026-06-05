import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_dashboard/platform/internet_reachability.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../supabase_strings.dart';

/// Handles Supabase reachability and retry helpers (web-safe — no dart:io).
class SupabaseNetworkManager {
  static final SupabaseNetworkManager _instance =
      SupabaseNetworkManager._internal();
  static SupabaseNetworkManager get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;
  final RxBool _isSupabaseConnected = true.obs;

  SupabaseNetworkManager._internal();

  void initialize() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Timer.periodic(
      const Duration(minutes: 2),
      (_) => checkSupabaseConnection(),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;
    if (result == ConnectivityResult.none) {
      _isSupabaseConnected.value = false;
      if (kDebugMode) {
        debugPrint('[SupabaseNetworkManager] No network connection');
      }
    } else {
      await checkSupabaseConnection();
    }
  }

  Future<bool> isNetworkConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[SupabaseNetworkManager] connectivity error: $e');
      }
      return kIsWeb;
    }
  }

  Future<bool> checkSupabaseConnection() async {
    if (!await isNetworkConnected()) {
      _isSupabaseConnected.value = false;
      return false;
    }

    final url = SupabaseStrings.projectUrl;
    if (url.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SupabaseNetworkManager] SUPABASE_URL missing in .env');
      }
      _isSupabaseConnected.value = false;
      return false;
    }

    try {
      final uri = Uri.parse(url);
      final port = uri.hasPort
          ? uri.port
          : (uri.scheme == 'https' ? 443 : 80);
      final reachable = await canReachHost(uri.host, port);

      _isSupabaseConnected.value = reachable;
      return reachable;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SupabaseNetworkManager] connection check failed: $e');
      }
      _isSupabaseConnected.value = false;

      if (!kIsWeb && e is! TimeoutException) {
        TLoaders.errorSnackBar(
          title: 'Connection Issue',
          message:
              'Having trouble connecting to the server. Please check your connection.',
        );
      }
      return false;
    }
  }

  Future<T?> executeWithRetry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        if (!await isNetworkConnected()) {
          if (attempts == 0) {
            TLoaders.warningSnackBar(
              title: 'No Connection',
              message: 'Please check your internet connection',
            );
          }
          await Future.delayed(retryDelay);
          attempts++;
          continue;
        }
        return await operation();
      } catch (e) {
        attempts++;
        if (kDebugMode) {
          debugPrint(
            '[SupabaseNetworkManager] operation failed (attempt $attempts): $e',
          );
        }
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(
          Duration(seconds: retryDelay.inSeconds * attempts),
        );
      }
    }
    return null;
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
