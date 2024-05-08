import 'package:cityvisit/views/screens/authentication/otp_verification/controller/otp_verification_controller.dart';
import 'package:get/get.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController());
  }
}
