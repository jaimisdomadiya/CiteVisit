part of 'utils.dart';

const double _kElevation = 0;

const Duration _kDuration2000ms = Duration(milliseconds: 2000);

const SnackBarBehavior _kSnackBarBehavior = SnackBarBehavior.floating;

class SnackBarUtils {
  SnackBarUtils._();

  static SnackBar snackBar({
    required String message,
    Duration duration = _kDuration2000ms,
  }) {
    return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: Sizes.s14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.black,
      behavior: _kSnackBarBehavior,
      duration: duration,
      elevation: _kElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s8.r),
      ),
    );
  }
}
