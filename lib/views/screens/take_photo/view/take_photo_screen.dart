import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/const.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';
import 'package:cityvisit/modals/request/site_details/add_site_request.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/create_project/controller/create_project_controller.dart';
import 'package:cityvisit/views/screens/take_photo/widget/camera_border_painter.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({Key? key}) : super(key: key);

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController _cameraController;
  final CreateProjectController _controller = Get.find();
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera(CameraLensDirection.back);
  }

  Future<void> initCamera(CameraLensDirection cameraLensDirection) async {
    _cameraController = CameraController(
      Const.cameras.firstWhere(
          (element) => element.lensDirection == cameraLensDirection),
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraController.setFlashMode(FlashMode.off);

    try {
      initializeControllerFuture = _cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraController;

    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera(CameraLensDirection.back);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            fit: StackFit.expand,
            children: [
              /*ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / controller.value.aspectRatio,
                        child: CameraPreview(
                          controller,
                          child: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
              CameraPreview(
                _cameraController,
                child: const SizedBox.shrink(),
              ),
              _buildScreenBorder(),
              _buildBottomOptionWidget(),
              _buildAppBarWidget()
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
      },
    );
  }

  Widget _buildScreenBorder() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: Sizes.s24.w,
          right: Sizes.s24.w,
          top: Get.height * 0.15,
          bottom: Get.height * 0.20,
        ),
        child: CustomPaint(
          foregroundPainter: BorderPainter(
            borderColor: AppColors.whiteColor,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarWidget() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
                top: Sizes.s16.h,
                bottom: Sizes.s32.h,
                left: Sizes.s24.w,
                right: Sizes.s24.w),
            child: Row(
              children: [
                const PrimaryBackButton(color: AppColors.whiteColor),
                SizedBoxW12(),
                Obx(
                  () => Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.s8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.s8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                      ),
                      isDense: true,
                      dropdownColor: AppColors.whiteColor,
                      value: _controller.addFloorSelectedAreaValue.value,
                      onChanged: (Areas? areas) {
                        if (areas != null) {
                          _controller.floorSelectAreaValue.value = areas;
                          if (_controller.floorPlanList.isNotEmpty) {
                            FloorPlan? floorPlanValue =
                                _controller.floorPlanList.firstWhere(
                                    (element) =>
                                        element.areaName == areas.areaName,
                                    orElse: () {
                              return FloorPlan();
                            });
                            if (floorPlanValue != null) {
                              _controller.floorPlan.value = floorPlanValue;
                            } else {
                              _controller.floorPlan.value = FloorPlan();
                            }
                            _controller.selectedFloorName.value =
                                _controller.floorPlan.value.floorData![0];
                          }
                        }
                      },
                      icon: const Icon(Icons.expand_more_rounded),
                      items: _controller.takePhotoAreasList
                          .map<DropdownMenuItem<Areas>>((Areas value) {
                        return DropdownMenuItem<Areas>(
                          value: value,
                          child: Text(
                            value.areaName ?? '',
                            style: TextStyle(fontSize: Sizes.s14.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBoxW12(),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.s8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.s8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                      ),
                      isDense: true,
                      dropdownColor: AppColors.whiteColor,
                      value: _controller.selectedFloorName.value,
                      onChanged: (FloorData? floorData) {
                        if (floorData != null) {
                          _controller.selectedFloorName.value = floorData;
                        }
                      },
                      icon: const Icon(Icons.expand_more_rounded),
                      items: _controller.floorPlan.value.floorData
                          ?.map<DropdownMenuItem<FloorData>>((FloorData value) {
                        return DropdownMenuItem<FloorData>(
                          value: value,
                          child: Text(
                            value.floorName ?? '',
                            style: TextStyle(fontSize: Sizes.s14.sp),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBoxW12(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomOptionWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: AppColors.blackBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.s16.h,
              bottom: Sizes.s32.h,
              left: Sizes.s24.w,
              right: Sizes.s24.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool status = await CheckPermissionStatus
                          .checkGalleryPermissionStatus();
                      if (status) {
                        File? file = await CheckPermissionStatus.pickImage(
                            ImageSource.gallery);
                        if (file != null) {
                          log(file.path, name: "Image Path");
                          Get.toNamed(Routes.photo, arguments: {
                            "image": file.path.toString(),
                            "floor_name":
                                _controller.selectedFloorName.value.floorName ??
                                    ''
                          });
                        }
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.gallery,
                        height: Sizes.s24.w,
                        width: Sizes.s24.w,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!_cameraController.value.isInitialized ||
                          _cameraController.value.isTakingPicture) {
                        return;
                      }

                      try {
                        XFile image = await _cameraController.takePicture();
                        log("Camera Path ==> ${image.path}");
                        if (!mounted) return;
                        Get.toNamed(Routes.photo, arguments: {
                          "image": image.path.toString(),
                          "floor_name":
                              _controller.selectedFloorName.value.floorName ??
                                  ''
                        });
                      } on CameraException catch (e) {
                        Get.context!
                            .showSnackBar('Error: ${e.code}\n${e.description}');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.s16.w, vertical: Sizes.s16.h),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.camera,
                        height: Sizes.s32.w,
                        width: Sizes.s32.w,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!_cameraController.value.isInitialized ||
                          _cameraController.value.isTakingPicture) {
                        return;
                      }

                      if (_controller.cameraLensDirection ==
                          CameraLensDirection.back) {
                        _controller.cameraLensDirection =
                            CameraLensDirection.front;
                      } else {
                        _controller.cameraLensDirection =
                            CameraLensDirection.back;
                      }

                      for (var element in Const.cameras) {
                        if (_controller.cameraLensDirection ==
                            element.lensDirection) {
                          _cameraController.setDescription(element);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes.s8.w, vertical: Sizes.s8.h),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.cameraSideChange,
                        height: Sizes.s24.w,
                        width: Sizes.s24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
