import 'package:flutter_svg/flutter_svg.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAreaDialog extends StatefulWidget {
  const AddAreaDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: const AddAreaDialog(),
        );
      },
    );
  }

  @override
  State<AddAreaDialog> createState() => _AddAreaDialogState();
}

class _AddAreaDialogState extends State<AddAreaDialog> with ValidationMixin {
  final SiteDetailController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.isAreaFormShow.value = false;
      _controller.selectNewArea.value = [];
      _controller.areaNameController.clear();
      _controller.selectAreaValue.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s16.w, vertical: Sizes.s16.h),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.addAreaBuilding,
                    style: TextStyle(
                      fontSize: Sizes.s16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close, color: AppColors.blackColor),
                  )
                ],
              ),
              SizedBoxH20(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryTextField(
                    labelText: AppString.selectAreaBuilding,
                    controller: TextEditingController(),
                    readOnly: true,
                    hintText: AppString.selectAreaBuilding,
                    focusedBorder: AppColors.borderColor,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: Sizes.s15.w),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.blackColor,
                      ),
                    ),
                    onTap: () {
                      _controller.isAreaDropDownShow.value =
                      !_controller.isAreaDropDownShow.value;
                    },
                  ),
                  SizedBoxH10(),
                  Obx(
                        () => ExpandedSection(
                      expand: _controller.isAreaDropDownShow.value,
                      child: Container(
                        height: Sizes.s200.h,
                        margin: const EdgeInsets.only(
                            top: 2, bottom: 10, left: 2, right: 2),
                        padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(Sizes.s12.r),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.blackColor.withOpacity(0.1),
                                offset: const Offset(0, 0),
                                blurRadius: 4,
                                spreadRadius: 0)
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _controller.areasList.map((value) {
                              return InkWell(
                                onTap: () {
                                  _controller.areaChanged(value);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.s10.h,
                                    vertical: Sizes.s8.h,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value.areaName ?? '',
                                    style: TextStyle(
                                      fontSize: Sizes.s14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                    () => _controller.selectNewArea.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s16.h),
                  child: Wrap(
                    runSpacing: Sizes.s10.h,
                    spacing: Sizes.s12.w,
                    children: _controller.selectNewArea
                        .map(
                          (e) => Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s8.w,
                            vertical: Sizes.s4.h),
                        decoration: BoxDecoration(
                          color: AppColors.lightPrimaryColor,
                          borderRadius:
                          BorderRadius.circular(Sizes.s6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              e.areaName ?? '',
                              style: TextStyle(
                                fontSize: Sizes.s12.sp,
                              ),
                            ),
                            SizedBoxW5(),
                            GestureDetector(
                              onTap: () {
                                _controller.selectNewArea.remove(e);
                              },
                              child: Icon(
                                Icons.close,
                                size: Sizes.s14.r,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
              Obx(
                    () => _controller.isAreaFormShow.value
                    ? _buildAreaForm()
                    : Padding(
                  padding: EdgeInsets.only(
                      bottom: Sizes.s16.h, top: Sizes.s10.h),
                  child: GestureDetector(
                    onTap: () {
                      _controller.isAreaFormShow.value =
                      !_controller.isAreaFormShow.value;
                    },
                    child: Text(
                      '+ ${AppString.addNewAreaBuilding}',
                      style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBoxH15(),
              Obx(
                    () => _controller.isAreaFormShow.value
                    ? const SizedBox.shrink()
                    : PrimaryButton(
                  label: AppString.save,
                  onPressed: () async {
                    if (_controller.selectNewArea.isEmpty) {
                      Get.back();
                      return;
                    }
                    await _controller.addAreaForSpecificSite(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAreaForm() {
    return Column(
      children: [
        _buildAreaNameWidget(),
        SizedBoxH15(),
        PrimaryButton(
          label: AppString.submit,
          onPressed: () {
            _controller.addAreaOnTap(context);
          },
        )
      ],
    );
  }

  Widget _buildAreaNameWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Sizes.s10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.areaBuildingName,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: Sizes.s16.sp,
                    fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () {
                  _controller.isAreaFormShow.value =
                  !_controller.isAreaFormShow.value;
                },
                child: SvgPicture.asset(
                  AppAssets.roundRemove,
                  height: Sizes.s20.w,
                  width: Sizes.s20.h,
                ),
              )
            ],
          ),
        ),
        PrimaryTextField(
          controller: _controller.areaNameController,
          validator: areaBuildingNameValidator,
          hintText: AppString.enterAreaBuildingName,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
