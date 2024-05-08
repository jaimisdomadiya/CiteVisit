import 'package:cityvisit/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'app_assets.dart';
part 'app_colors.dart';
part 'app_font_family.dart';
part 'app_sizes.dart';

const String kAppName = 'Cite Visit';

final Preferences preferences = Preferences.instance;

GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();

const String kNoConnectionMessage =
    'No Internet Connection. Please check your internet connection.';

const String kErrorMessage = 'Something went wrong. Please try again later.';

const String kGoogleMapApiKey = 'AIzaSyC3MDh4g3G1POPU4PBb2LoCz0YpPyg1InM';

const String userStr = 'user';

const num totalPhotosMbSize = 25;

class PaddingValues {
  PaddingValues._();

  /// 20
  static const double padding = 20;

  /// 10
  static const double paddingSmall = 10;

  /// 15
  static const double paddingMedium = 15;
}

class BorderRadiusValues {
  BorderRadiusValues._();

  /// 20
  static const double radius = 20;

  /// 15
  static const double radiusMedium = 15;

  /// 10
  static const double radiusSmall = 10;

  /// 12
  static const double dialogBorderRadius = 12;
}

List<String> promptText = [
  "reception",
  "open workplace",
  "server room",
  "IT room",
  "furniture",
  "desk",
  "chair",
  "storage cabinet",
  "lighting",
  "system furniture",
  "loose furniture",
  "pantry",
  "kitchen",
  "wet pantry",
  "canteen",
  "cafe",
  "library",
  "meeting room",
  "training room",
  "partitions"
];
