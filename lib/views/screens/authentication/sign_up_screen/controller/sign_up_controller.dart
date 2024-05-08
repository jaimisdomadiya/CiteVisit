import 'dart:convert';
import 'dart:developer';

import 'package:cityvisit/apis/authentication/authentication_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/request/sign_up/sign_up_request.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpController extends GetxController with ValidationMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> businessNameFormKey = GlobalKey<FormState>();
  final AuthenticationApi _authentication = AuthenticationApi.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? user;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  bool isGoogleSignIn = true;

  Future<void> signUpApi(BuildContext context) async {
    Loader.show(context);

    late SignUpRequest signUpRequest;
    if (user != null) {
      signUpRequest = SignUpRequest(
          email: user?.email ?? '',
          password: password.text.trim(),
          managerName:
              isGoogleSignIn ? user?.displayName ?? '' : manager.text.trim(),
          businessName: businessName.text.trim(),
          phone: user?.phoneNumber ?? '',
          type: "1",
          tag: isGoogleSignIn ? 'google' : 'apple',
          socialId: user?.uid ?? '');
    } else {
      signUpRequest = SignUpRequest(
          email: email.text.trim(),
          password: password.text.trim(),
          businessName: businessName.text.trim(),
          managerName: manager.text.trim(),
          phone: phoneNo.text.trim(),
          type: "0",
          socialId: "");
    }

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

  Future<void> sendOtp(BuildContext context) async {
    Loader.show(context);

    var result = await _authentication.sendOtp(email.text.trim());

    result.when(
          (response) {
        Loader.dismiss(context);

        if (response.status) {
          Get.toNamed(Routes.otp, arguments: {
            "isFromSignUp": true,
            "email": email.text.trim(),
            "password": password.text.trim(),
            "bussiness_name": businessName.text.trim(),
            "manager_name": manager.text.trim(),
            "type": "0",
            "social_id": ""
          },
          );
        }
      },
          (error) {
        log(error.toString(), name: "response");
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  void signUpOnClick(BuildContext context) {
    if (formKey.currentState!.validate()) {
      sendOtp(context);
    }
  }

  void continueOnClick(BuildContext context) {
    if (businessNameFormKey.currentState!.validate()) {
      signUpApi(context);
    }
  }

  Future<void> googleSignup() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential result = await auth.signInWithCredential(authCredential);
        user = result.user;
        if (user != null) {
          isGoogleSignIn = true;
          Get.toNamed(Routes.businessName);
          // await signUpApi(Get.context!, user: user);
        }
      }
    } catch (e) {
      log(e.toString(), name: "Error");
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential result = await auth.signInWithCredential(oauthCredential);
      user = result.user;
      if (user != null) {
        isGoogleSignIn = false;
        log(user?.uid ?? '', name: "UID");
        log(user?.displayName ?? '', name: "displayName");
        log(user?.email ?? '', name: "email");
        Get.toNamed(Routes.businessName);
      }
      //
    } on FirebaseAuthException catch (e) {
      log(e.message ?? '', name: "FirebaseAuthException");
      Get.context!.showSnackBar(e.message ?? '');
    } on SignInWithAppleNotSupportedException catch (e) {
      log(e.message, name: "SignInWithAppleNotSupportedException");
      Get.context!.showSnackBar(e.message);
    } on UnknownSignInWithAppleException catch (e) {
      log(e.message ?? '', name: "UnknownSignInWithAppleException");
      Get.context!.showSnackBar(e.message ?? '');
    } on SignInWithAppleAuthorizationException catch (e) {
      log(e.message, name: "SignInWithAppleAuthorizationException");
      Get.context!.showSnackBar(e.message);
    }
  }
}
