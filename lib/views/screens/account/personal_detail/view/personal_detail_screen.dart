import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen>
    with ValidationMixin {
  final PersonalDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.personalDetails,
      ),
      body: Form(
        key: _controller.formKey,
        child: FlexibleScrollView.withSafeArea(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
          children: [
            _buildManagerWidget(),
            SizedBoxH12(),
            _buildEmailWidget(),
            SizedBoxH12(),
            _buildProfileImageWidget(),
            const Spacer(),
            SizedBoxH25(),
            PrimaryButton(
              label: AppString.submit,
              onPressed: () {
                _controller.updateProfile(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildManagerWidget() {
    return PrimaryTextField(
      labelText: AppString.managerName,
      controller: _controller.manager,
      hintText: AppString.enterManagerName,
      suffixIconName: AppAssets.profileOutline,
      validator: managerNameValidator,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
    );
  }

  Widget _buildEmailWidget() {
    return PrimaryTextField(
      labelText: AppString.email,
      controller: _controller.email,
      hintText: AppString.enterEmail,
      readOnly: true,
      suffixIconName: AppAssets.email,
      validator: emailValidator,
    );
  }

  Widget _buildProfileImageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.profile,
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBoxH10(),
        GestureDetector(
          onTap: () {
            _controller.bottomSheet();
          },
          child: Obx(
            () => _controller.profileImageUrl.value.isEmpty
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [5, 5],
                    radius: const Radius.circular(8),
                    color: AppColors.borderColor,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: Sizes.s30.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.upload,
                            height: Sizes.s60.w,
                            width: Sizes.s60.h,
                          ),
                          SizedBoxH15(),
                          Text(
                            '+ ${AppString.addImage}',
                            style: TextStyle(
                                fontSize: Sizes.s14.sp,
                                color: AppColors.primaryColor),
                          )
                        ],
                      ),
                    ),
                  )
                : Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.s10.r),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderColor)),
                          child: ImageView(
                            imageUrl: _controller.profileImageUrl.value,
                            height: Sizes.s170.h,
                            width: double.infinity,
                            radius: Sizes.s10.r,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: Sizes.s12.r,
                        backgroundColor: AppColors.whiteColor,
                        child: SvgPicture.asset(AppAssets.edit,
                            height: Sizes.s16.h, width: Sizes.s16.w),
                      ),
                    )
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
