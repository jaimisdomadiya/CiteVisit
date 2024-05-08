import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/authentication/create_new_password/controller/create_password_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({Key? key}) : super(key: key);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword>
    with ValidationMixin {
  final CreatePasswordController _controller = Get.find();

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
                    AppString.createNewPassword,
                    style: TextStyle(
                        color: const Color(0xff1C1C1C),
                        fontFamily: "Playfair Display",
                        fontSize: Sizes.s24.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBoxH10(),
                  Container(
                    height: 2,
                    width: Sizes.s32.w,
                    color: AppColors.primaryColor,
                  ),
                  SizedBoxH25(),
                  _buildPasswordWidget(),
                  SizedBoxH20(),
                  _buildConfirmPasswordWidget(),
                  SizedBoxH20(),
                  PrimaryButton(
                    label: AppString.submit,
                    onPressed: () {
                      _controller.submitOtpOnClick(context);
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

  Widget _buildPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.password,
        controller: _controller.password,
        hintText: AppString.enterPassword,
        obscureText: _controller.isPasswordVisible.value,
        validator: passwordValidator,
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

  Widget _buildConfirmPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.confirmPassword,
        controller: _controller.confirmPassword,
        hintText: AppString.confirmPassword,
        obscureText: _controller.isConfirmPasswordVisible.value,
        textInputAction: TextInputAction.done,
        validator: (value) {
          return confirmPasswordValidator(
              value, _controller.password.text.trim());
        },
        suffixIcon: GestureDetector(
          onTap: () {
            _controller.isConfirmPasswordVisible.value =
                !_controller.isConfirmPasswordVisible.value;
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
}
