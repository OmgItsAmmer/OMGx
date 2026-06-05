import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_dashboard/platform/internet_reachability.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;
  final RxBool hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;

    if (result == ConnectivityResult.none) {
      hasInternet.value = false;
      _goToOfflineScreen();
      return;
    }

    final isOnline = await _hasActualInternet();
    hasInternet.value = isOnline;

    if (!isOnline) {
      _goToOfflineScreen();
    }
  }

  void _goToOfflineScreen() {
    if (Get.currentRoute == TRoutes.UnkownRoute) return;
    Get.offAllNamed(TRoutes.UnkownRoute);
  }

  Future<bool> _hasActualInternet() async {
    if (_connectionStatus.value == ConnectivityResult.none) {
      return false;
    }
    return canReachInternet();
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) return false;
      _connectionStatus.value = result;
      return await _hasActualInternet();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[NetworkManager] connectivity check failed: $e');
      }
      // Web: connectivity plugin can throw; still allow login if browser is online.
      return kIsWeb ? true : false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
