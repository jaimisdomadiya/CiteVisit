import 'dart:developer';
import 'dart:io';

import 'package:cityvisit/apis/profile/profile_api.dart';
import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/notification/notification_modal.dart';
import 'package:cityvisit/modals/request/update_profile/update_profile_request.dart';
import 'package:cityvisit/modals/sign_up/sign_up_modal.dart';
import 'package:cityvisit/views/widgets/image_picker_bottomsheet.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';

class PersonalDetailController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  HtmlEditorController controller = HtmlEditorController();

  RxList<NotificationModal> notificationList = <NotificationModal>[].obs;

  final ProfileApi _profileApi = ProfileApi.instance;
  Rx<File> profileImage = Rx(File(''));
  final ProjectApi _projectApi = ProjectApi.instance;
  RxString profileImageUrl = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isOldPasswordVisible = true.obs;
  RxBool isNewPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  RxBool isTermsAndConditionsLoading = true.obs;
  RxBool isInquiryValidate = false.obs;

  String termsAndConditionData = '';

  @override
  void onInit() {
    super.onInit();
    email.text = preferences.email;
    manager.text = preferences.managerName;
    profileImageUrl.value = preferences.profilePic;
  }

  Future<void> updateProfile(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      Loader.show(context);
      var result = await _profileApi.updateProfile(
        UpdateProfileRequest(
            email: email.text.trim(),
            managerName: manager.text.trim(),
            businessName: preferences.businessName,
            password: password.text.trim(),
            profilePic: profileImageUrl.value),
      );
      result.when(
        (response) {
          Loader.dismiss(context);

          if (response.status) {
            SignUpModal profileModal = SignUpModal.fromJson(response.data);
            preferences.managerName = manager.text.trim();
            preferences.email = email.text.trim();
            preferences.password = password.text.trim();
            preferences.profilePic = profileImageUrl.value;
            UserData().userName.value = manager.text.trim();
            UserData().email.value = email.text.trim();
            UserData().profileImage.value = profileImageUrl.value;
            preferences.token = profileModal.token ?? '';
            Get.context!.showSnackBar(response.message);
            log(profileImageUrl.value, name: "profileImageUrl");
            log(preferences.profilePic, name: "preferences.profilePic");
            Get.back();
          } else {
            Loader.dismiss(context);
            Get.context!.showSnackBar(response.message);
          }
        },
        (error) {
          Loader.dismiss(context);

          log("response ==> $error");
          Get.context!.showSnackBar(error);
        },
      );
    }
  }

  Future<void> changePassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      Loader.show(context);
      var result = await _profileApi.updatePassword(
          email.text.trim(), oldPassword.text.trim(), password.text.trim());
      result.when(
        (response) {
          Loader.dismiss(context);
          if (response.status) {
            Get.context!.showSnackBar(response.message);
            Get.back();
          } else {
            Get.context!.showSnackBar(response.message);
          }
        },
        (error) {
          Loader.dismiss(context);
          Get.context!.showSnackBar(error);
        },
      );
    }
  }

  Future<void> sendInquiry(BuildContext context) async {
    Loader.show(context);
    String data = await controller.getText();

    var result = await _profileApi.supportRequest(data, "0");
    result.when(
      (response) {
        Loader.dismiss(context);

        if (response.status) {
          Get.context!.showSnackBar(response.message);
          Get.back();
        } else {
          Get.context!.showSnackBar(response.message);
        }
      },
      (error) {
        Loader.dismiss(context);

        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> termsAndConditions(BuildContext context) async {
    isTermsAndConditionsLoading.value = true;
    var result = await _profileApi.termsAndConditions();
    result.when(
      (response) {
        termsAndConditionData = response;
        isTermsAndConditionsLoading.value = false;
      },
      (error) {
        Loader.dismiss(context);

        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> notification(BuildContext context) async {
    Loader.show(context);

    var result = await _profileApi.notification();
    result.when(
          (response) {
        notificationList.value = List.from(response);
        Loader.dismiss(context);
      },
          (error) {
        Loader.dismiss(context);

        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  void bottomSheet() {
    Get.bottomSheet(
      ImageBottomSheet(
        galleryOnTap: () async {
          bool status =
              await CheckPermissionStatus.checkGalleryPermissionStatus();
          if (status) {
            File? file =
                await CheckPermissionStatus.pickImage(ImageSource.gallery);
            if (file != null) {
              profileImage.value = file;
              Get.back();
              await uploadImage(Get.context!);
              log(file.path, name: "Image Path");
            }
          }
        },
        cameraOnTap: () async {
          bool status =
              await CheckPermissionStatus.checkCameraPermissionStatus();
          if (status) {
            File? file = await CheckPermissionStatus.pickImage(
              ImageSource.camera,
            );
            if (file != null) {
              profileImage.value = file;
              Get.back();
              log(file.path, name: "Image Path");
              await uploadImage(Get.context!);
            }
          }
        },
      ),
    );
  }

  Future<void> uploadImage(BuildContext context) async {
    Loader.show(context);
    var result =
        await _projectApi.uploadProfileImage(File(profileImage.value.path));
    result.when(
      (response) {
        profileImageUrl.value = response;
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }
}
