import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackButtonAppBar({
    super.key,
    this.titleText,
    this.actions,
    this.onPressed,
    this.backgroundColor,
    this.fontSize,
  });

  final String? titleText;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: Sizes.s20.w,
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: actions,
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PrimaryBackButton(onBackPressed: onPressed),
          SizedBoxW10(),
          (titleText?.isNotEmpty ?? false)
              ? Text(
                  titleText!,
                  style: TextStyle(
                    fontSize: fontSize ?? Sizes.s18.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PrimaryBackButton extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final Color color;

  const PrimaryBackButton(
      {super.key, this.onBackPressed, this.color = AppColors.blackColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ??
          () {
            Get.back();
          },
      child: Icon(
        Icons.arrow_back,
        color: color,
        size: Sizes.s20.w,
      ),
    );
  }
}
