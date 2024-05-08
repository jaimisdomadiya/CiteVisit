part of 'extensions.dart';

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  void showSnackBar(String message) {
    SnackBar snackBar = SnackBarUtils.snackBar(message: message);
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
