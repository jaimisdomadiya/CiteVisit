import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/screens/authentication/otp_verification/controller/otp_verification_controller.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpVerificationController _controller = Get.find();

  @override
  void dispose() {
    _controller.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const PrimaryColorAppBar(),
      body: ScrollableColumn.withSafeArea(
        mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.otpVerification,
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
                Text(
                  AppString.otpVerificationDesc,
                  style: TextStyle(
                      color: AppColors.greyFontColor, fontSize: Sizes.s16.sp),
                ),
                SizedBoxH25(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        _controller.emailValue.value.trim(),
                        style: TextStyle(fontSize: Sizes.s16.sp),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(AppAssets.edit)),
                  ],
                ),
                SizedBoxH25(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(Sizes.s12.r),
                          fieldHeight: Sizes.s42.w,
                          fieldWidth: Sizes.s42.w,
                          activeColor: AppColors.borderColor,
                          activeFillColor: AppColors.whiteColor,
                          inactiveFillColor: AppColors.whiteColor,
                          inactiveColor: AppColors.borderColor,
                          selectedColor: AppColors.primaryColor,
                          selectedFillColor: AppColors.whiteColor,
                          borderWidth: 1,
                        ),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        animationDuration: const Duration(milliseconds: 300),
                        textStyle: TextStyle(fontSize: Sizes.s14.sp),
                        enableActiveFill: true,
                        showCursor: true,
                        cursorHeight: Sizes.s20.h,
                        cursorColor: AppColors.primaryColor,
                        controller: _controller.otpCode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onCompleted: (value) {},
                        onChanged: (value) {},
                        beforeTextPaste: (text) {
                          return true;
                        },
                        autoDismissKeyboard: true,
                        autoFocus: true,
                        focusNode: _controller.otpFocusNode,
                        autoDisposeControllers: true,
                        errorTextSpace: 0.0,
                      ),
                    ),
                    SizedBoxW50(),
                    if (_controller.timer.isActive) ...[
                      Obx(
                        () => Text(
                          "(00:${_controller.seconds.toString().padLeft(2, '0')})",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: Sizes.s12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ]
                  ],
                ),
                SizedBoxH25(),
                PrimaryButton(
                  label: AppString.submit,
                  onPressed: () {
                    _controller.onVerifyOtp(context);
                  },
                ),
                SizedBoxH25(),
                Text.rich(
                  TextSpan(
                    text: AppString.didtReceivedTheOtp,
                    style: TextStyle(
                      fontSize: Sizes.s14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: AppString.resendOtp,
                        style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          color: AppColors.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (_controller.seconds.value == 0) {
                              await _controller.resendOtpApi(context);
                               _controller.startTimer();
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
