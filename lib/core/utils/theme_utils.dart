part of 'utils.dart';

class ThemeUtils {
  ThemeUtils._();

  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      backgroundColor: AppColors.whiteColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      fontFamily: 'SM Pro',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.dark),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color,
      100: color,
      200: color,
      300: color,
      400: color,
      500: color,
      600: color,
      700: color,
      800: color,
      900: color,
    });
  }
}
