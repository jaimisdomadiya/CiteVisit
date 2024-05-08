import 'package:cityvisit/views/widgets/calender/calender_date_picker.dart';
import 'package:flutter/material.dart';

Future<List<DateTime?>?> showCalendarDatePicker2Dialog({
  required BuildContext context,
  required CalendarDatePicker2WithActionButtonsConfig config,
  List<DateTime?> initialValue = const [],
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
  Function? onResetTapped,
}) {
  var dialog = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    backgroundColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
    child: Material(
      color: dialogBackgroundColor ?? Theme.of(context).canvasColor,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalendarDatePicker2WithActionButtons(
            initialValue: initialValue,
            config: config.copyWith(openedFromDialog: true),
            onResetTapped: onResetTapped,
          ),
        ],
      ),
    ),
  );

  return showDialog<List<DateTime?>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}
