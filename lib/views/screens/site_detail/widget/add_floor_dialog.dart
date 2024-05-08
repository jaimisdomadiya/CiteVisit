import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFloorDialog extends StatefulWidget {
  const AddFloorDialog({super.key, required this.areaName});
  final String areaName;

  static Future<void> show(BuildContext context, String areaName) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AddFloorDialog(areaName: areaName),
        );
      },
    );
  }

  @override
  State<AddFloorDialog> createState() => _AddFloorDialogState();
}

class _AddFloorDialogState extends State<AddFloorDialog> with ValidationMixin {
  final SiteDetailController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.selectAreaValue.value = '';
    _controller.floorNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s16.w, vertical: Sizes.s16.h),
        child: Form(
          key: _controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.addFloor,
                    style: TextStyle(
                      fontSize: Sizes.s16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child:
                          const Icon(Icons.close, color: AppColors.blackColor))
                ],
              ),
              // SizedBoxH15(),
              // _buildAreaWidget(),
              SizedBoxH15(),
              _buildFloorNameWidget(),
              SizedBoxH15(),
              PrimaryButton(
                label: AppString.save,
                onPressed: () async {
                  if (_controller.formKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    await _controller.addFloor(context, widget.areaName);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorNameWidget() {
    return PrimaryTextField(
      labelText: AppString.floorName,
      controller: _controller.floorNameController,
      validator: floorNameValidator,
      hintText: AppString.enterFloorName,
      textInputAction: TextInputAction.done,
    );
  }
}
