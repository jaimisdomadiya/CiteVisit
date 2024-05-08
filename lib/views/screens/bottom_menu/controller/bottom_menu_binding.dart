import 'package:cityvisit/views/screens/bottom_menu/controller/bottom_menu_controller.dart';
import 'package:get/get.dart';

class BottomMenuBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomMenuController>(() => BottomMenuController());
  }
}
