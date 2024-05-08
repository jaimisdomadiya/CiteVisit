part of 'widgets.dart';

const double _kLoaderSize = 14.0;

class Loader {
  Loader._();

  static Widget circularProgressIndicator([double size = _kLoaderSize]) {
    return Center(
      child: CupertinoActivityIndicator(radius: _kLoaderSize.h),
    );
  }

  static void show(BuildContext context) {
    Navigator.push(context, _LoaderDialog());
  }

  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

class _LoaderDialog extends RawDialogRoute {
  _LoaderDialog()
      : super(
          barrierColor: Colors.black.withOpacity(0.2),
          pageBuilder: (context, animation, secondaryAnimation) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Sizes.s70.h,
                    width: Sizes.s70.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          BorderRadiusValues.radiusSmall.r),
                    ),
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: _kLoaderSize.h,
                        color: AppColors.greyFontColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
