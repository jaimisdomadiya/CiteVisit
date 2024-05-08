import 'dart:io';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/authentication/sign_in_screen/controller/sign_in_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with ValidationMixin {
  final SignInController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryColorAppBar(),
      backgroundColor: AppColors.primaryColor,
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
            _buildSignInForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Container(
      alignment: Alignment.centerLeft,
      padding:
          EdgeInsets.symmetric(horizontal: Sizes.s16.w, vertical: Sizes.s24.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Sizes.s16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.signIn,
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
          _buildPasswordWidget(),
          SizedBoxH10(),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.resetPassword);
              },
              child: Text(
                AppString.forgotPassword,
                style: TextStyle(
                    color: AppColors.primaryColor, fontSize: Sizes.s12.sp),
              ),
            ),
          ),
          SizedBoxH25(),
          PrimaryButton(
            label: AppString.signIn,
            onPressed: () {
              _controller.signInOnClick(context);
            },
          ),
          SizedBoxH25(),
          Align(
            alignment: Alignment.center,
            child: Text(
              AppString.or,
              style: TextStyle(
                  fontSize: Sizes.s12.sp, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBoxH15(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Platform.isIOS
                  ? _buildSocialButton(
                      icon: AppAssets.apple,
                      onTap: () {
                        _controller.signInWithApple(context);
                      })
                  : const SizedBox.shrink(),
              Platform.isIOS ? SizedBoxW15() : const SizedBox.shrink(),
              _buildSocialButton(
                icon: AppAssets.google,
                onTap: () {
                  _controller.googleSignIn(context);
                },
              ),
            ],
          ),
          SizedBoxH15(),
          Text.rich(
            TextSpan(
              text: AppString.dontHaveAccount,
              style: TextStyle(
                fontSize: Sizes.s14.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: AppString.signUp,
                  style: TextStyle(
                    fontSize: Sizes.s14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(Routes.signUp);
                    },
                ),
              ],
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
      validator: emailValidator,
      hintText: AppString.enterEmail,
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

  Widget _buildPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.password,
        controller: _controller.password,
        validator: passwordValidator,
        hintText: AppString.enterPassword,
        obscureText: _controller.isPasswordVisible.value,
        textInputAction: TextInputAction.done,
        suffixIcon: GestureDetector(
          onTap: () {
            _controller.isPasswordVisible.value =
                !_controller.isPasswordVisible.value;
          },
          child: Padding(
            padding: EdgeInsets.only(right: Sizes.s12.w),
            child: SvgPicture.asset(
              _controller.isPasswordVisible.value
                  ? AppAssets.eyeOff
                  : AppAssets.eye,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      {required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.blackColor.withOpacity(0.12),
                offset: const Offset(0, 2),
                spreadRadius: 0,
                blurRadius: 15)
          ],
        ),
        child: SvgPicture.asset(
          icon,
          width: Sizes.s20.w,
          height: Sizes.s20.h,
        ),
      ),
    );
  }
}
