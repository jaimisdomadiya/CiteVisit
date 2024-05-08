import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteImageDialog extends StatefulWidget {
  const DeleteImageDialog({super.key, required this.yesOnTap});
  final VoidCallback yesOnTap;
  static Future<void> show(BuildContext context, VoidCallback yesOnTap) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: DeleteImageDialog(yesOnTap: yesOnTap),
        );
      },
    );
  }

  @override
  State<DeleteImageDialog> createState() => _DeleteImageDialogState();
}

class _DeleteImageDialogState extends State<DeleteImageDialog> {
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
            horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.deleteImageText,
              style: TextStyle(
                  fontSize: Sizes.s18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBoxH25(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton.outlined(
                    label: AppString.no,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBoxW15(),
                Expanded(
                  child: PrimaryButton(
                    label: AppString.yes,
                    onPressed: () {
                      widget.yesOnTap();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
