part of 'utils.dart';

class DeviceInfoData {
  DeviceInfoData._();

  static Future<int?> getDeviceSdkInt() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log('${androidInfo.version.sdkInt}', name: "android version");
        return androidInfo.version.sdkInt;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
