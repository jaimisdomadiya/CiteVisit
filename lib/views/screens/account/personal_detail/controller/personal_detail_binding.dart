import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:get/get.dart';

class PersonalBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalDetailController>(() => PersonalDetailController());
  }
}
