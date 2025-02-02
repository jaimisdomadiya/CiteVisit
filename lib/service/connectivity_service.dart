part of 'services.dart';

class ConnectivityService {
  ConnectivityService._();

  static Future<bool> get isConnected async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
