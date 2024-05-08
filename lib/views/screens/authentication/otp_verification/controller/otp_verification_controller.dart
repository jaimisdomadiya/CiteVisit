import 'dart:async';
import 'dart:developer';

import 'package:cityvisit/apis/authentication/authentication_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/notification_service/firebase_notification.dart';
import 'package:cityvisit/modals/request/sign_up/sign_up_request.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/service/services.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OtpVerificationFrom { signUp, resetPassword }

class OtpVerificationController extends GetxController {
  final TextEditingController otpCode = TextEditingController();
  final AuthenticationApi _authentication = AuthenticationApi.instance;

  FocusNode otpFocusNode = FocusNode();
  RxInt seconds = 60.obs;
  late Timer timer;
  RxString emailValue = RxString('');
  late OtpVerificationFrom otpVerificationFrom;
  late SignUpRequest signUpRequest;

  void startTimer() {
    seconds.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds.value == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    emailValue.value = Get.arguments['email'];
    otpVerificationFrom = Get.arguments['isFromSignUp']
        ? OtpVerificationFrom.signUp
        : OtpVerificationFrom.resetPassword;
    if (Get.arguments['isFromSignUp']) {
      signUpRequest = SignUpRequest.fromJson(Get.arguments);
    }
  }

  Future<void> otpVerificationApi(BuildContext context) async {
    Loader.show(context);

    var result = await _authentication.otpVerify(
        otp: otpCode.text.trim(), email: emailValue.value);

    result.when(
      (response) {
        Loader.dismiss(context);
        if (otpVerificationFrom == OtpVerificationFrom.signUp) {
          Get.offAllNamed(Routes.bottomMenu);
        } else {
          Get.toNamed(Routes.createNewPassword,
              arguments: {"email": emailValue.value});
        }
      },
      (error) {
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  Future<void> signUpApi(BuildContext context) async {
    Loader.show(context);

    signUpRequest.otp = otpCode.text;
    signUpRequest.deviceToken = PushNotificationService.firebaseToken;

    var result = await _authentication.signUp(signUpRequest);

    result.when(
      (response) {
        preferences.token = response.token ?? '';
        preferences.id = response.id ?? '';
        preferences.isLogged = true;
        Loader.dismiss(context);

        Get.offAllNamed(Routes.bottomMenu);
      },
      (error) {
        log(error.toString(), name: "response");
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  Future<void> onVerifyOtp(BuildContext context) async {
    if (otpCode.text.length == 4) {
      if (await ConnectivityService.isConnected) {
        if (otpVerificationFrom == OtpVerificationFrom.signUp) {
          signUpApi(context);
        } else {
          otpVerificationApi(context);
        }
      } else {
        context.showSnackBar(kNoConnectionMessage);
      }
    } else {
      context.showSnackBar('Enter 4 digit otp code');
    }
  }

  Future<void> resendOtpApi(BuildContext context) async {
    Loader.show(context);

    var result = await _authentication.resetPassword(
      email: emailValue.value,
    );

    result.when(
      (response) {
        context.showSnackBar(response);
        Loader.dismiss(context);
        Get.toNamed(
          Routes.otp,
          arguments: {"email": emailValue.value, "isFromSignUp": false},
        );
      },
      (error) {
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }
}
