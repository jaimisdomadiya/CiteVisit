import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/create_project/controller/create_project_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen>
    with ValidationMixin {
  final CreateProjectController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.createNewProject,
      ),
      body: Form(
        key: _controller.formKey,
        child: FlexibleScrollView.withSafeArea(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
          children: [
            _buildProjectNameWidget(),
            SizedBoxH25(),
            GestureDetector(
              onTap: _controller.uploadImageOnTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Sizes.s14.h),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(Sizes.s12.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.cameraOutline,
                      height: Sizes.s16.h,
                      width: Sizes.s16.w,
                    ),
                    SizedBoxW10(),
                    Text(
                      AppString.uploadImage,
                      style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBoxH20(),
            Obx(
              () => (_controller.projectImage.value.isNotEmpty)
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.borderColor)),
                            child: ImageView(
                              height: Sizes.s300.h,
                              width: double.infinity,
                              imageUrl: _controller.projectImage.value,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Sizes.s10.h,
                          right: Sizes.s10.h,
                          child: GestureDetector(
                            onTap: () {
                              _controller.projectImage.value = '';
                            },
                            child: SvgPicture.asset(
                              AppAssets.roundRemove,
                              height: Sizes.s20.w,
                              width: Sizes.s20.h,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBoxH20(),
            const Spacer(),
            PrimaryButton(
              label: AppString.submit,
              onPressed: () {
                _controller.addProjectSubmitOnTap(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectNameWidget() {
    return PrimaryTextField(
      labelText: AppString.projectName,
      controller: _controller.siteName,
      validator: projectNameValidator,
      hintText: AppString.enterProjectName,
      textInputAction: TextInputAction.done,
    );
  }
}
