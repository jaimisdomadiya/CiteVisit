import 'package:cityvisit/views/screens/photo/controller/photo_controller.dart';
import 'package:get/get.dart';

class PhotoBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoController>(() => PhotoController());
  }
}
