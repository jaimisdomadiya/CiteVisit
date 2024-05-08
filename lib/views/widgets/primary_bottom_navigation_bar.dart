part of 'widgets.dart';

class PrimaryBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PrimaryBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Sizes.s16.r),
        topRight: Radius.circular(Sizes.s16.r),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.lightPrimaryColor,
        selectedLabelStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: Sizes.s14.sp,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.greyFontColor,
          fontSize: Sizes.s14.sp,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        items: _buildBottomNavigationBarItems(),
      ),
    );
  }

  Widget _buildImageIcon(
    String imagePath,
    String name, {
    Color color = AppColors.greyFontColor,
    double? size,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.s10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            height: size ?? Sizes.s22.h,
            width: size ?? Sizes.s22.h,
            color: color,
          ),
          SizedBoxW12(),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontSize: Sizes.s14.sp,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        label: '',
        icon: _buildImageIcon(AppAssets.home, "Home", size: Sizes.s26.h),
        activeIcon: _buildImageIcon(
          AppAssets.home,
          "Home",
          color: AppColors.primaryColor,
          size: Sizes.s26.h,
        ),
      ),
      BottomNavigationBarItem(
        label: '',
        icon: _buildImageIcon(AppAssets.profile, "My Account"),
        activeIcon: _buildImageIcon(
          AppAssets.profile,
          "My Account",
          color: AppColors.primaryColor,
        ),
      ),
    ];
  }
}
