import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen>
    with ValidationMixin {
  final PersonalDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.updatePassword,
      ),
      body: Form(
        key: _controller.formKey,
        child: FlexibleScrollView.withSafeArea(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
          children: [
            _buildOldPasswordWidget(),
            SizedBoxH12(),
            _buildNewPasswordWidget(),
            SizedBoxH12(),
            _buildConfirmPasswordWidget(),
            const Spacer(),
            SizedBoxH25(),
            PrimaryButton(
              label: AppString.submit,
              onPressed: () {
                _controller.changePassword(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOldPasswordWidget() {
    return PrimaryTextField(
      labelText: AppString.oldPassword,
      controller: _controller.oldPassword,
      hintText: AppString.enterOldPassword,
      obscureText: _controller.isOldPasswordVisible.value,
      validator: passwordValidator,
      suffixIcon: GestureDetector(
        onTap: () {
          _controller.isOldPasswordVisible.value =
          !_controller.isOldPasswordVisible.value;
          setState(() {});
        },
        child: Padding(
          padding: EdgeInsets.only(right: Sizes.s12.w),
          child: SvgPicture.asset(
            _controller.isOldPasswordVisible.value
                ? AppAssets.eyeOff
                : AppAssets.eye,
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordWidget() {
    return Obx(
      () => PrimaryTextField(
        labelText: AppString.newPassword,
        controller: _controller.password,
        hintText: AppString.enterNewPassword,
        obscureText: _controller.isNewPasswordVisible.value,
        validator: passwordValidator,
        suffixIcon: GestureDetector(
          onTap: () {
            _controller.isNewPasswordVisible.value =
                !_controller.isNewPasswordVisible.value;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.only(right: Sizes.s12.w),
            child: SvgPicture.asset(
              _controller.isNewPasswordVisible.value
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
}
