import 'dart:io';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/authentication/sign_up_screen/controller/sign_up_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final SignUpController _controller = Get.find();

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
            _buildSignUpForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizes.s40.h),
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
            AppString.signUp,
            style: TextStyle(
              fontSize: Sizes.s24.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Playfair Display",
            ),
          ),
          SizedBoxH10(),
          Container(
            height: 2,
            width: Sizes.s32.w,
            color: AppColors.primaryColor,
          ),
          SizedBoxH25(),
          Text(
            AppString.letsCreateYourAccount,
            style: TextStyle(
                color: AppColors.greyFontColor, fontSize: Sizes.s16.sp),
          ),
          SizedBoxH25(),
          _buildBusinessWidget(),
          SizedBoxH20(),
          _buildManagerWidget(),
          SizedBoxH20(),
          _buildEmailWidget(),
          SizedBoxH20(),
          // _buildPhoneWidget(),
          // SizedBoxH20(),
          _buildPasswordWidget(),
          SizedBoxH20(),
          _buildConfirmPasswordWidget(),
          SizedBoxH25(),
          PrimaryButton(
            label: AppString.signUp,
            onPressed: () {
              _controller.signUpOnClick(context);
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
                        _controller.signInWithApple();
                      })
                  : const SizedBox.shrink(),
              Platform.isIOS ? SizedBoxW15() : const SizedBox.shrink(),
              _buildSocialButton(
                  icon: AppAssets.google,
                  onTap: () {
                    _controller.googleSignup();
                  }),
            ],
          ),
          SizedBoxH15(),
          Text.rich(
            TextSpan(
              text: AppString.alreadyHaveAccount,
              style: TextStyle(
                fontSize: Sizes.s14.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: AppString.signIn,
                  style: TextStyle(
                    fontSize: Sizes.s14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.back();
                    },
                ),
              ],
            ),
          ),
          Text(
            AppString.dontHaveAccount,
            style: TextStyle(
                fontSize: Sizes.s16.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessWidget() {
    return PrimaryTextField(
      labelText: AppString.businessName,
      controller: _controller.businessName,
      hintText: AppString.enterBusinessName,
      suffixIconName: AppAssets.business,
      validator: _controller.businessNameValidator,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
    );
  }

  Widget _buildManagerWidget() {
    return PrimaryTextField(
      labelText: AppString.managerName,
      controller: _controller.manager,
      hintText: AppString.enterManagerName,
      suffixIconName: AppAssets.profileOutline,
      validator: _controller.managerNameValidator,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
    );
  }

  Widget _buildEmailWidget() {
    return PrimaryTextField(
      labelText: AppString.email,
      controller: _controller.email,
      hintText: AppString.enterEmail,
      suffixIconName: AppAssets.email,
      validator: _controller.emailValidator,
    );
  }

  Widget _buildPhoneWidget() {
    return PrimaryTextField(
      labelText: AppString.phoneNo,
      controller: _controller.phoneNo,
      hintText: AppString.phoneNo,
      suffixIconName: AppAssets.call,
      keyboardType: TextInputType.number,
      validator: _controller.phoneValidator,
    );
  }

  Widget _buildPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.password,
        controller: _controller.password,
        hintText: AppString.enterPassword,
        obscureText: _controller.isPasswordVisible.value,
        validator: _controller.passwordValidator,
        suffixIcon: GestureDetector(
          onTap: () {
            _controller.isPasswordVisible.value =
                !_controller.isPasswordVisible.value;
            setState(() {});
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

  Widget _buildConfirmPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.confirmPassword,
        controller: _controller.confirmPassword,
        hintText: AppString.confirmPassword,
        textInputAction: TextInputAction.done,
        obscureText: _controller.isConfirmPasswordVisible.value,
        validator: (value) {
          return confirmPasswordValidator(
              value, _controller.password.text.trim());
        },
        suffixIcon: GestureDetector(
          onTap: () {
            _controller.isConfirmPasswordVisible.value =
                !_controller.isConfirmPasswordVisible.value;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.only(right: Sizes.s12.w),
            child: SvgPicture.asset(
              _controller.isConfirmPasswordVisible.value
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
