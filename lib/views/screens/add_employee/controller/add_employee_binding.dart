import 'package:cityvisit/views/screens/add_employee/controller/add_employee_controller.dart';
import 'package:get/get.dart';

class AddEmployeeBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEmployeeController>(() => AddEmployeeController());
  }
}
