import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';
import 'package:cityvisit/modals/request/site_details/add_member_request.dart';
import 'package:cityvisit/modals/request/site_details/add_site_request.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/image_picker_bottomsheet.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateProjectController extends GetxController {
  final ProjectApi _projectApi = ProjectApi.instance;

  @override
  void onInit() {
    if (Get.arguments != null) {
      projectHeading.value = Get.arguments['projectHeading'];
      projectId = Get.arguments['projectId'];
    }
    super.onInit();
  }

  String projectId = '';

  /// Site Details
  RxString projectHeading = RxString("");
  TextEditingController siteName = TextEditingController();
  TextEditingController siteAddress = TextEditingController();
  RxString siteCoverImageUrl = ''.obs;
  final GlobalKey<FormState> siteDetailFormKey = GlobalKey<FormState>();

  /// Add Member
  RxBool isMemberDropDownOpen = false.obs;
  RxBool isEmployeeRoleDropDownOpen = false.obs;
  RxBool isNewMemberAddFormShow = false.obs;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  RxString employeeRoleValue = ''.obs;
  RxString accessValue = RxString("Only Comment");
  RxList<String> employeesRoleList = <String>[].obs;
  RxList<Employees> employeesList = <Employees>[].obs;
  RxList<Employees> selectedMemberList = <Employees>[].obs;
  final GlobalKey<FormState> addMemberFormKey = GlobalKey<FormState>();
  final List<String> accessLevel = [
    'Add/Edit the site information',
    'Only Comment',
    'View Only',
  ];
  RxString memberRoleValue = RxString("Other");
  TextEditingController otherEmployeeRole = TextEditingController();

  /// Add Area
  RxBool isAreaFormShow = false.obs;
  RxBool isAreaDropDownShow = false.obs;
  RxList<Areas> areasList = <Areas>[].obs;
  RxList<Areas> selectNewArea = <Areas>[].obs;
  TextEditingController areaName = TextEditingController();
  final GlobalKey<FormState> areaFormKey = GlobalKey<FormState>();

  /// Add Floor Plan
  Rx<Areas> floorSelectAreaValue = Rx<Areas>(Areas());
  RxBool isFloorSelectAreaDropDownOpen = false.obs;
  final GlobalKey<FormState> addFloorFormKey = GlobalKey<FormState>();
  TextEditingController floorNameController = TextEditingController();
  RxList<FloorPlan> floorPlanList = <FloorPlan>[].obs;
  Rx<FloorPlan> floorPlan = Rx(FloorPlan());
  Rx<String> projectImage = Rx('');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isFloorPlanValidate = true.obs;

  ///For Take Photo
  Rx<FloorData> selectedFloorName = FloorData(floorName: '', imageData: []).obs;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  RxList<Areas> takePhotoAreasList = <Areas>[].obs;
  Rx<Areas> addFloorSelectedAreaValue = Rx<Areas>(Areas());

  Future<void> uploadImageOnTap() async {
    String imageUrl = await bottomSheet();
    if (imageUrl.isNotEmpty) {
      projectImage.value = imageUrl;
    }
  }

  Future<void> addProjectSubmitOnTap(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      addProject(context);
    }
  }

  void memberChanged(Employees? member) {
    if (member != null && !selectedMemberList.contains(member)) {
      selectedMemberList.add(member);
    }
    isMemberDropDownOpen.value = false;
  }

  void employeeRoleChanged(String? role) {
    if (role != null) {
      log(role, name: "Site");
      employeeRoleValue.value = role;
      isEmployeeRoleDropDownOpen.value = false;
    }
  }

  void accessOnChanged(String? value) {
    if (value != null) {
      accessValue.value = value;
    }
  }

  void areaChanged(Areas? area) {
    if (area != null) {
      log(area.areaName ?? '', name: "Site");
      if (!selectNewArea.contains(area)) {
        selectNewArea.add(area);
      }
      isAreaDropDownShow.value = false;
    }
  }

  void floorSelectAreaChanged(Areas? value) {
    if (value != null) {
      isFloorSelectAreaDropDownOpen.value = false;
      floorSelectAreaValue.value = value;
      if (floorPlanList.isNotEmpty) {
        FloorPlan? floorPlanValue = floorPlanList.firstWhere(
            (element) => element.areaName == value.areaName, orElse: () {
          return FloorPlan();
        });
        if (floorPlanValue != null) {
          floorPlan.value = floorPlanValue;
        } else {
          floorPlan.value = FloorPlan();
        }
      }
    }
  }

  Future<void> addProject(BuildContext context) async {
    Loader.show(context);
    var result = await _projectApi.addProject(
        name: siteName.text.trim(), imageUrl: projectImage.value);
    result.when(
      (response) {
        Loader.dismiss(context);
        Get.context!.showSnackBar(response.message);
        Get.back(result: true);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<String> bottomSheet() async {
    var imageUrl = await Get.bottomSheet(
      ImageBottomSheet(
        galleryOnTap: () async {
          bool status =
              await CheckPermissionStatus.checkGalleryPermissionStatus();
          log(status.toString(), name: "Status");
          if (status) {
            File? file =
                await CheckPermissionStatus.pickImage(ImageSource.gallery);
            if (file != null) {
              String imageUrl = await uploadImage(Get.context!, file);
              log(imageUrl, name: "imageUrl");
              Get.back(result: imageUrl);
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
              String imageUrl = await uploadImage(Get.context!, file);
              Get.back(result: imageUrl);
              log(file.path, name: "Image Path");
            }
          }
        },
      ),
    );
    log(imageUrl ?? "Null", name: "imageUrl 2 ");

    if (imageUrl != null) {
      return imageUrl;
    } else {
      return '';
    }
  }

  Future<String> uploadImage(BuildContext context, File file) async {
    Loader.show(context);
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

  Future<void> addMember(BuildContext context) async {
    Loader.show(context);

    int accessLevelIndex =
        accessLevel.indexWhere((item) => item == accessValue.value);

    AddMemberRequest addMemberRequest = AddMemberRequest(
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      phoneNumber: phoneNo.text.trim(),
      accessLevel: accessLevelIndex.toString(),
      type: "0",
      employeeRole: memberRoleValue.value == "Other"
          ? otherEmployeeRole.text.trim()
          : memberRoleValue.value,
    );

    var result = await _projectApi.addMember(addMemberRequest);
    result.when(
      (response) {
        firstName.clear();
        lastName.clear();
        email.clear();
        phoneNo.clear();
        accessValue.value = 'Only Comment';
        memberRoleValue.value = "Other";
        isNewMemberAddFormShow.value = false;
        otherEmployeeRole.clear();
        employeesList.add(response.data);
        selectedMemberList.add(response.data);
        Get.context!.showSnackBar(response.message);
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> getAreaAndMemberData(BuildContext context) async {
    Loader.show(context);

    var result = await _projectApi.getAreaAndEmployeeData();
    result.when(
      (response) {
        employeesList.value = List.from(response.employees ?? []);
        areasList.value = List.from(response.areas ?? []);
        employeesRoleList.value = List.from(response.employeeRole ?? []);
        employeesRoleList.add("Other");
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

    var result = await _projectApi.addArea(areaName.text.trim());
    result.when(
      (response) {
        if (response.status) {
          Areas areas = Areas.fromJson(response.data);
          areasList.add(areas);
          selectNewArea.add(areas);
          isAreaFormShow.value = false;
          areaName.clear();
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

  Future<void> addFloorOnTap() async {
    if (floorNameController.text.trim().isNotEmpty) {
      isFloorPlanValidate.value = true;
      if (floorSelectAreaValue.value.areaName?.isEmpty ?? true) {
        Get.context!.showSnackBar("Please select area");
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        ContainAreaModal isContainArea = containArea();
        if ((isContainArea.isContain ?? false) && isContainArea.index != null) {
          List<FloorData> floorData = [];
          floorData =
              List.from(floorPlanList[isContainArea.index!].floorData ?? []);
          bool isContainFloorName = false;

          for (var element in floorData) {
            if (element.floorName?.toLowerCase() ==
                floorNameController.text.trim()) {
              isContainFloorName = true;
              break;
            }
          }
          if (!isContainFloorName) {
            floorData.add(
              FloorData(
                floorName: floorNameController.text.trim(),
                imageData: [],
              ),
            );
            floorPlanList[isContainArea.index!].floorData =
                List.from(floorData);
            floorPlan.value = floorPlanList[isContainArea.index!].copyWith(
                floorData: List.from(floorData),
                areaName: floorPlanList[isContainArea.index!].areaName);
            floorPlan.refresh();
            floorNameController.text = '';
          } else {
            Get.context!.showSnackBar("Please add different floor name");
          }
        } else {
          floorPlanList.add(FloorPlan(
            areaName: floorSelectAreaValue.value.areaName,
            floorData: [
              FloorData(
                  floorName: floorNameController.text.trim(), imageData: [])
            ],
          ));
          floorPlan.value = FloorPlan(
            areaName: floorSelectAreaValue.value.areaName,
            floorData: [
              FloorData(
                  floorName: floorNameController.text.trim(), imageData: [])
            ],
          );
          floorPlan.refresh();
          floorNameController.text = '';
        }
      }
    } else {
      isFloorPlanValidate.value = false;
    }
  }

  void removeFloorOnTap(int index) {
    try {
      int floorPlanIndex = getAreaIndex();

      floorPlanList[floorPlanIndex].floorData?.removeAt(index);
      floorPlan.value.floorData?.removeAt(index);
      floorPlan.refresh();
    } catch (e, stackStrace) {
      log(e.toString(), name: "Error");
      log(stackStrace.toString(), name: "stackStrace");
    }
  }

  int getAreaIndex() {
    return floorPlanList
        .indexWhere((element) => floorPlan.value.areaName == element.areaName);
  }

  int getFloorIndex() {
    return floorPlan.value.floorData?.indexWhere((element) =>
            selectedFloorName.value.floorName == element.floorName) ??
        0;
  }

  ContainAreaModal containArea() {
    for (int i = 0; i < floorPlanList.length; i++) {
      if (floorPlanList[i].areaName == floorSelectAreaValue.value.areaName) {
        return ContainAreaModal(index: i, isContain: true);
      }
    }
    return ContainAreaModal(isContain: false);
  }

  Future<void> saveOnClick(BuildContext context) async {
    /*if (siteDetailFormKey.currentState!.validate()) {
      if (siteCoverImageUrl.value.isEmpty) {
        context.showSnackBar("Please select site image");
      } else if (selectedMemberList.isEmpty) {
        context.showSnackBar("Please select members");
      } else if (selectNewArea.isEmpty) {
        context.showSnackBar("Please select area");
      } else {
        List<String> membersIs = selectedMemberList
            .map((element) => element.id)
            .cast<String>()
            .toList();
        List<String> areasName = selectNewArea
            .map((element) => element.areaName)
            .cast<String>()
            .toList();
        AddSiteRequest addSiteRequest = AddSiteRequest(
            siteName: siteName.text.trim(),
            siteAddress: siteAddress.text.trim(),
            siteImage: siteCoverImageUrl.value,
            members: membersIs,
            areas: areasName,
            projectId: projectId,
            type: "0",
            businessId: preferences.businessUserId,
            floorPlan: floorPlanList);

        Loader.show(context);

        var result = await _projectApi.addSite(addSiteRequest);
        result.when(
          (response) {
            log("response ==> ${response.data}");
            Get.context!.showSnackBar(response.message);
            Loader.dismiss(context);

            Get.offAllNamed(Routes.bottomMenu);
          },
          (error) {
            Loader.dismiss(context);
            log("response ==> $error");
            Get.context!.showSnackBar(error);
          },
        );
      }
    }*/

    if (siteDetailFormKey.currentState!.validate()) {
      List<String> membersIs = selectedMemberList
          .map((element) => element.id)
          .cast<String>()
          .toList();
      List<String> areasName = selectNewArea
          .map((element) => element.areaName)
          .cast<String>()
          .toList();
      AddSiteRequest addSiteRequest = AddSiteRequest(
          siteName: siteName.text.trim(),
          siteAddress: siteAddress.text.trim(),
          siteImage: siteCoverImageUrl.value,
          members: membersIs,
          areas: areasName,
          projectId: projectId,
          type: "0",
          businessId: preferences.businessUserId,
          floorPlan: floorPlanList);

      Loader.show(context);

      var result = await _projectApi.addSite(addSiteRequest);
      result.when(
        (response) {
          log("response ==> ${response.data}");
          Get.context!.showSnackBar(response.message);
          Loader.dismiss(context);

          Get.back(result: true);
        },
        (error) {
          Loader.dismiss(context);
          log("response ==> $error");
          Get.context!.showSnackBar(error);
        },
      );
    }
  }

  Future<void> addImageOnTap(int index) async {
    if (floorPlan.value.floorData?[index] != null) {
      selectedFloorName.value = floorPlan.value.floorData![index];
    }
    RxList<Areas> areaList = <Areas>[].obs;

    areaList.value = List.from([]);
    for (var element in floorPlanList) {
      if (element.floorData?.isNotEmpty ?? false) {
        areaList.add(
          Areas(areaName: element.areaName),
        );
      }
    }
    takePhotoAreasList.value = List.from([]);
    for (var element in areasList) {
      for (var element2 in areaList) {
        if (element.areaName == element2.areaName) {
          takePhotoAreasList
              .add(Areas(areaName: element.areaName, id: element.id));
          if (takePhotoAreasList.last.id == floorSelectAreaValue.value.id) {
            addFloorSelectedAreaValue.value = takePhotoAreasList.last;
          }
        }
      }
    }

    await Get.toNamed(Routes.takePhoto);

    if (UserData().imageData.img != null) {
      int areaIndex = getAreaIndex();

      int floorIndex = getFloorIndex();

      List<ImageData> imageData =
          floorPlan.value.floorData?[floorIndex].imageData ?? [];

      imageData.add(UserData().imageData);

      floorPlan.value.floorData?[floorIndex].imageData = List.from(imageData);

      List<ImageData> dataImage = imageData;
      floorPlanList[areaIndex].floorData?[floorIndex].imageData =
          List.from(dataImage);

      floorPlan.refresh();
      UserData().imageData = ImageData();
    }
  }
}

class ContainAreaModal {
  bool? isContain;
  int? index;

  ContainAreaModal({this.index, this.isContain});
}
