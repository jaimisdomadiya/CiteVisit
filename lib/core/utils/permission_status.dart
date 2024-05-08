part of 'utils.dart';

class CheckPermissionStatus {
  CheckPermissionStatus._();

  static final ImagePicker _picker = ImagePicker();

  static Future<bool> checkCameraPermissionStatus() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus.isGranted) {
      return true;
    } else if (cameraPermissionStatus.isPermanentlyDenied ||
        cameraPermissionStatus.isDenied) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  static Future<bool> checkGalleryPermissionStatus() async {
    late PermissionStatus photosPermissionStatus;
    if (Platform.isAndroid) {
      int? sdkInt = await DeviceInfoData.getDeviceSdkInt();
      if ((sdkInt ?? 0) >= 33) {
        log("Permission.photos", name: "Permission");
        photosPermissionStatus = await Permission.photos.request();
      } else {
        log("Permission.storage", name: "Permission");

        photosPermissionStatus = await Permission.storage.request();

      }
    } else {
      photosPermissionStatus = await Permission.photos.request();
      log(photosPermissionStatus.toString(), name: "Permission");

    }

    if (photosPermissionStatus.isGranted || photosPermissionStatus.isLimited) {
      return true;
    } else if (photosPermissionStatus.isPermanentlyDenied ||
        photosPermissionStatus.isDenied) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  static Future<File?> pickImage(ImageSource source) async {
    try {
      XFile? xFile = await _picker.pickImage(source: source);
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
