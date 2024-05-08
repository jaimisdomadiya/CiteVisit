import 'package:cityvisit/views/screens/authentication/create_new_password/controller/create_password_controller.dart';
import 'package:get/get.dart';

class CreatePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePasswordController>(() => CreatePasswordController());
  }
}
