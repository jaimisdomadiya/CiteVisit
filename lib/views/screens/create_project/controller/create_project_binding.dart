import 'package:cityvisit/views/screens/create_project/controller/create_project_controller.dart';
import 'package:get/get.dart';

class CreateProjectBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateProjectController>(() => CreateProjectController());
  }
}
