import 'package:cityvisit/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryColorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PrimaryColorAppBar(
      {super.key, this.statusBarColor = AppColors.primaryColor});

  final Color statusBarColor;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light),
      backgroundColor: AppColors.primaryColor,
      toolbarHeight: 0,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
