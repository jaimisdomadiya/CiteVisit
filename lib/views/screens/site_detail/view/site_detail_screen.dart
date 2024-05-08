import 'dart:io';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/screens/site_detail/widget/add_area_dialog.dart';
import 'package:cityvisit/views/screens/site_detail/widget/delete_area_dialog.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/expansion_tile.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SiteDetailScreen extends StatefulWidget {
  const SiteDetailScreen({Key? key}) : super(key: key);

  @override
  State<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  final SiteDetailController _controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getAreaAndEmployeeData(context);
      _controller.siteDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => _controller.isLoading.value
              ? Loader.circularProgressIndicator()
              : Stack(
                  children: [
                    _buildBackgroundImage(),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s24.w, vertical: Sizes.s20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBoxH150(),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.s16.w,
                                    vertical: Sizes.s16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(Sizes.s12.r),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 4),
                                        color: AppColors.blackColor
                                            .withOpacity(0.1),
                                        blurRadius: 12,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _controller.siteDetailModal.value
                                                .siteAddress ??
                                            '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Sizes.s14.sp),
                                      ),
                                      _buildMemberList(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              AppString.areaBuildingListing,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Sizes.s16.sp),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                AddAreaDialog.show(context);
                                              },
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  '+ ${AppString.addAreaBuilding}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: Sizes.s14.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBoxH25(),
                                      Obx(
                                        () => ListView.separated(
                                          shrinkWrap: true,
                                          itemCount:
                                              _controller.floorPlan.length,
                                          itemBuilder: (context, index) {
                                            return Theme(
                                              data: ThemeData().copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: CustomExpansionTile(
                                                isCustomTile: true,
                                                title: Expanded(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        _controller
                                                                .floorPlan[
                                                                    index]
                                                                .areaName ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize:
                                                                Sizes.s16.sp),
                                                      ),
                                                      const Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _controller
                                                              .selectedAreaIndex
                                                              .value = index;
                                                          Get.toNamed(
                                                              Routes.editArea);
                                                        },
                                                        child: SvgPicture.asset(
                                                            AppAssets.edit,
                                                            height: Sizes.s16.h,
                                                            width: Sizes.s16.w),
                                                      ),
                                                      SizedBoxW15(),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          DeleteAreaDialog.show(
                                                              context, () {
                                                            Get.back();
                                                            _controller
                                                                .deleteArea(
                                                                    context,
                                                                    index:
                                                                        index);
                                                          });
                                                        },
                                                        child: SvgPicture.asset(
                                                            AppAssets
                                                                .roundRemove,
                                                            height: Sizes.s20.h,
                                                            width: Sizes.s20.w),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing:
                                                    const SizedBox.shrink(),
                                                children: [
                                                  SizedBoxH08(),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: Sizes.s44.w),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        alignment:
                                                            WrapAlignment.start,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        direction:
                                                            Axis.horizontal,
                                                        runSpacing: 10,
                                                        spacing: Sizes.s12.w,
                                                        children: List.generate(
                                                          _controller
                                                                  .floorPlan[
                                                                      index]
                                                                  .floorData
                                                                  ?.length ??
                                                              0,
                                                          (index2) =>
                                                              IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  _controller
                                                                          .floorPlan[
                                                                              index]
                                                                          .floorData?[
                                                                              index2]
                                                                          .floorName ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontSize: Sizes
                                                                          .s12
                                                                          .sp),
                                                                ),
                                                                SizedBoxW12(),
                                                                ((_controller.floorPlan[index].floorData?.length ??
                                                                                0) -
                                                                            1) !=
                                                                        index
                                                                    ? const VerticalDivider(
                                                                        width:
                                                                            0,
                                                                        color: AppColors
                                                                            .greyFontColor,
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink()
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBoxH15();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Stack(
      children: [
        ClipPath(
          clipper: CustomShape(),
          child: ImageView(
              imageUrl: _controller.siteDetailModal.value.siteImage,
              errorWidget: Image.asset(
                AppAssets.citePlaceholder,
                fit: BoxFit.cover,
              ),
              height: Sizes.s280.h,
              radius: 0,
              width: double.infinity),
        ),
        _appBar(),
      ],
    );
  }

  Widget _appBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s20.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryBackButton(color: AppColors.blackColor),
            SizedBoxW15(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.siteDetailModal.value.siteName ?? '',
                    style: TextStyle(
                        fontSize: Sizes.s20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor),
                  ),
                  SizedBoxH5(),
                  Text(
                    _controller.siteDetailModal.value.projectName ?? '',
                    style: TextStyle(
                      fontSize: Sizes.s12.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.s25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppString.members,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: Sizes.s18.sp),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  var response = await Get.toNamed(
                    Routes.addEmployee,
                    arguments: {
                      "project_id": _controller.projectId,
                      "isFromProjectDetails": true,
                      "site_id": _controller.siteId.value
                    },
                  );
                  if (response != null && (response as bool)) {
                    _controller.siteDetails();
                  }
                },
                child: Text(
                  AppString.addEmployeePlus,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Sizes.s14.sp),
                ),
              ),
            ],
          ),
          SizedBoxH12(),
          SizedBox(
            height: Sizes.s54.h,
            child: (_controller
                        .siteDetailModal.value.membersProfile?.isNotEmpty ??
                    false)
                ? Row(
                    children: [
                      ListView.builder(
                          itemCount: (_controller.siteDetailModal.value
                                          .membersProfile?.length ??
                                      0) >=
                                  6
                              ? 6
                              : (_controller.siteDetailModal.value
                                      .membersProfile?.length ??
                                  0),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Align(
                              widthFactor: 0.70,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: (Sizes.s44 / 2).r,
                                child: ProfileView(
                                    imageUrl: _controller
                                            .siteDetailModal
                                            .value
                                            .membersProfile?[index]
                                            .profilePic ??
                                        '',
                                    name: _controller.siteDetailModal.value
                                        .membersProfile?[index].name,
                                    radius: Sizes.s50.r,
                                    height: Sizes.s30.w,
                                    width: Sizes.s30.w),
                              ),
                            );
                          }),
                      (_controller.siteDetailModal.value.membersProfile
                                      ?.length ??
                                  0) >
                              6
                          ? Align(
                              widthFactor: 0.70,
                              child: CircleAvatar(
                                backgroundColor: AppColors.greyBackgroundColor,
                                radius: (Sizes.s34 / 2).r,
                                child: Text(
                                  "${(_controller.siteDetailModal.value.membersProfile?.length ?? 0) - 6}+",
                                  style: TextStyle(
                                      fontSize: Sizes.s10.sp,
                                      color: AppColors.blackColor),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : Center(
                    child: Text(
                      "No member found.",
                      style: TextStyle(
                          fontSize: Sizes.s14.sp, color: AppColors.blackColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageWidget() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.takePhoto);
      },
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
    );
  }

  Widget _buildFloorImageGrid(int index) {
    return GridView.builder(
      itemCount:
          (_controller.floorListing[index].floorImageList?.length ?? 0) + 1,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Sizes.s44.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.6),
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0),
      itemBuilder: (BuildContext context, int gridIndex) {
        if (_controller.floorListing[index].floorImageList?.length ==
            gridIndex) {
          return _buildAddImageWidget();
        } else {
          return _buildImageWidget(
              _controller.floorListing[index].floorImageList?[gridIndex] ?? '');
        }
      },
    );
  }

  Widget _buildImageWidget(String image) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.takePhoto);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            child: Image.file(
              File(image),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: Sizes.s5.h,
            right: Sizes.s5.h,
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppAssets.roundRemove,
                height: Sizes.s15.w,
                width: Sizes.s15.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 40);
    path.quadraticBezierTo(width / 2, height, width, height - 40);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
