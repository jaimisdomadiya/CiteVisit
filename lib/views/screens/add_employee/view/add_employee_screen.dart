import 'dart:developer';
import 'dart:io';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/add_employee/controller/add_employee_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/image_picker_bottomsheet.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final AddEmployeeController _controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getAreaAndEmployeeData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.addEmployee,
      ),
      body: ScrollableColumn.withSafeArea(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s25.w, vertical: Sizes.s25.h),
        children: [
          Column(
            children: [
              _buildSiteWidget(),
              SizedBoxH15(),
              _buildAddMemberWidget(),
              SizedBoxH25(),
            ],
          ),
          Obx(
            () => PrimaryButton(
              label: _controller.isNewMemberAddFormShow.value
                  ? AppString.save
                  : AppString.submit,
              onPressed: () {
                _controller.isNewMemberAddFormShow.value
                    ? _saveOnTap()
                    : _submitOnTap();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveOnTap() {
    if (_controller.addMemberFormKey.currentState!.validate()) {
      _controller.addMember(context);
    }
  }

  void _submitOnTap() {
    if (_controller.selectedMemberList.isEmpty) {
      Get.context!.showSnackBar("Please select site");
    } else if (_controller.selectedSite.isEmpty) {
      Get.context!.showSnackBar("Please select employee");
    } else if (_controller.selectedMemberList.isNotEmpty &&
        _controller.selectedSite.isNotEmpty) {
      _controller.addMemberWithSite(context);
    }
  }

  Widget _buildSiteWidget() {
    return Obx(
      () => !_controller.isFromProjectDetails.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryTextField(
                  labelText: AppString.selectSite,
                  controller: TextEditingController(),
                  readOnly: true,
                  hintText: AppString.selectSite,
                  validator: _controller.siteValidator,
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: Sizes.s15.w),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.blackColor,
                    ),
                  ),
                  onTap: () {
                    _controller.isDropDownOpen.value =
                        !_controller.isDropDownOpen.value;
                  },
                ),
                SizedBoxH10(),
                ExpandedSection(
                  expand: _controller.isDropDownOpen.value,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(Sizes.s12.r),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.05),
                            offset: const Offset(0, 0),
                            blurRadius: 4,
                            spreadRadius: 0)
                      ],
                    ),
                    child: Column(
                      children: _controller.siteList.map((value) {
                        return InkWell(
                          onTap: () {
                            _controller.siteChanged(value);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.s10.h,
                              vertical: Sizes.s8.h,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value.siteName ?? '',
                              style: TextStyle(
                                fontSize: Sizes.s16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Obx(
                  () => _controller.selectedSite.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(bottom: Sizes.s16.h),
                          child: Wrap(
                            runSpacing: Sizes.s10.h,
                            spacing: Sizes.s12.w,
                            children: _controller.selectedSite
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
                                          e.siteName ?? '',
                                          style: TextStyle(
                                            fontSize: Sizes.s14.sp,
                                          ),
                                        ),
                                        SizedBoxW5(),
                                        GestureDetector(
                                          onTap: () {
                                            _controller.selectedSite.remove(e);
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
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAddMemberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextField(
              labelText: AppString.members,
              controller: TextEditingController(),
              readOnly: true,
              hintText: AppString.selectMembers,
              focusedBorder: AppColors.borderColor,
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: Sizes.s15.w),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.blackColor,
                ),
              ),
              onTap: () {
                _controller.isMemberDropDownOpen.value =
                    !_controller.isMemberDropDownOpen.value;
              },
            ),
            SizedBoxH10(),
            Obx(
              () => ExpandedSection(
                expand: _controller.isMemberDropDownOpen.value,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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
                  child: SizedBox(
                    height: Sizes.s250.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: _controller.membersList.map((value) {
                          return InkWell(
                            onTap: () {
                              _controller.memberChanged(value);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.s10.h,
                                vertical: Sizes.s8.h,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ImageView(
                                    imageUrl: value.profilePic,
                                    height: Sizes.s18.w,
                                    width: Sizes.s18.w,
                                    radius: Sizes.s18.w / 2,
                                  ),
                                  SizedBoxW10(),
                                  Text(
                                    value.name ?? '',
                                    style: TextStyle(
                                      fontSize: Sizes.s14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => _controller.selectedMemberList.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s16.h),
                  child: Wrap(
                    runSpacing: Sizes.s10.h,
                    spacing: Sizes.s12.w,
                    children: _controller.selectedMemberList
                        .map(
                          (e) => Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes.s8.w, vertical: Sizes.s4.h),
                            decoration: BoxDecoration(
                              color: AppColors.lightPrimaryColor,
                              borderRadius: BorderRadius.circular(Sizes.s6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageView(
                                  imageUrl: e.profilePic ?? '',
                                  height: Sizes.s18.w,
                                  width: Sizes.s18.w,
                                  radius: Sizes.s18.w / 2,
                                ),
                                SizedBoxW5(),
                                Text(
                                  e.name ?? '',
                                  style: TextStyle(
                                    fontSize: Sizes.s12.sp,
                                  ),
                                ),
                                SizedBoxW5(),
                                GestureDetector(
                                  onTap: () {
                                    _controller.selectedMemberList.remove(e);
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
          () => _controller.isNewMemberAddFormShow.value
              ? _buildAddMemberForm()
              : Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s16.h),
                  child: GestureDetector(
                    onTap: () {
                      _controller.isNewMemberAddFormShow.value =
                          !_controller.isNewMemberAddFormShow.value;
                    },
                    child: Text(
                      '+ ${AppString.addNewMembers}',
                      style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
        )
      ],
    );
  }

  Widget _buildFirstNameWidget() {
    return PrimaryTextField(
      labelText: AppString.firstName,
      controller: _controller.firstName,
      validator: _controller.firstNameValidator,
      hintText: AppString.enterName,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
      ],
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: Sizes.s12.w),
        child: SvgPicture.asset(
          AppAssets.profileOutline,
          height: Sizes.s20.h,
          width: Sizes.s20.h,
        ),
      ),
    );
  }

  Widget _buildLastNameWidget() {
    return PrimaryTextField(
      labelText: AppString.lastName,
      controller: _controller.lastName,
      hintText: AppString.lastName,
      suffixIconName: AppAssets.profileOutline,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
      ],
      validator: _controller.lastNameValidator,
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: Sizes.s12.w),
        child: SvgPicture.asset(
          AppAssets.profileOutline,
          height: Sizes.s20.h,
          width: Sizes.s20.h,
        ),
      ),
    );
  }

  Widget _buildEmailWidget() {
    return PrimaryTextField(
      labelText: AppString.email,
      controller: _controller.email,
      validator: _controller.emailValidator,
      hintText: AppString.enterEmail,
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: Sizes.s12.w),
        child: SvgPicture.asset(
          AppAssets.email,
          height: Sizes.s20.h,
          width: Sizes.s20.h,
        ),
      ),
    );
  }

  Widget _buildPhoneWidget() {
    return PrimaryTextField(
      labelText: AppString.phoneNo,
      controller: _controller.phoneNo,
      validator: _controller.phoneValidator,
      hintText: AppString.enterPhoneNo,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: Sizes.s12.w),
        child: SvgPicture.asset(
          AppAssets.call,
          height: Sizes.s20.h,
          width: Sizes.s20.h,
        ),
      ),
    );
  }

  Widget _buildMemberRoleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.employeeRole,
          style: TextStyle(fontSize: Sizes.s16.sp),
        ),
        SizedBoxH10(),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s16.w, vertical: Sizes.s12.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.s10.r),
                border: Border.all(color: AppColors.borderColor)),
            child: Column(
              children: _controller.employeesRoleList.map((value) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: Sizes.s12.h),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _controller.memberRoleValue.value = value;
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  _controller.memberRoleValue.value == value
                                      ? AppColors.primaryColor
                                      : AppColors.blackColor,
                              radius: (Sizes.s16 / 2).r,
                              child: CircleAvatar(
                                backgroundColor: AppColors.whiteColor,
                                radius: (Sizes.s14 / 2).r,
                                child: CircleAvatar(
                                  backgroundColor:
                                      _controller.memberRoleValue.value == value
                                          ? AppColors.primaryColor
                                          : AppColors.whiteColor,
                                  radius: (Sizes.s8 / 2).r,
                                ),
                              ),
                            ),
                            SizedBoxW10(),
                            Text(
                              value,
                              style: TextStyle(fontSize: Sizes.s14.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    _controller.memberRoleValue.value == "Other" &&
                            value == "Other"
                        ? PrimaryTextField(
                            controller: _controller.employeeRole,
                            hintText: AppString.other,
                            focusedBorder: AppColors.borderColor,
                            validator: _controller.memberRoleValidator,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAccessLevelWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.accessLevel,
          style: TextStyle(fontSize: Sizes.s16.sp),
        ),
        SizedBoxH10(),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s16.w, vertical: Sizes.s12.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.s10.r),
                border: Border.all(color: AppColors.borderColor)),
            child: Column(
              children: _controller.accessLevel.map((value) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s10.h),
                  child: GestureDetector(
                    onTap: () {
                      _controller.accessOnChanged(value);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              _controller.accessValue.value == value
                                  ? AppColors.primaryColor
                                  : AppColors.blackColor,
                          radius: (Sizes.s16 / 2).r,
                          child: CircleAvatar(
                            backgroundColor: AppColors.whiteColor,
                            radius: (Sizes.s14 / 2).r,
                            child: CircleAvatar(
                              backgroundColor:
                                  _controller.accessValue.value == value
                                      ? AppColors.primaryColor
                                      : AppColors.whiteColor,
                              radius: (Sizes.s8 / 2).r,
                            ),
                          ),
                        ),
                        SizedBoxW10(),
                        Text(
                          value,
                          style: TextStyle(fontSize: Sizes.s14.sp),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProfileImageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.profile,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBoxH10(),
        GestureDetector(
          onTap: () {
            bottomSheet();
          },
          child: Obx(
            () => _controller.profileImage.value.path.isEmpty
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [5, 5],
                    radius: const Radius.circular(8),
                    color: AppColors.borderColor,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: Sizes.s30.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.upload,
                            height: Sizes.s60.w,
                            width: Sizes.s60.h,
                          ),
                          SizedBoxH15(),
                          Text(
                            '+ ${AppString.addImage}',
                            style: TextStyle(
                                fontSize: Sizes.s14.sp,
                                color: AppColors.primaryColor),
                          )
                        ],
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s10.r),
                    child: Image.file(
                      _controller.profileImage.value,
                      height: Sizes.s170.h,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
        ),
      ],
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
              _controller.profileImage.value = file;
              log(file.path, name: "Image Path");
            }
            Get.back();
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
              _controller.profileImage.value = file;
              log(file.path, name: "Image Path");
            }
          }
          Get.back();
        },
      ),
    );
  }

  Widget _buildAddMemberForm() {
    return Form(
      key: _controller.addMemberFormKey,
      child: Column(
        children: [
          SizedBoxH15(),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                _controller.isNewMemberAddFormShow.value =
                    !_controller.isNewMemberAddFormShow.value;
              },
              child: SvgPicture.asset(AppAssets.roundRemove),
            ),
          ),
          _buildFirstNameWidget(),
          SizedBoxH25(),
          _buildLastNameWidget(),
          SizedBoxH25(),
          _buildEmailWidget(),
          SizedBoxH25(),
          _buildPhoneWidget(),
          SizedBoxH25(),
          _buildMemberRoleWidget(),
          SizedBoxH25(),
          _buildAccessLevelWidget(),
          SizedBoxH25(),
        ],
      ),
    );
  }
}
