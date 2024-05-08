import 'dart:developer';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/screens/authentication/sign_up_screen/controller/sign_up_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({Key? key}) : super(key: key);

  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  final SignUpController _controller = Get.find();

  @override
  void initState() {
    if (Get.arguments != null) {
      _controller.user = Get.arguments['user'];
      _controller.isGoogleSignIn = Get.arguments['isGoogleSignIn'];
      log(_controller.user?.uid ?? '', name: "UID");
      log(_controller.user?.displayName ?? '', name: "displayName");
      log(_controller.user?.email ?? '', name: "email");
      log(_controller.isGoogleSignIn.toString(), name: "isGoogleSignIn");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryColorAppBar(),
      backgroundColor: AppColors.primaryColor,
      body: Form(
        key: _controller.businessNameFormKey,
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
              _buildBusinessForm()
            ]),
      ),
    );
  }

  Widget _buildBusinessForm() {
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
          if (!_controller.isGoogleSignIn) ...[
            _buildManagerWidget(),
            SizedBoxH20(),
          ],
          _buildBusinessWidget(),
          SizedBoxH25(),
          PrimaryButton(
            label: AppString.continueText,
            onPressed: () {
              log(_controller.businessName.text, name: "BusinessName");
              _controller.continueOnClick(context);
            },
          ),
          SizedBoxH25(),
        ],
      ),
    );
  }

  Widget _buildManagerWidget() {
    return PrimaryTextField(
      labelText: AppString.managerName,
      controller: _controller.manager,
      hintText: AppString.enterManagerName,
      suffixIconName: AppAssets.profileOutline,
      validator: _controller.managerNameValidator,
    );
  }

  Widget _buildBusinessWidget() {
    return PrimaryTextField(
      labelText: AppString.businessName,
      controller: _controller.businessName,
      hintText: AppString.enterBusinessName,
      suffixIconName: AppAssets.business,
      validator: _controller.businessNameValidator,
      textInputAction: TextInputAction.done,
    );
  }
}
