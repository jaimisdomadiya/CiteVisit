import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/const.dart';
import 'package:cityvisit/core/utils/notification_service/firebase_notification.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/debug.dart';
import 'package:cityvisit/routes/route_generator.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(
        PushNotificationService.firebaseMessagingBackgroundHandler);
    Const.cameras = await availableCameras();
  } on CameraException catch (e) {
    log("${e.code}\nError Message: ${e.description}", name: 'CameraException');
  }
  Preferences.init();

  runApp(const CityVisit());
  ErrorWidget.builder = (details) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(PaddingValues.padding.h),
        child: ErrorText(details.exception.toString()),
      ),
    );
  };

  Debug.enabled = true;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class CityVisit extends StatelessWidget {
  const CityVisit({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: kAppName,
          navigatorKey: kNavigatorKey,
          theme: ThemeUtils.theme,
          initialRoute: Routes.splash,
          getPages: GetPages.getPages,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const _ScrollBehaviorModified(),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}

class _ScrollBehaviorModified extends ScrollBehavior {
  const _ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
