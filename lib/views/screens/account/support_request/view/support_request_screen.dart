import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SupportRequestScreen extends StatefulWidget {
  const SupportRequestScreen({Key? key}) : super(key: key);

  @override
  State<SupportRequestScreen> createState() => _SupportRequestScreenState();
}

class _SupportRequestScreenState extends State<SupportRequestScreen>
    with ValidationMixin {
  final PersonalDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.supportRequest,
      ),
      body: FlexibleScrollView.withSafeArea(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
        children: [
          Text(
            AppString.inquiries,
            style: TextStyle(fontSize: Sizes.s16.sp),
          ),
          SizedBoxH08(),
          HtmlEditor(
            controller: _controller.controller,
            htmlEditorOptions: HtmlEditorOptions(
              hint: AppString.enterYourTextHere,
            ),
            htmlToolbarOptions: const HtmlToolbarOptions(
                toolbarType: ToolbarType.nativeGrid,
                defaultToolbarButtons: [
                  FontButtons(
                    clearAll: false,
                    subscript: false,
                    superscript: false,
                  ),
                  StyleButtons(style: false),
                  ColorButtons(foregroundColor: false, highlightColor: false),
                  ListButtons(listStyles: false),
                ],
                buttonHighlightColor: AppColors.lightPrimaryColor,
                buttonSelectedColor: AppColors.primaryColor,
                buttonFillColor: AppColors.lightPrimaryColor,
                buttonFocusColor: AppColors.lightPrimaryColor),
            otherOptions: const OtherOptions(
              height: 200,
            ),
          ),
          SizedBoxH08(),
          Obx(
            () => _controller.isInquiryValidate.value
                ? Text(
                    "Please enter text",
                    style: TextStyle(
                        fontSize: Sizes.s16.sp, color: AppColors.redColor),
                  )
                : const SizedBox.shrink(),
          ),
          const Spacer(),
          PrimaryButton(
            label: AppString.sendInquiry,
            onPressed: () async {
              String data = await _controller.controller.getText();

              if (!mounted) return;
              if (data.isNotEmpty) {
                _controller.isInquiryValidate.value = false;
                _controller.sendInquiry(context);
              } else {
                _controller.isInquiryValidate.value = true;
              }
            },
          ),
        ],
      ),
    );
  }
}
