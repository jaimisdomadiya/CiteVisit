import 'package:cityvisit/apis/authentication/authentication_api.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  final AuthenticationApi _authentication = AuthenticationApi.instance;

  Future<void> resetPasswordApi(BuildContext context) async {
    Loader.show(context);

    var result = await _authentication.resetPassword(
      email: email.text.trim(),
    );

    result.when(
      (response) {
        context.showSnackBar(response);
        Loader.dismiss(context);
        Get.toNamed(
          Routes.otp,
          arguments: {"email": email.text.trim(), "isFromSignUp": false},
        );
      },
      (error) {
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  void sendOtpOnClick(BuildContext context) {
    if (formKey.currentState!.validate()) {
      resetPasswordApi(context);
      // Get.toNamed(
      //   Routes.otp,
      //   arguments: {"email": email.text.trim(), "isFromSignUp": false},
      // );
    }
  }
}
