import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/create_project/widget/delete_floor_dialog.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/screens/site_detail/widget/add_floor_dialog.dart';
import 'package:cityvisit/views/screens/site_detail/widget/delete_image_dialog.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/expansion_tile.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AreaEditScreen extends StatefulWidget {
  const AreaEditScreen({Key? key}) : super(key: key);

  @override
  State<AreaEditScreen> createState() => _AreaEditScreenState();
}

class _AreaEditScreenState extends State<AreaEditScreen> {
  final SiteDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: _controller
                .floorPlan[_controller.selectedAreaIndex.value].areaName ??
            '',
        actions: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                AddFloorDialog.show(
                    context,
                    _controller.floorPlan[_controller.selectedAreaIndex.value]
                            .areaName ??
                        '');
              },
              child: Padding(
                padding: EdgeInsets.only(right: Sizes.s24.w),
                child: Text(
                  "+ ${AppString.addFloor}",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: Sizes.s14.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => (_controller.floorPlan[_controller.selectedAreaIndex.value]
                    .floorData?.isNotEmpty ??
                false)
            ? ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
                shrinkWrap: true,
                itemCount: _controller
                        .floorPlan[_controller.selectedAreaIndex.value]
                        .floorData
                        ?.length ??
                    0,
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
                              _controller
                                      .floorPlan[
                                          _controller.selectedAreaIndex.value]
                                      .floorData?[index]
                                      .floorName ??
                                  '',
                              style: TextStyle(fontSize: Sizes.s16.sp),
                            ),
                            SizedBoxW5(),
                            Text(
                              '(${_controller.floorPlan[_controller.selectedAreaIndex.value].floorData?[index].imageData?.length ?? 0} Photos)',
                              style: TextStyle(
                                  color: AppColors.greyFontColor,
                                  fontSize: Sizes.s12.sp),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _controller.selectedFloorIndex.value = index;
                                Get.toNamed(Routes.editFloor);
                              },
                              child: SvgPicture.asset(AppAssets.edit,
                                  height: Sizes.s16.h, width: Sizes.s16.w),
                            ),
                            SizedBoxW15(),
                            GestureDetector(
                              onTap: () async {
                                DeleteFloorDialog.show(context, () {
                                  Get.back();
                                  _controller.deleteFloor(context,
                                      index: index);
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
              )
            : const Center(
                child: ErrorText("No data found"),
              ),
      ),
    );
  }

  Widget _buildAddImageWidget(int index) {
    return GestureDetector(
      onTap: () {
        _controller.addFloorSelectedAreaValue.value = _controller
                .floorPlan[_controller.selectedAreaIndex.value].areaName ??
            '';
        _controller.addFloorSelectedValue.value = _controller
                .floorPlan[_controller.selectedAreaIndex.value]
                .floorData?[index]
                .floorName ??
            '';
        Get.toNamed(Routes.siteDetailsTakePhoto);
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

  Widget _buildFloorImageGrid(int index) {
    return GridView.builder(
      itemCount: (_controller.floorPlan[_controller.selectedAreaIndex.value]
                  .floorData?[index].imageData?.length ??
              0) +
          1,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Sizes.s44.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.6),
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0),
      itemBuilder: (BuildContext context, int gridIndex) {
        if (_controller.floorPlan[_controller.selectedAreaIndex.value]
                .floorData?[index].imageData?.length ==
            gridIndex) {
          return _buildAddImageWidget(index);
        } else {
          return _buildImageWidget(index, gridIndex);
        }
      },
    );
  }

  Widget _buildImageWidget(int index, int gridIndex) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          child: ImageView(
            imageUrl: _controller.floorPlan[_controller.selectedAreaIndex.value]
                    .floorData?[index].imageData?[gridIndex].img ??
                '',
            width: double.infinity,
          ),
        ),
        Positioned(
          top: Sizes.s5.h,
          right: Sizes.s5.h,
          child: GestureDetector(
            onTap: () {
              DeleteImageDialog.show(context, () {
                Get.back();
                _controller.deleteFloorImage(context,
                    index: index, gridIndex: gridIndex);
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
}
