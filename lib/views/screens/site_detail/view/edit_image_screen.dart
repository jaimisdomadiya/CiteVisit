import 'dart:developer';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/views/screens/photo/controller/photo_controller.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/screens/site_detail/widget/comment_dialog.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({Key? key}) : super(key: key);

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  final SiteDetailController _controller = Get.find();

  @override
  void initState() {
    if (Get.arguments != null) {
      _controller.isFromEdit.value = Get.arguments['isFromEdit'];
      _controller.positionList.clear();
      _controller.initBackground(Get.arguments['isFromEdit']);

      if (Get.arguments['isFromEdit']) {
        _controller
            .floorPlan[_controller.selectedAreaIndex.value]
            .floorData?[_controller.selectedFloorIndex.value]
            .imageData?[_controller.selectedImageIndex.value]
            .coordinates
            ?.forEach((element) {
          _controller.positionList.add(
            TagModal(
              textEditingController: TextEditingController(text: element.msg),
              offset: Offset(
                double.parse(element.x ?? ""),
                double.parse(element.y ?? ""),
              ),
            ),
          );
        });
      }
      _controller.selectedIconIndex.value = 2;

      log(_controller.positionList.length.toString(),
          name: "positionList Length");
      log(_controller.isFromEdit.value.toString(), name: "isFromEdit");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Obx(
              () => Expanded(
                child: Stack(
                  children: [
                    _buildImageWidget(),
                    _buildTagListWidget(),
                    _buildBottomOptionWidget()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: !(_controller.selectedIconIndex.value == 2)
            ? null
            : (position) async {
                FocusScope.of(context).unfocus();
                _controller.positionList.add(TagModal(
                    offset: position.localPosition,
                    textEditingController: TextEditingController()));
              },
        child: IgnorePointer(
          ignoring: _controller.selectedIconIndex.value == 2,
          child: FlutterPainter(
            controller: _controller.controller,
          ),
        ),
      ),
    );
  }

  Widget _buildTagListWidget() {
    return Stack(
      children: List.generate(
        _controller.positionList.length,
        (index) {
          return Positioned(
            top: _controller.positionList[index].offset!.dy,
            left: _controller.positionList[index].offset!.dx - 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: Sizes.s18.w),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: Sizes.s20.r,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: Sizes.s94.w,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Sizes.s10.h, right: Sizes.s18.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.s5.r),
                          child: TextFormField(
                            controller: _controller
                                .positionList[index].textEditingController,
                            enabled: _controller.selectedIconIndex.value == 2,
                            cursorHeight: 19,
                            cursorWidth: 1,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            style: TextStyle(fontSize: Sizes.s14.sp),
                            onTap: () {
                              _controller.currentTapIndex.value = index;
                            },
                            onChanged: _controller.onChanged,
                            onFieldSubmitted: (String? value) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Sizes.s5.h,
                                vertical: Sizes.s5.h,
                              ),
                              isDense: true,
                              border: _border(),
                              focusedBorder: _border(),
                              enabledBorder: _border(),
                              errorBorder: _border(),
                              focusedErrorBorder: _border(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: Sizes.s12.w,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _controller.positionList.removeAt(index);
                          },
                          child: Icon(
                            Icons.cancel_sharp,
                            size: Sizes.s18.w,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                _controller.promptList.isNotEmpty &&
                        _controller.currentTapIndex.value == index
                    ? Container(
                        width: Sizes.s94.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(Sizes.s5.r),
                        ),
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            itemCount: _controller.promptList.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes.s5.w, vertical: Sizes.s8.h),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index2) {
                              return GestureDetector(
                                onTap: () {
                                  _controller
                                      .positionList[index]
                                      .textEditingController!
                                      .text = _controller.promptList[index2];
                                  _controller
                                      .positionList[index]
                                      .textEditingController
                                      ?.selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _controller
                                                .positionList[index]
                                                .textEditingController
                                                ?.text
                                                .length ??
                                            0),
                                  );
                                  _controller.promptList.clear();
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  _controller.promptList[index2],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: Sizes.s2.h);
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          );
        },
        growable: false,
      ).toList(),
    );
  }

  Widget _buildBottomOptionWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _controller.renderAndDisplayImage(context);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: Sizes.s16.h, right: Sizes.s24.w),
                  padding: EdgeInsets.all(Sizes.s14.r),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor, shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.whiteColor,
                    size: Sizes.s16.w,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _controller.controller,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.white54,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_controller.controller.freeStyleMode !=
                              FreeStyleMode.none) ...[
                            const Divider(),
                            const Text("Free Style Settings"),
                            // Control free style stroke width
                            Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: Text("Stroke Width")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                      min: 2,
                                      max: 25,
                                      value: _controller
                                          .controller.freeStyleStrokeWidth,
                                      onChanged:
                                          _controller.setFreeStyleStrokeWidth),
                                ),
                              ],
                            ),
                            if (_controller.controller.freeStyleMode ==
                                FreeStyleMode.draw)
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  // Control free style color hue
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(_controller
                                                .controller.freeStyleColor)
                                            .hue,
                                        activeColor: _controller
                                            .controller.freeStyleColor,
                                        onChanged:
                                            _controller.setFreeStyleColor),
                                  ),
                                ],
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(
                    bottom: Sizes.s24.h, left: Sizes.s24.w, right: Sizes.s24.h),
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s24.w, vertical: Sizes.s16.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _controller.bottomIcon.length,
                    (index) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        _controller.bottomIconOnTap(index);
                      },
                      child: SvgPicture.asset(
                        _controller.bottomIcon[index],
                        height: Sizes.s24.w,
                        width: Sizes.s24.w,
                        color: _controller.selectedIconIndex.value == index
                            ? AppColors.primaryColor
                            : AppColors.greyFontColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.only(
          left: Sizes.s24.w,
          right: Sizes.s24.w,
          top: Sizes.s23.h,
          bottom: Sizes.s15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
          SizedBoxW15(),
          Text(
            _controller.addFloorSelectedValue.value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            "",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          _controller.isFromEdit.value ? GestureDetector(
            onTap: () async{
              _controller.getComment(context);
              await CommentDialog.show(context);
            },
            child: SvgPicture.asset(
              AppAssets.message,
              color: AppColors.blackColor,
            ),
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.s5.r),
      borderSide: const BorderSide(color: AppColors.whiteColor),
    );
  }
}
