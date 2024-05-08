import 'dart:developer';

import 'package:cityvisit/apis/profile/profile_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomMenuController extends GetxController {
  final ProfileApi _profileApi = ProfileApi.instance;
  RxBool isLoading = false.obs;

  Future<void> getProfile({bool isLoaderShow = false}) async {
    if (isLoaderShow) {
      isLoading.value = true;
    }
    var result = await _profileApi.getProfile();
    result.when(
      (response) {
        preferences.businessName = response.bussinessName ?? '';
        preferences.managerName = response.managerName ?? '';
        preferences.email = response.email ?? '';
        preferences.password = response.password ?? '';
        preferences.profilePic = response.profilePic ?? '';
        preferences.businessUserId = response.id ?? '';
        preferences.isSocialLogin = response.type == "0" ? true : false;
        UserData().userName.value = response.managerName ?? '';
        UserData().email.value = response.email ?? '';
        UserData().profileImage.value = response.profilePic ?? '';
        UserData().projectCount.value = response.projectCount ?? '';
        UserData().siteCount.value = response.siteCount ?? '';
        UserData().memberCount.value = response.employeeCount ?? '';
        if (isLoaderShow) {
          isLoading.value = false;
        }
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        if (isLoaderShow) {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> logOut(BuildContext context) async {
    Loader.show(context);
    var result = await _profileApi.logOut();
    result.when(
      (response) async {
        Loader.dismiss(context);
        Get.context!.showSnackBar(response.message);

        await preferences.clear();

        Get.offAllNamed(Routes.signIn);
      },
      (error) {
        Loader.dismiss(context);

        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }
}
