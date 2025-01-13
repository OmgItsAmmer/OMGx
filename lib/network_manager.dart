import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription; // Fixed line
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;
  @override
  void onInit() {
    _connectivitySubscription =  _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;
    if(_connectionStatus.value== ConnectivityResult.none){

    }
  }


  //Check the internet connection status
//Returns 'true if connected, 'false' otherwise
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if(result == ConnectivityResult.none)
      {
        return false;

      }
      else{
        return true;
      }
    } on PlatformException catch(_){
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }


}