import 'package:cityvisit/core/constants/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.label,
      this.height,
      this.margin,
      this.padding,
      this.onPressed,
      this.width,
      this.gradientColors,
      this.radius,
      this.alignment,
      this.isLoaderShow,
      this.labelStyle})
      : outlined = false,
        super(key: key);

  const PrimaryButton.outlined(
      {Key? key,
      required this.label,
      this.height,
      this.margin,
      this.padding,
      this.onPressed,
      this.width,
      this.gradientColors,
      this.radius,
      this.alignment,
      this.isLoaderShow,
      this.labelStyle})
      : outlined = true,
        super(key: key);

  final String label;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onPressed;
  final TextStyle? labelStyle;
  final double? height;
  final double? width;
  final double? radius;
  final AlignmentGeometry? alignment;
  final List<Color>? gradientColors;
  final bool? isLoaderShow;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    var textColor = outlined ? AppColors.primaryColor : AppColors.whiteColor;
    var backgroundColor =
        outlined ? AppColors.whiteColor : AppColors.primaryColor;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        margin: margin,
        padding: padding ?? EdgeInsets.symmetric(vertical: Sizes.s16.h),
        alignment: alignment ?? Alignment.center,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: outlined
                ? Border.all(color: textColor)
                : Border.all(color: backgroundColor),
            borderRadius: BorderRadius.circular(radius ?? Sizes.s12.r)),
        child: isLoaderShow ?? false
            ? SizedBox(
                height: Sizes.s16.w,
                width: Sizes.s16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                ),
              )
            : Text(
                label,
                style: labelStyle ??
                    TextStyle(
                        fontSize: Sizes.s16.sp,
                        color: textColor,
                        fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
