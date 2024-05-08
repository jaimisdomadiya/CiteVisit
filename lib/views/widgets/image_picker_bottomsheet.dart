import 'package:cityvisit/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageBottomSheet extends StatelessWidget {
  const ImageBottomSheet({
    Key? key,
    this.cameraOnTap,
    this.galleryOnTap,
  }) : super(key: key);

  final GestureTapCallback? galleryOnTap;
  final GestureTapCallback? cameraOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: cameraOnTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  const Icon(Icons.camera_rounded),
                  SizedBox(width: 15.w),
                  Text(
                    "Camara",
                    style: TextStyle(fontSize: Sizes.s16.sp),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: galleryOnTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.only(
                  top: 10.h, left: 20.w, right: 20.w, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  const Icon(Icons.wallpaper_rounded),
                  SizedBox(width: 15.w),
                  Text(
                    'Gallery',
                    style: TextStyle(fontSize: Sizes.s16.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
