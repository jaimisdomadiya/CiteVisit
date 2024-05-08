import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/project_detail/controller/project_detail_controller.dart';
import 'package:cityvisit/views/screens/project_detail/widget/delete_site_dialog.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TotalSitesListing extends StatefulWidget {
  const TotalSitesListing({Key? key}) : super(key: key);

  @override
  State<TotalSitesListing> createState() => _TotalSitesListingState();
}

class _TotalSitesListingState extends State<TotalSitesListing> {
  final ProjectDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isSitesLoading.value
          ? Center(child: Loader.circularProgressIndicator())
          : _controller.siteList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s25.w, vertical: Sizes.s15.h),
                        controller: _controller.siteScrollController,
                        itemCount: _controller.siteList.length,
                        itemBuilder: (context, index) {
                          return _buildTotalSitesWidget(index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBoxH25();
                        },
                      ),
                    ),
                    _controller.isSitePagination.value
                        ? Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: Sizes.s10.h),
                            child: Loader.circularProgressIndicator(),
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const Center(
                  child: ErrorText("No data found"),
                ),
    );
  }

  Widget _buildTotalSitesWidget(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.siteDetail, arguments: {
          "siteId": _controller.siteList[index].id,
          "projectId": _controller.projectId
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImageView(
                imageUrl: '${_controller.siteList[index].siteImage}',
                errorWidget:  ClipRRect(
                  borderRadius: BorderRadius.circular((Sizes.s12).r),
                  child: Image.asset(
                    AppAssets.citePlaceholder,
                    fit: BoxFit.cover,
                  ),
                ),
                height: Sizes.s180.h,
                width: double.infinity,
                radius: (Sizes.s12).r,
              ),
              Positioned(
                right: Sizes.s10.w,
                top: Sizes.s10.h,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      DeleteSiteDialog.show(context, () async {
                        Get.back();
                        await _controller.deleteSite(index);
                      });
                    },
                    child: SvgPicture.asset(AppAssets.roundRemove)),
              )
            ],
          ),
          SizedBoxH12(),
          Text(
            _controller.siteList[index].siteName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: Sizes.s16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBoxH10(),
          Text(
            _controller.siteList[index].siteAddress ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
          ),
          SizedBoxH12(),
          Row(
            children: [
              Text(
                "${_controller.siteList[index].imageCount ?? ''} Images",
                style: TextStyle(
                    fontSize: Sizes.s14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyFontColor),
              ),
              SizedBoxW12(),
              Text(
                "${_controller.siteList[index].noOfAreas ?? ''} Areas",
                style: TextStyle(
                    fontSize: Sizes.s14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyFontColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
