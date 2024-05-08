import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final PersonalDetailController _controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.notification(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.notification,
      ),
      body: FlexibleScrollView.withSafeArea(
        hasScrollBody: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.s24.w, vertical: Sizes.s24.h),
        children: [
          Obx(
            ()=> ListView.separated(
              itemCount: _controller.notificationList.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.check, height: 30.h, width: 30.w),
                    SizedBoxW15(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.notificationList[index].title ?? '',
                            style: TextStyle(
                                fontSize: Sizes.s16.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBoxH04(),
                          Text(
                            _controller.notificationList[index].body ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Sizes.s12.sp, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBoxW5(),
                    Column(
                      children: [
                        Text(
                          DateFormat("MMM dd,yyyy").format(DateFormat("yyyy-MM-ddTHH:mm:ss.sssZ").parse(_controller.notificationList[index].createdAt ?? '', true).toLocal()),
                          style: TextStyle(
                              fontSize: Sizes.s12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyFontColor),
                        ),Text(
                          DateFormat("HH:mm").format(DateFormat("yyyy-MM-ddTHH:mm:ss.sssZ").parse(_controller.notificationList[index].createdAt ?? '', true).toLocal()),
                          style: TextStyle(
                              fontSize: Sizes.s12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyFontColor),
                        ),
                      ],
                    ),
                  ],
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return const Divider(color: AppColors.blackColor);
            },
            ),
          )
        ],
      ),
    );
  }
}
