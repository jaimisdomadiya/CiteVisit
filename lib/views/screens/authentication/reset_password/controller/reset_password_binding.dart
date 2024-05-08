import 'package:cityvisit/views/screens/authentication/reset_password/controller/reset_password_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}
