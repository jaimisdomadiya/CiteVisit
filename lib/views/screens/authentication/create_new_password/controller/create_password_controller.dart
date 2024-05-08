import 'package:cityvisit/apis/authentication/authentication_api.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePasswordController extends GetxController {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  final AuthenticationApi _authentication = AuthenticationApi.instance;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments['email'];
  }

  Future<void> createPasswordApi(BuildContext context) async {
    Loader.show(context);

    var result = await _authentication.createNewPassword(
      password: password.text.trim(),
      email: email,
    );

    result.when(
      (response) {
        context.showSnackBar(response);

        Loader.dismiss(context);
        Get.offAllNamed(Routes.signIn);
      },
      (error) {
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  void submitOtpOnClick(BuildContext context) {
    if (formKey.currentState!.validate()) {
      createPasswordApi(context);
      // Get.offAllNamed(Routes.signIn);
    }
  }
}
