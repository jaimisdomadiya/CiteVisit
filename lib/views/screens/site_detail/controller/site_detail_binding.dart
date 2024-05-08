import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:get/get.dart';

class SiteDetailBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteDetailController>(() => SiteDetailController());
  }
}
