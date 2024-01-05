import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class internetConnectionChecker {
  late StreamSubscription<ConnectivityResult> _connectionSubcription;

  bool status = false;

  Future<void> initConnevity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
      _checkConnectivityStatus(result);
    } on PlatformException catch (e) {
      print(e.details.toString());
    }
  }

  initSubscriptions() {
    _connectionSubcription =
        Connectivity().onConnectivityChanged.listen(_checkConnectivityStatus);
  }

  void _checkConnectivityStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile) {
      status = true;
    } else if (result == ConnectivityResult.wifi) {
      status = true;
    } else if (result == ConnectivityResult.ethernet) {
      status = true;
    } else {
      status = false;
    }
  }

  bool getConnectionStatus() {
    return status;
  }

  void stopScubscription() {
    _connectionSubcription.cancel();
  }
}
