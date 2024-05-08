import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/notification_service/firebase_notification.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/appbar/primary_color_status_bar.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateToNext() async {
    await Firebase.initializeApp();
    await PushNotificationService.getToken();
    PushNotificationService.initialize();

    if (preferences.isLogged) {
      Get.offAllNamed(Routes.bottomMenu);
    } else {
      Get.offAllNamed(Routes.signIn);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _navigateToNext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const PrimaryColorAppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.logo,
            ),
            SizedBoxH30(),
            Text(
              AppString.citeVisit.toUpperCase(),
              style: TextStyle(
                fontSize: 26.sp,
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
      ),
    );
  }
}
