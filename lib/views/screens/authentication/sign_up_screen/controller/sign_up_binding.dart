import 'package:cityvisit/views/screens/authentication/sign_up_screen/controller/sign_up_controller.dart';
import 'package:get/get.dart';

class SignUpBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
