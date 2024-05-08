import 'package:cityvisit/views/screens/project_detail/controller/project_detail_controller.dart';
import 'package:get/get.dart';

class ProjectDetailBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDetailController>(() => ProjectDetailController());
  }
}
