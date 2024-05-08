import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/create_project/controller/create_project_controller.dart';
import 'package:cityvisit/views/screens/create_project/widget/delete_floor_dialog.dart';
import 'package:cityvisit/views/screens/site_detail/widget/delete_image_dialog.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/expansion_tile.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreateNewSite extends StatefulWidget {
  const CreateNewSite({Key? key}) : super(key: key);

  @override
  State<CreateNewSite> createState() => _CreateNewSiteState();
}

class _CreateNewSiteState extends State<CreateNewSite> with ValidationMixin {
  final CreateProjectController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getAreaAndMemberData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: _controller.projectHeading.value,
      ),
      body: ScrollableColumn.withSafeArea(
        children: [
          SizedBoxH10(),
          _buildGreyContainer(),
          _buildSiteDetailWidget(),
          _buildGreyContainer(),
          _buildAddMemberWidget(),
          _buildGreyContainer(),
          _buildAddAreaWidget(),
          _buildGreyContainer(),
          _buildAddFloorPlanWidget(),
          _buildGreyContainer(),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSiteDetailWidget() {
    return Form(
      key: _controller.siteDetailFormKey,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.s24.w, vertical: Sizes.s12.h),
          child: CustomExpansionTile(
            title: Text(
              AppString.siteDetails,
              style: TextStyle(
                  fontSize: Sizes.s16.sp,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.s18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextField(
                      labelText: AppString.siteName,
                      controller: _controller.siteName,
                      validator: siteNameValidator,
                      hintText: AppString.enterSiteName,
                    ),
                    SizedBoxH15(),
                    PrimaryTextField(
                      labelText: AppString.siteAddress,
                      controller: _controller.siteAddress,
                      // validator: siteAddressValidator,
                      hintText: AppString.enterSiteAddress,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBoxH15(),
                    Text(
                      AppString.uploadSiteCover,
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBoxH10(),
                    GestureDetector(
                      onTap: () async {
                        String imageUrl = await _controller.bottomSheet();
                        if (imageUrl.isNotEmpty) {
                          _controller.siteCoverImageUrl.value = imageUrl;
                        }
                      },
                      child: Obx(
                        () => _controller.siteCoverImageUrl.value.isEmpty
                            ? DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern: const [5, 5],
                                radius: const Radius.circular(8),
                                color: AppColors.borderColor,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.s30.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.s10.r),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.borderColor)),
                                      child: ImageView(
                                        imageUrl:
                                            _controller.siteCoverImageUrl.value,
                                        height: Sizes.s170.h,
                                        width: double.infinity,
                                        radius: Sizes.s10.r,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: CircleAvatar(
                                      radius: Sizes.s12.r,
                                      backgroundColor: AppColors.whiteColor,
                                      child: SvgPicture.asset(AppAssets.edit,
                                          height: Sizes.s16.h,
                                          width: Sizes.s16.w),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onExpansionChanged: (newState) {},
          ),
        ),
      ),
    );
  }

  Widget _buildAddMemberWidget() {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s12.h),
        child: CustomExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: EdgeInsets.symmetric(vertical: Sizes.s18.h),
          title: Text(
            AppString.addMembers,
            style: TextStyle(
                fontSize: Sizes.s16.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
              child: Column(
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
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
                              children: _controller.employeesList.map((value) {
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
                                        _controller.selectedMemberList
                                            .remove(e);
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
        ),
      ),
    );
  }

  Widget _buildAddMemberForm() {
    return Form(
      key: _controller.addMemberFormKey,
      child: Column(
        children: [
          _buildFirstNameWidget(),
          SizedBoxH12(),
          _buildLastNameWidget(),
          SizedBoxH12(),
          _buildMemberRoleWidget(),
          SizedBoxH12(),
          _buildEmailWidget(),
          SizedBoxH12(),
          _buildPhoneWidget(),
          SizedBoxH12(),
          _buildAccessLevelWidget(),
          SizedBoxH12(),
          PrimaryButton(
            label: AppString.submit,
            onPressed: () {
              if (_controller.addMemberFormKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());
                _controller.addMember(context);
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildGreyContainer() {
    return Container(
      height: Sizes.s8.h,
      color: AppColors.greyBackgroundColor,
      width: double.infinity,
    );
  }

  Widget _buildFirstNameWidget() {
    return PrimaryTextField(
      labelText: AppString.firstName,
      controller: _controller.firstName,
      hintText: AppString.firstName,
      suffixIconName: AppAssets.profileOutline,
      validator: firstNameValidator,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
      ],
    );
  }

  Widget _buildLastNameWidget() {
    return PrimaryTextField(
      labelText: AppString.lastName,
      controller: _controller.lastName,
      hintText: AppString.lastName,
      suffixIconName: AppAssets.profileOutline,
      validator: lastNameValidator,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
      ],
    );
  }

  Widget _buildMemberRoleWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
      child: Column(
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
                                        _controller.memberRoleValue.value ==
                                                value
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
                              controller: _controller.otherEmployeeRole,
                              hintText: AppString.other,
                              focusedBorder: AppColors.borderColor,
                              validator: memberRoleValidator,
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailWidget() {
    return PrimaryTextField(
      labelText: AppString.email,
      controller: _controller.email,
      hintText: AppString.enterEmail,
      suffixIconName: AppAssets.email,
      validator: emailValidator,
    );
  }

  Widget _buildPhoneWidget() {
    return PrimaryTextField(
      labelText: AppString.phoneNo,
      controller: _controller.phoneNo,
      hintText: AppString.phoneNo,
      suffixIconName: AppAssets.call,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validator: phoneValidator,
    );
  }

  Widget _buildAreaNameWidget() {
    return PrimaryTextField(
      labelText: AppString.areaBuildingName,
      controller: _controller.areaName,
      hintText: AppString.enterAreaBuildingName,
      textInputAction: TextInputAction.done,
      validator: areaBuildingNameValidator,
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

  Widget _buildAddAreaWidget() {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s12.h),
        child: CustomExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            AppString.addAreaBuilding,
            style: TextStyle(
                fontSize: Sizes.s16.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.s18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryTextField(
                    labelText: AppString.areaBuilding,
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
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
                ],
              ),
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
                      padding: EdgeInsets.only(bottom: Sizes.s16.h),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAreaForm() {
    return Form(
      key: _controller.areaFormKey,
      child: Column(
        children: [
          _buildAreaNameWidget(),
          SizedBoxH12(),
          PrimaryButton(
            label: AppString.submit,
            onPressed: () {
              if (_controller.areaFormKey.currentState!.validate()) {
                _controller.addArea(context);
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildAddFloorPlanWidget() {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s12.h),
        child: CustomExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            AppString.addFloorPlan,
            style: TextStyle(
                fontSize: Sizes.s16.sp,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w500),
          ),
          children: [
            SizedBoxH20(),
            Obx(
              () => Column(
                children: [
                  PrimaryTextField(
                    labelText: AppString.selectAreaBuilding,
                    controller: (_controller.floorSelectAreaValue.value.areaName
                                ?.isNotEmpty ??
                            false)
                        ? TextEditingController(
                            text:
                                _controller.floorSelectAreaValue.value.areaName)
                        : TextEditingController(),
                    readOnly: true,
                    hintText: AppString.selectAreaBuilding,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: Sizes.s15.w),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.blackColor,
                      ),
                    ),
                    onTap: () {
                      _controller.isFloorSelectAreaDropDownOpen.value =
                          !_controller.isFloorSelectAreaDropDownOpen.value;
                    },
                  ),
                  SizedBoxH10(),
                  ExpandedSection(
                    expand: _controller.isFloorSelectAreaDropDownOpen.value,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
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
                        children: _controller.selectNewArea.map((value) {
                          return InkWell(
                            onTap: () {
                              _controller.floorSelectAreaChanged(value);
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.s16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryTextField(
                                labelText: AppString.floorName,
                                controller: _controller.floorNameController,
                                hintText: AppString.enterFloorName,
                                focusedBorder: AppColors.primaryColor,
                                borderColor:
                                    _controller.isFloorPlanValidate.value
                                        ? AppColors.borderColor
                                        : AppColors.redColor,
                                textInputAction: TextInputAction.done,
                              ),
                              !_controller.isFloorPlanValidate.value
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: Sizes.s10.w, top: Sizes.s5.h),
                                      child: Text(
                                        "Please enter floor name",
                                        style: TextStyle(
                                            fontSize: Sizes.s12.sp,
                                            color: AppColors.redColor),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      SizedBoxW15(),
                      PrimaryButton(
                        onPressed: () async {
                          await _controller.addFloorOnTap();
                        },
                        margin: EdgeInsets.only(top: Sizes.s15.h),
                        label: AppString.add,
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.s14.h, horizontal: Sizes.s16.w),
                      )
                    ],
                  ),
                  SizedBoxH10(),
                ],
              ),
            ),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.floorPlan.value.floorData?.length ?? 0,
                itemBuilder: (context, index) {
                  return Theme(
                    data:
                        ThemeData().copyWith(dividerColor: Colors.transparent),
                    child: CustomExpansionTile(
                      isCustomTile: true,
                      title: Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _controller.floorPlan.value.floorData?[index]
                                      .floorName ??
                                  '',
                              style: TextStyle(fontSize: Sizes.s16.sp),
                            ),
                            SizedBoxW5(),
                            Text(
                              '(${_controller.floorPlan.value.floorData?[index].imageData?.length ?? 0} Photos)',
                              style: TextStyle(
                                  color: AppColors.greyFontColor,
                                  fontSize: Sizes.s12.sp),
                            ),
                            const Spacer(),
                            /*SvgPicture.asset(AppAssets.edit,
                                height: Sizes.s16.h, width: Sizes.s16.w),
                            SizedBoxW15(),*/
                            GestureDetector(
                              onTap: () {
                                DeleteFloorDialog.show(context, () {
                                  _controller.removeFloorOnTap(index);
                                  Get.back();
                                });
                              },
                              child: SvgPicture.asset(AppAssets.roundRemove,
                                  height: Sizes.s20.h, width: Sizes.s20.w),
                            ),
                          ],
                        ),
                      ),
                      trailing: const SizedBox.shrink(),
                      children: [SizedBoxH08(), _buildFloorImageGrid(index)],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBoxH15();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFloorImageGrid(int index) {
    return GridView.builder(
      itemCount:
          (_controller.floorPlan.value.floorData?[index].imageData?.length ??
                  0) +
              1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: Sizes.s44.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.6),
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0),
      itemBuilder: (BuildContext context, int gridIndex) {
        if (_controller.floorPlan.value.floorData?[index].imageData?.length ==
            gridIndex) {
          return _buildAddImageWidget(index, gridIndex);
        } else {
          return _buildImageWidget(
              _controller.floorPlan.value.floorData?[index]
                      .imageData?[gridIndex].img ??
                  '',
              index,
              gridIndex);
        }
      },
    );
  }

  Widget _buildImageWidget(String image, int index, int gridIndex) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          child: ImageView(
            width: double.infinity,
            imageUrl: image,
          ),
        ),
        Positioned(
          top: Sizes.s5.h,
          right: Sizes.s5.h,
          child: GestureDetector(
            onTap: () {
              DeleteImageDialog.show(context, () {
                Get.back();
                _controller.floorPlan.value.floorData?[index].imageData
                    ?.removeAt(gridIndex);
                int floorPlanIndex = _controller.floorPlanList.indexWhere(
                    (element) =>
                        _controller.floorPlan.value.areaName ==
                        element.areaName);
                _controller
                    .floorPlanList[floorPlanIndex].floorData?[index].imageData
                    ?.removeAt(gridIndex);
                _controller.floorPlan.refresh();
              });
            },
            child: SvgPicture.asset(
              AppAssets.roundRemove,
              height: Sizes.s15.w,
              width: Sizes.s15.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageWidget(int index, int gridIndex) {
    return GestureDetector(
      onTap: () async {
        await _controller.addImageOnTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [2, 3],
          radius: const Radius.circular(8),
          color: AppColors.primaryColor,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.upload),
                SizedBoxH5(),
                Text(
                  AppString.addImage,
                  style: TextStyle(
                      fontSize: Sizes.s10.sp, color: AppColors.primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Sizes.s24.w, vertical: Sizes.s12.h),
      child: PrimaryButton(
        label: AppString.save,
        onPressed: () {
          _controller.saveOnClick(context);
        },
      ),
    );
  }
}
