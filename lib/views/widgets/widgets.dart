import 'package:cached_network_image/cached_network_image.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

part 'expanded_section.dart';
part 'image_view.dart';
part 'loader.dart';
part 'primary_bottom_navigation_bar.dart';
part 'primary_text_field.dart';
part 'scrollable_column.dart';
part 'sized_box.dart';

class ErrorText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;

  const ErrorText(
    this.text, {
    Key? key,
    this.fontWeight,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? Sizes.s18.sp,
          color: Colors.black,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
