import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/account/widget/logout_dialog.dart';
import 'package:cityvisit/views/screens/bottom_menu/controller/bottom_menu_controller.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final BottomMenuController _controller = Get.find();

  @override
  void initState() {
    _controller.getProfile(isLoaderShow: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Obx(
        () => _controller.isLoading.value
            ? Loader.circularProgressIndicator()
            : ScrollableColumn.withSafeArea(
                children: [
                  _buildProfileWidget(),
                  _buildProjectDetailWidget(),
                  _buildAccountOption(),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light),
      backgroundColor: AppColors.primaryColor,
      toolbarHeight: 0,
      elevation: 0,
    );
  }

  Widget _buildProfileWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF537FF1),
            Color(0xFF2D57C5),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBoxH25(),
          ValueListenableBuilder(
            valueListenable: UserData().profileImage,
            builder: (BuildContext context, String value, Widget? child) {
              return CircleAvatar(
                backgroundColor: AppColors.whiteColor,
                radius: (Sizes.s82 / 1.5).r,
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: (Sizes.s80 / 1.5).r,
                  child: ImageView(
                    imageUrl: UserData().profileImage.value,
                    height: Sizes.s90.w,
                    width: Sizes.s90.w,
                    radius: (Sizes.s80 / 1.5).r,
                  ),
                ),
              );
            },
          ),
          SizedBoxH15(),
          ValueListenableBuilder(
            valueListenable: UserData().userName,
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                value,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: Sizes.s24.sp,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          SizedBoxH15(),
          ValueListenableBuilder(
            valueListenable: UserData().email,
            builder: (BuildContext context, String value, Widget? child) {
              return Text(
                value,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: Sizes.s16.sp,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
          SizedBoxH25(),
        ],
      ),
    );
  }

  Widget _buildProjectDetailWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Sizes.s16.h),
      color: AppColors.lightBlueColor,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
              valueListenable: UserData().projectCount,
              builder: (BuildContext context, value, Widget? child) {
                return _buildProjectInfoWidget(
                    title: "Total Projects",
                    value: UserData().projectCount.value);
              },
            ),
            _buildVerticalDivider(),
            ValueListenableBuilder(
              valueListenable: UserData().siteCount,
              builder: (BuildContext context, String value, Widget? child) {
                return _buildProjectInfoWidget(
                    title: "Total Sites", value: UserData().siteCount.value);
              },
            ),
            _buildVerticalDivider(),
            ValueListenableBuilder(
              valueListenable: UserData().memberCount,
              builder: (BuildContext context, value, Widget? child) {
                return _buildProjectInfoWidget(
                    title: "Total Members",
                    value: UserData().memberCount.value);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption() {
    return Padding(
      padding: EdgeInsets.all(24.0.h),
      child: Column(
        children: [
          _buildAccountTile(
              title: AppString.personalDetails,
              icon: AppAssets.profileOutline,
              onTap: () {
                Get.toNamed(Routes.personalDetail);
              }),
          if (!preferences.isSocialLogin)
            _buildAccountTile(
                title: AppString.updatePassword,
                icon: AppAssets.lock,
                onTap: () {
                  Get.toNamed(Routes.updatePassword);
                }),
          _buildAccountTile(
              title: AppString.supportRequest,
              icon: AppAssets.support,
              onTap: () {
                Get.toNamed(Routes.supportRequest);
              }),
          _buildAccountTile(
              title: AppString.termsAndConditions,
              icon: AppAssets.lock,
              onTap: () {
                Get.toNamed(Routes.termsCondition);
              }),
          _buildAccountTile(
              title: AppString.notification,
              icon: AppAssets.notification,
              onTap: () {
                Get.toNamed(Routes.notification);
              }),
          _buildAccountTile(
              title: AppString.logout,
              icon: AppAssets.logout,
              onTap: _logoutOnTap),
        ],
      ),
    );
  }

  Future<void> _logoutOnTap() async {
    LogoutDialog.show(
      context,
      () async {
        _controller.logOut(context);
      },
    );
  }

  Widget _buildProjectInfoWidget(
      {required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1C1C1C),
            fontSize: Sizes.s24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBoxH10(),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF1C1C1C),
            fontSize: Sizes.s14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return const VerticalDivider(
      thickness: 1,
    );
  }

  Widget _buildAccountTile(
      {required String icon,
      required String title,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: Sizes.s24.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              radius: (Sizes.s32 / 2).r,
              child: SvgPicture.asset(
                icon,
                height: Sizes.s20.h,
                width: Sizes.s20.h,
                color: Colors.white,
              ),
            ),
            SizedBoxW15(),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1C1C1C),
                fontSize: Sizes.s16.sp,
                // fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 24.0.h, right: 10.0.h),
                child: const Divider(
                  thickness: 1,
                  color: Color(0xFFE9E9E9),
                ),
              ),
            ),
            Text(
              "Follow for more update",
              style: TextStyle(
                color: const Color(0xFF9A9A9A),
                fontSize: Sizes.s14.sp,
                // fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0.h, right: 24.0.h),
                child: const Divider(
                  thickness: 1,
                  color: Color(0xFFE9E9E9),
                ),
              ),
            ),
          ],
        ),
        SizedBoxH15(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF6F3FD),
              radius: (Sizes.s40 / 2).r,
              child: SvgPicture.asset(
                AppAssets.instagram,
                height: Sizes.s22.h,
                width: Sizes.s22.h,
              ),
            ),
            SizedBoxW15(),
            CircleAvatar(
              backgroundColor: const Color(0xFFF6F3FD),
              radius: (Sizes.s40 / 2).r,
              child: SvgPicture.asset(
                AppAssets.facebook,
                height: Sizes.s20.h,
                width: Sizes.s20.h,
              ),
            )
          ],
        ),
        SizedBoxH15(),
      ],
    );
  }
}
