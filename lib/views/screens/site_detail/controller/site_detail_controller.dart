import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';
import 'package:cityvisit/modals/request/site_details/add_comment_request.dart';
import 'package:cityvisit/modals/request/site_details/add_sub_comment_request.dart';
import 'package:cityvisit/modals/request/site_details/individual_floor_image_request.dart';
import 'package:cityvisit/modals/request/site_details/update_individual_floor_image_request.dart';
import 'package:cityvisit/modals/site_detail/comment_modal.dart';
import 'package:cityvisit/modals/site_detail/site_detail_modal.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/photo/controller/photo_controller.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SiteDetailController extends GetxController {
  TextEditingController floorNameController = TextEditingController();
  TextEditingController areaNameController = TextEditingController();

  RxString selectAreaValue = ''.obs;
  RxString siteId = ''.obs;
  String projectId = '';
  RxBool isLoading = false.obs;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;

  Rx<SiteDetailModal> siteDetailModal = SiteDetailModal().obs;
  RxList<FloorPlan> floorPlan = <FloorPlan>[].obs;
  RxList<String> areaList = <String>[].obs;
  RxList<String> floorList = <String>[].obs;
  RxString addFloorSelectedAreaValue = ''.obs;
  RxString addFloorSelectedValue = ''.obs;
  final ProjectApi _projectApi = ProjectApi.instance;
  RxInt selectedAreaIndex = (0.obs);
  RxInt selectedFloorIndex = (0.obs);
  RxInt selectedImageIndex = (0.obs);
  RxString capturedImageUrl = (''.obs);
  RxInt selectedIconIndex = 2.obs;
  RxBool isFromEdit = false.obs;
  RxBool isCommentLoading = false.obs;
  RxList<CommentModal> commentList = <CommentModal>[].obs;
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxString replyingUser = ''.obs;
  RxInt replyingUserIndex = (-1).obs;
  late PainterController controller;
  ui.Image? backgroundImage;
  String? image;
  RxList<TagModal> positionList = <TagModal>[].obs;
  RxList<String> promptList = <String>[].obs;
  RxInt currentTapIndex = (-1).obs;
  FocusNode commentFocusNde = FocusNode();
  List<String> bottomIcon = <String>[
    AppAssets.pen,
    AppAssets.gallery,
    AppAssets.text,
    AppAssets.eraser,
  ];

  RxList<FloorListModal> floorListing = <FloorListModal>[].obs;
  RxList<String> imageListing = <String>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isMessageSend = false.obs;
  RxBool isAreaDropDownShow = false.obs;
  RxList<Areas> areasList = <Areas>[].obs;
  RxList<Areas> selectNewArea = <Areas>[].obs;
  RxBool isAreaFormShow = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      siteId.value = Get.arguments['siteId'];
      projectId = Get.arguments['projectId'];
    }
    super.onInit();
  }

  void initBackground(bool isFromEdit) async {
    controller = PainterController(
      settings: PainterSettings(
        freeStyle: const FreeStyleSettings(
          color: Colors.red,
          strokeWidth: 5,
        ),
        shape: ShapeSettings(
          paint: Paint()
            ..strokeWidth = 5
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        ),
        scale: const ScaleSettings(
          enabled: true,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );

    final imageUrl = isFromEdit
        ? await NetworkImage(capturedImageUrl.value).image
        : await FileImage(File(capturedImageUrl.value)).image;
    backgroundImage = imageUrl;
    controller.background = imageUrl.backgroundDrawable;
    print("Current url ==> $imageUrl");
  }

  void areaChanged(Areas? area) {
    if (area != null && !selectNewArea.contains(area)) {
      selectNewArea.add(area);
    }
    isAreaDropDownShow.value = false;
  }

  Future<void> siteDetails() async {
    isLoading.value = true;

    var result = await _projectApi.siteDetail(siteId.value);
    result.when(
      (response) {
        siteDetailModal.value = response;
        floorPlan.value = List.from(response.floorPlan ?? []);
        isLoading.value = false;
      },
      (error) {
        log("response ==> $error");
        isLoading.value = false;
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> addAreaForSpecificSite(BuildContext context) async {
    Loader.show(context);

    for (var element in floorPlan) {
      selectNewArea.removeWhere((element2) =>
      element.areaName?.toLowerCase() == element2.areaName?.toLowerCase());
    }

    List<String?> areaName =
    selectNewArea.map((element) => element.areaName).toList();
    List<String> filteredAreaNames =
    areaName.where((element) => element != null).map((e) => e!).toList();
    var result = await _projectApi.addAreaForSpecificSite(
        siteId.value, filteredAreaNames);
    result.when(
          (response) {
        if (response.status) {
          Get.context!.showSnackBar(response.message);
          for (var element in selectNewArea) {
            floorPlan.add(
              FloorPlan(
                areaName: element.areaName,
                floorData: [],
              ),
            );
          }
          Get.back();
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
          (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }


  Future<void> addArea(BuildContext context) async {
    Loader.show(context);

    var result = await _projectApi.addArea(areaNameController.text.trim());
    result.when(
          (response) {
        if (response.status) {
          Areas areas = Areas.fromJson(response.data);

          selectNewArea.add(areas);
          isAreaFormShow.value = false;
          areaNameController.clear();

          Get.context!.showSnackBar(response.message);
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
          (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> deleteArea(BuildContext context, {required int index}) async {
    Loader.show(context);

    var result = await _projectApi.deleteArea(
        siteId.value, floorPlan[index].areaName ?? '');
    result.when(
      (response) {
        if (response.status) {
          Get.context!.showSnackBar(response.message);
          floorPlan.removeAt(index);
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> addFloor(BuildContext context, String areaName) async {
    Loader.show(context);

    var result = await _projectApi.addFloorForSpecificSite(
        siteId.value, areaName, floorNameController.text.trim());
    result.when(
      (response) {
        if (response.status) {
          Get.context!.showSnackBar(response.message);
          floorPlan[selectedAreaIndex.value].floorData?.add(FloorData(
              floorName: floorNameController.text.trim(), imageData: []));
          floorPlan.refresh();
          Get.back();
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> deleteFloor(BuildContext context, {required int index}) async {
    Loader.show(context);

    var result = await _projectApi.deleteFloorForSpecificSite(
        siteId.value,
        floorPlan[selectedAreaIndex.value].areaName ?? '',
        floorPlan[selectedAreaIndex.value].floorData?[index].floorName ?? '');
    result.when(
      (response) {
        if (response.status) {
          Get.context!.showSnackBar(response.message);

          floorPlan[selectedAreaIndex.value].floorData?.removeAt(index);

          floorPlan.refresh();
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> deleteFloorImage(BuildContext context,
      {required int index, required int gridIndex}) async {
    Loader.show(context);

    var result = await _projectApi.deleteFloorImageForSpecificSite(
        siteId.value,
        floorPlan[selectedAreaIndex.value].areaName ?? '',
        floorPlan[selectedAreaIndex.value].floorData?[index].floorName ?? '',
        floorPlan[selectedAreaIndex.value]
                .floorData?[index]
                .imageData?[gridIndex]
                .img ??
            '');
    result.when(
      (response) {
        if (response.status) {
          Get.context!.showSnackBar(response.message);
          floorPlan[selectedAreaIndex.value]
              .floorData?[index]
              .imageData
              ?.removeAt(gridIndex);

          floorPlan.refresh();
        } else {
          Get.context!.showSnackBar(response.message);
        }
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> getAreaAndEmployeeData(BuildContext context) async {
    var result = await _projectApi.getAreaAndEmployeeData();
    result.when(
      (response) {
        areasList.value = List.from(response.areas ?? []);
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<String> uploadImage(BuildContext context, File file) async {
    var result = await _projectApi.uploadImage(file);
    String imageUrl = '';
    result.when(
      (response) {
        Loader.dismiss(context);
        log(response, name: "response");
        imageUrl = response;
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        imageUrl = '';
      },
    );
    log("return", name: "return");
    log(imageUrl, name: "imageUrl");

    return imageUrl;
  }

  void onChanged(String value) {
    promptList.clear();
    if (value.trim().isEmpty) {
      return;
    }
    for (var element in promptText) {
      if (element.toLowerCase().contains(value.toLowerCase())) {
        promptList.add(element);
      }
    }
  }

  Future<void> addComment(BuildContext context) async {
    isMessageSend.value = true;
    AddCommentRequest addCommentRequest = AddCommentRequest(
      comment: commentController.text.trim(),
      dateTime: DateTime.now().toUtc().toString(),
      userId: preferences.businessUserId,
      floorImg: capturedImageUrl.value,
      userType: "0",
      siteId: siteId.value,
      projectId: projectId,
      profilePic: UserData().profileImage.value,
    );

    var result = await _projectApi.addComment(addCommentRequest);
    result.when(
      (response) async {
        commentController.clear();

        commentList.add(
          CommentModal(
              name: response.name,
              profilePic: response.profilePic,
              dateTime: response.dateTime,
              comment: response.comment,
              id: response.id,
              isShowReply: false.obs),
        );
        commentList.refresh();
        isMessageSend.value = false;
        await Future.delayed(const Duration(milliseconds: 100));
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      },
      (error) {
        isMessageSend.value = false;
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
    log("return", name: "return");
  }

  Future<void> addSubComment(BuildContext context) async {
    isMessageSend.value = true;
    AddSubCommentRequest addCommentRequest = AddSubCommentRequest(
      comment: commentController.text.trim(),
      dateTime: DateTime.now().toUtc().toString(),
      userId: preferences.businessUserId,
      commentId: commentList[replyingUserIndex.value].id,
      userType: "0",
      siteId: siteId.value,
      projectId: projectId,
      profilePic: UserData().profileImage.value,
    );

    var result = await _projectApi.addSubComment(addCommentRequest);
    result.when(
      (response) {
        commentController.clear();
        log("${replyingUserIndex.value}", name: "replyingUserIndex.value");

        if (commentList[replyingUserIndex.value].subComments?.isEmpty ?? true) {
          commentList[replyingUserIndex.value].subComments = [];
        }
        commentList[replyingUserIndex.value].isShowReply.value = true;
        commentList[replyingUserIndex.value].subComments!.add(
              Subcomments(
                name: response.name,
                profilePic: response.profilePic,
                dateTime: response.dateTime,
                comment: response.comment,
                id: response.id,
              ),
            );
        replyingUser.value = '';
        replyingUserIndex.value = (-1);
        commentList.refresh();

        isMessageSend.value = false;
      },
      (error) {
        isMessageSend.value = false;
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
    log("return", name: "return");
  }

  Future<void> getComment(BuildContext context) async {
    isCommentLoading.value = true;
    replyingUser.value = '';
    var result = await _projectApi.getComment(capturedImageUrl.value);
    result.when(
      (response) {
        commentList.value = List.from(response);
        isCommentLoading.value = false;
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        isCommentLoading.value = false;
      },
    );
    log("return", name: "return");
  }

  Future<void> addIndividualFloorImage(BuildContext context, File file) async {
    String imageUrl = '';
    List<Coordinate> coordinate = [];
    if (!isFromEdit.value) {
      imageUrl = await uploadImage(context, file);
    } else {
      imageUrl = floorPlan[selectedAreaIndex.value]
              .floorData?[selectedFloorIndex.value]
              .imageData?[selectedImageIndex.value]
              .img ??
          '';
    }

    for (var element in positionList) {
      coordinate.add(
        Coordinate(
          msg: element.textEditingController?.text.trim() ?? '',
          y: element.offset?.dy.toString() ?? "0.0",
          x: element.offset?.dx.toString() ?? "0.0",
        ),
      );
    }
    IndividualFloorImageRequest individualFloorImageRequest =
        IndividualFloorImageRequest(
            img: imageUrl,
            siteId: siteId.value,
            floorName: addFloorSelectedValue.value,
            areaName: addFloorSelectedAreaValue.value,
            coordinate: coordinate);

    var result =
        await _projectApi.addIndividualFloorImage(individualFloorImageRequest);
    result.when(
      (response) {
        Loader.dismiss(context);

        if (response.status) {
          Get.context!.showSnackBar(response.message);
          Get.until((route) => route.settings.name == Routes.siteDetail);
          siteDetails();
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

  Future<void> editIndividualFloorImage(BuildContext context, File file) async {
    String imageUrl = '';
    List<Coordinate> coordinate = [];

    if (isFromEdit.value) {
      imageUrl = await uploadImage(context, file);
    } else {
      imageUrl = floorPlan[selectedAreaIndex.value]
              .floorData?[selectedFloorIndex.value]
              .imageData?[selectedImageIndex.value]
              .img ??
          '';
    }

    for (var element in positionList) {
      coordinate.add(
        Coordinate(
          msg: element.textEditingController?.text.trim() ?? '',
          y: element.offset?.dy.toString() ?? "0.0",
          x: element.offset?.dx.toString() ?? "0.0",
        ),
      );
    }
    UpdateIndividualFloorImageRequest individualFloorImageRequest =
        UpdateIndividualFloorImageRequest(
            img: capturedImageUrl.value,
            siteId: siteId.value,
            floorName: floorPlan[selectedAreaIndex.value]
                    .floorData?[selectedFloorIndex.value]
                    .floorName ??
                '',
            updateImg: imageUrl,
            areaName: floorPlan[selectedAreaIndex.value].areaName ?? '',
            coordinate: coordinate);

    var result =
        await _projectApi.editIndividualFloorImage(individualFloorImageRequest);
    result.when(
      (response) {
        Loader.dismiss(context);

        if (response.status) {
          Get.context!.showSnackBar(response.message);
          Get.until((route) => route.settings.name == Routes.siteDetail);
          siteDetails();
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

  Future<void> renderAndDisplayImage(BuildContext context) async {
    if (backgroundImage == null) return;
    Loader.show(context);
    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    ui.Image uiImage = await controller.renderImage(backgroundImageSize);

    Uint8List? imageUrl = await uiImage.pngBytes;
    Directory tempDir = await getTemporaryDirectory();
    File fileImage = await File("${tempDir.path}/image.png").create();
    fileImage.writeAsBytesSync(imageUrl!);

    image = fileImage.path;
    log("------");
    if (image?.isNotEmpty ?? false) {
      if (isFromEdit.value) {
        await editIndividualFloorImage(context, File(image!));
      } else {
        await addIndividualFloorImage(context, File(image!));
      }
    } else {
      Loader.dismiss(context);
    }
    // await continueOnTap(context);
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  Future<void> bottomIconOnTap(int index) async {
    selectedIconIndex.value = index;
    if (index == 0) {
      toggleFreeStyleDraw();
    }
    if (index == 1) {
      controller.freeStyleMode = FreeStyleMode.none;
      bool status = await CheckPermissionStatus.checkGalleryPermissionStatus();
      if (status) {
        File? file = await CheckPermissionStatus.pickImage(ImageSource.gallery);
        if (file != null) {
          log(file.path, name: "Image Path");
          controller.addImage(
            await FileImage(file).image,
            const Size(100, 100),
          );
        }
      }
    }
    if (index == 2) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    if (index == 3) {
      toggleFreeStyleErase();
    }
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  Future<void> addAreaOnTap(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      List<Areas> similarData = areasList
          .where((e) =>
      e.areaName?.toLowerCase() == areaNameController.text.trim())
          .toList();

      if (similarData.isEmpty) {
        await addArea(context);

      } else {
        Get.context!.showSnackBar(
            "Sorry, that value is already in the drop-down. Please enter a different value.");
      }
    }
  }

}

class FloorListModal {
  String name;
  List<String>? floorImageList;

  FloorListModal({required this.name, this.floorImageList});
}
