import 'dart:convert';
import 'dart:developer';

import 'package:cityvisit/apis/authentication/authentication_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthenticationApi _authentication = AuthenticationApi.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isPasswordVisible = true.obs;
  User? user;

  Future<void> signInApi(BuildContext context) async {
    Loader.show(context);
    var result = await _authentication.signIn(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    result.when(
      (response) {
        preferences.token = response.token ?? '';
        preferences.isLogged = true;

        Loader.dismiss(context);
        Get.offAllNamed(Routes.bottomMenu);
      },
      (error) {
        log("response ==> $error");
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  Future<void> socialSignInApi(BuildContext context,
      {bool isFromGoogle = false}) async {
    Loader.show(context);
    var result = await _authentication.socialSignIn(
      email: user?.email ?? '',
      socialId: user?.uid ?? '',
    );

    result.when(
      (response) {
        if (response.status) {
          preferences.token = response.data.toString();
          preferences.isLogged = true;

          Loader.dismiss(context);
          Get.offAllNamed(Routes.bottomMenu);
        } else {
          Loader.dismiss(context);
          if (response.data.toString() == "0") {
            Get.toNamed(Routes.businessName,
                arguments: {"user": user, "isGoogleSignIn": isFromGoogle});
          } else {
            context.showSnackBar(response.message);
          }
        }
      },
      (error) {
        log("response ==> $error");
        context.showSnackBar(error);
        Loader.dismiss(context);
      },
    );
  }

  Future<void> signInOnClick(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await signInApi(context);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
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
          await socialSignInApi(context, isFromGoogle: true);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.context!.showSnackBar(e.message ?? '');
    } catch (e) {
      Get.context!.showSnackBar(e.toString());
      log(e.toString(), name: "Error");
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple(BuildContext context) async {
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
        log(user?.uid ?? '', name: "UID");
        log(user?.displayName ?? '', name: "displayName");
        log(user?.email ?? '', name: "email");
        await socialSignInApi(context);
      }
      //
    } on FirebaseAuthException catch (e) {
      log(e.message ?? '', name: "FirebaseAuthException");
      Get.context!.showSnackBar(e.message ?? '');
    } on SignInWithAppleNotSupportedException catch (e) {
      log(e.message ?? '', name: "SignInWithAppleNotSupportedException");
      Get.context!.showSnackBar(e.message);
    } on UnknownSignInWithAppleException catch (e) {
      log(e.message ?? '', name: "UnknownSignInWithAppleException");
      Get.context!.showSnackBar(e.message ?? '');
    } on SignInWithAppleAuthorizationException catch (e) {
      log(e.message ?? '', name: "SignInWithAppleAuthorizationException");
      Get.context!.showSnackBar(e.message);
    }
  }
}
