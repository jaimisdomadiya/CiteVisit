import 'package:cityvisit/views/screens/authentication/sign_in_screen/controller/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
