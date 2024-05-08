part of 'widgets.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField({
    Key? key,
    this.hintText,
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.maxLine = 1,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.textColor,
    this.labelTextFontSize,
    this.borderColor,
    this.suffixIconName,
    this.focusNode,
    this.focusedBorder = AppColors.primaryColor,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final Color? textColor;
  final Color focusedBorder;
  final Color? borderColor;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? suffixIconName;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLine;
  final VoidCallback? onTap;
  final double? labelTextFontSize;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s10.h),
            child: Text(
              labelText!,
              style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: labelTextFontSize ?? Sizes.s16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        TextFormField(
          autocorrect: false,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: Sizes.s16.sp,
            fontWeight: FontWeight.w400,
          ),
          maxLines: maxLine,
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          validator: validator,
          readOnly: readOnly,
          cursorColor: AppColors.primaryColor,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: Sizes.s14.sp, color: AppColors.greyFontColor),
            errorStyle: TextStyle(
              fontSize: Sizes.s12.sp,
              color: Colors.red,
            ),
            suffixIconConstraints:
                BoxConstraints(minHeight: Sizes.s20.w, minWidth: Sizes.s20.w),
            enabledBorder: _border(borderColor ?? AppColors.borderColor),
            focusedBorder: _border(focusedBorder),
            errorBorder: _border(AppColors.redColor),
            focusedErrorBorder: _border(AppColors.redColor),
            suffixIcon: suffixIcon ??
                ((suffixIconName?.isNotEmpty ?? false)
                    ? Padding(
                        padding: EdgeInsets.only(right: Sizes.s12.w),
                        child: SvgPicture.asset(
                          suffixIconName!,
                          height: Sizes.s20.h,
                          width: Sizes.s20.h,
                        ),
                      )
                    : const SizedBox.shrink()),
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.s10.r),
      borderSide: BorderSide(color: color, width: Sizes.s1.h / 2),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
    this.hintText,
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.maxLine = 1,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.textColor,
    this.labelTextFontSize,
    this.focusNode,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final Color? textColor;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLine;
  final VoidCallback? onTap;
  final double? labelTextFontSize;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      style: TextStyle(
        color: Colors.black,
        fontSize: Sizes.s16.sp,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      controller: controller,
      onChanged: onChanged,
      cursorColor: AppColors.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText ?? 'Search...',
        hintStyle: TextStyle(
            color: AppColors.greyTextColor,
            fontSize: Sizes.s16.sp,
            fontWeight: FontWeight.w400),
        errorStyle: TextStyle(
          fontSize: Sizes.s14.sp,
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: Sizes.s20.h, vertical: Sizes.s8.h),
        enabledBorder: _border(),
        fillColor: AppColors.borderColor.withOpacity(0.5),
        filled: true,
        focusedBorder: _border(),
        errorBorder: _border(),
        focusedErrorBorder: _border(),
        suffixIcon: suffixIcon ??
            Icon(
              Icons.search,
              size: Sizes.s22.h,
              color: AppColors.greyTextColor,
            ),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.s10.r),
      borderSide: BorderSide(width: Sizes.s1.h / 2, color: Colors.transparent),
    );
  }
}
