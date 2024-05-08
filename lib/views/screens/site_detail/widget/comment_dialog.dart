import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommentDialog extends StatefulWidget {
  const CommentDialog({Key? key}) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();

  static Future<void> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      elevation: 0,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.s8.r),
          topRight: Radius.circular(Sizes.s8.r),
        ),
      ),
      builder: (context) {
        return const CommentDialog();
      },
    );
  }
}

class _CommentDialogState extends State<CommentDialog> {
  final SiteDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
          constraints:
              BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.55),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBoxH25(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  controller: _controller.scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => _controller.isCommentLoading.value
                            ? Loader.circularProgressIndicator()
                            : _controller.commentList.isNotEmpty
                                ? ListView.separated(
                                    itemCount: _controller.commentList.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ProfileView(
                                              imageUrl: _controller
                                                      .commentList[index]
                                                      .profilePic ??
                                                  '',
                                              name: _controller
                                                  .commentList[index].name,
                                              radius: Sizes.s50.r,
                                              height: Sizes.s30.w,
                                              width: Sizes.s30.w),
                                          SizedBoxW10(),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _controller.commentList[index]
                                                          .name ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: Sizes.s12.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBoxH04(),
                                                Text(
                                                  DateFormat(
                                                          "MMM dd,yyyy HH:mm")
                                                      .format(DateFormat(
                                                              "yyyy-MM-dd HH:mm:ss")
                                                          .parse(
                                                              _controller
                                                                      .commentList[
                                                                          index]
                                                                      .dateTime ??
                                                                  '',
                                                              true)
                                                          .toLocal()),
                                                  style: TextStyle(
                                                      fontSize: Sizes.s12.sp),
                                                ),
                                                SizedBoxH04(),
                                                Text(
                                                  _controller.commentList[index]
                                                          .comment ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: Sizes.s12.sp),
                                                ),
                                                (_controller
                                                            .commentList[index]
                                                            .subComments
                                                            ?.isNotEmpty ??
                                                        false)
                                                    ? Column(
                                                        children: [
                                                          SizedBoxH08(),
                                                          Obx(
                                                            () => (_controller
                                                                    .commentList[
                                                                        index]
                                                                    .isShowReply
                                                                    .value)
                                                                ? ListView
                                                                    .separated(
                                                                    padding: EdgeInsets.only(
                                                                        top: Sizes
                                                                            .s5
                                                                            .h),
                                                                    itemCount: _controller
                                                                            .commentList[index]
                                                                            .subComments
                                                                            ?.length ??
                                                                        0,
                                                                    shrinkWrap:
                                                                        true,
                                                                    primary:
                                                                        false,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index2) {
                                                                      return Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          ProfileView(
                                                                              imageUrl: _controller.commentList[index].subComments?[index2].profilePic ?? '',
                                                                              name: _controller.commentList[index].subComments?[index2].name,
                                                                              radius: Sizes.s50.r,
                                                                              height: Sizes.s30.w,
                                                                              width: Sizes.s30.w),
                                                                          SizedBoxW10(),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                _controller.commentList[index].subComments?[index2].name ?? '',
                                                                                style: TextStyle(fontSize: Sizes.s12.sp, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              SizedBoxH04(),
                                                                              Text(
                                                                                DateFormat("MMM dd,yyyy HH:mm").format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(_controller.commentList[index].subComments?[index2].dateTime ?? '', true).toLocal()),
                                                                                style: TextStyle(fontSize: Sizes.s12.sp),
                                                                              ),
                                                                              SizedBoxH04(),
                                                                              Text(
                                                                                _controller.commentList[index].subComments?[index2].comment ?? '',
                                                                                style: TextStyle(fontSize: Sizes.s12.sp),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return SizedBoxH25();
                                                                    },
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Container(
                                                                        color: AppColors
                                                                            .blackBackgroundColor,
                                                                        width: Sizes
                                                                            .s40
                                                                            .w,
                                                                        height: Sizes
                                                                            .s1
                                                                            .h,
                                                                      ),
                                                                      SizedBoxW5(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _controller
                                                                              .commentList[index]
                                                                              .isShowReply
                                                                              .value = true;
                                                                          // log("${_controller.commentList[index].isShowReply!.value}",
                                                                          // name: "isShowReply");
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "View ${_controller.commentList[index].subComments?.length} more reply",
                                                                          style: TextStyle(
                                                                              fontSize: Sizes.s10.sp,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                          )
                                                        ],
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              _controller.replyingUser.value =
                                                  _controller.commentList[index]
                                                          .name ??
                                                      '';
                                              _controller.replyingUserIndex
                                                  .value = index;
                                              _controller.commentFocusNde
                                                  .requestFocus();
                                            },
                                            child: const Icon(
                                              Icons.reply_rounded,
                                              color: AppColors.greyFontColor,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBoxH25();
                                    },
                                  )
                                : const Center(
                                    child: ErrorText("No data found"),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Sizes.s24.h, top: Sizes.s10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => _controller.replyingUser.value.isNotEmpty
                          ? Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.s12.w,
                                      vertical: Sizes.s10.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyTextColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Replying to ${_controller.replyingUser.value}",
                                        style:
                                            TextStyle(fontSize: Sizes.s12.sp),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _controller.replyingUser.value = '';
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(height: 4),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGreyColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: Sizes.s12.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controller.commentController,
                              focusNode: _controller.commentFocusNde,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppString.writeComment,
                                  hintStyle: TextStyle(
                                      fontSize: Sizes.s14.sp,
                                      color: AppColors.greyFontColor),
                                  fillColor: AppColors.primaryColor),
                            ),
                          ),
                          SizedBoxW12(),
                          Obx(
                            () => _controller.isMessageSend.value
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.primaryColor),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (_controller.commentController.text
                                          .trim()
                                          .isNotEmpty) {
                                        _controller
                                                .replyingUser.value.isNotEmpty
                                            ? _controller.addSubComment(context)
                                            : _controller.addComment(context);
                                      }
                                    },
                                    child: SvgPicture.asset(AppAssets.send),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
