import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/authentication/reset_password/controller/reset_password_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ValidationMixin {
  final ResetPasswordController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const PrimaryColorAppBar(),
      body: Form(
        key: _controller.formKey,
        child: ScrollableColumn.withSafeArea(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
          children: [
            SizedBoxH50(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.logo,
                  width: Sizes.s50.w,
                  height: Sizes.s60.h,
                ),
                SizedBoxW20(),
                Text(
                  AppString.citeVisit.toUpperCase(),
                  style: TextStyle(
                    fontSize: Sizes.s20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                    letterSpacing: 5,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4.0,
                        color: AppColors.blackColor.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBoxH40(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s16.w, vertical: Sizes.s24.h),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(Sizes.s16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.resetPassword,
                    style: TextStyle(
                        color: const Color(0xff1C1C1C),
                        fontSize: Sizes.s24.sp,
                        fontFamily: "Playfair Display",
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBoxH10(),
                  Container(
                    height: 2,
                    width: Sizes.s32.w,
                    color: AppColors.primaryColor,
                  ),
                  SizedBoxH25(),
                  _buildEmailWidget(),
                  SizedBoxH20(),
                  PrimaryButton(
                    label: AppString.sendOTP,
                    onPressed: () {
                      _controller.sendOtpOnClick(context);
                    },
                  ),
                  SizedBoxH25(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmailWidget() {
    return PrimaryTextField(
      labelText: AppString.email,
      controller: _controller.email,
      validator: emailValidator,
      hintText: AppString.enterEmail,
      textInputAction: TextInputAction.done,
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
}
