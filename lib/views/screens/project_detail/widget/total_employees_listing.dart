import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/screens/project_detail/controller/project_detail_controller.dart';
import 'package:cityvisit/views/screens/project_detail/widget/delete_employee_dialog.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TotalEmployeesListing extends StatefulWidget {
  const TotalEmployeesListing({Key? key}) : super(key: key);

  @override
  State<TotalEmployeesListing> createState() => _TotalEmployeesListingState();
}

class _TotalEmployeesListingState extends State<TotalEmployeesListing> {
  final ProjectDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isEmployeeLoading.value
          ? Center(child: Loader.circularProgressIndicator())
          : _controller.employeeList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: _controller.employeeScrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s25.w, vertical: Sizes.s15.h),
                        itemCount: _controller.employeeList.length,
                        itemBuilder: (context, index) {
                          return _buildTotalEmployeeWidget(index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBoxH15();
                        },
                      ),
                    ),
                    _controller.isEmployeePagination.value
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

  Widget _buildTotalEmployeeWidget(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ImageView(
              imageUrl: _controller.employeeList[index].profilePic ?? '',
              height: Sizes.s180.w,
              width: Sizes.s145.w,
              radius: (Sizes.s12).r,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes.s8.w, vertical: Sizes.s4.h),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.s12.r),
                    bottomLeft: Radius.circular(Sizes.s12.r),
                  ),
                ),
                child: Text(
                  _controller.employeeList[index].employeeRole ?? '',
                  style: TextStyle(
                      fontSize: Sizes.s10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor),
                ),
              ),
            )
          ],
        ),
        SizedBoxW12(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _controller.employeeList[index].name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: Sizes.s16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        DeleteEmployeeDialog.show(context, () async {
                          Get.back();
                          await _controller.deleteEmployee(index);
                        });
                      },
                      child: SvgPicture.asset(AppAssets.roundRemove)),
                ],
              ),
              SizedBoxH08(),
              Text(
                (_controller.employeeList[index].phoneNo ?? 0).toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBoxH08(),
              Text(
                _controller.employeeList[index].email ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBoxH08(),
              Text(
                _controller.employeeList[index].accessLevel ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBoxH08(),
              Text(
                AppString.associatedSites,
                style: TextStyle(
                    fontSize: Sizes.s12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyFontColor),
              ),
              SizedBoxH08(),
              ListView.separated(
                shrinkWrap: true,
                itemCount:
                    (_controller.employeeList[index].siteIds?.length ?? 0) >= 2
                        ? 2
                        : (_controller.employeeList[index].siteIds?.length ??
                            0),
                itemBuilder: (context, index2) {
                  return Text(
                    _controller.employeeList[index].siteIds?[index2] ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBoxH04();
                },
              ),
              (_controller.employeeList[index].siteIds?.length ?? 0) >= 3
                  ? Padding(
                      padding: EdgeInsets.only(top: Sizes.s4.h),
                      child: Text(
                        "+ ${(_controller.employeeList[index].siteIds?.length ?? 0) - 2} ${AppString.more}",
                        style: TextStyle(
                            fontSize: Sizes.s12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor),
                      ),
                    )
                  : const SizedBox.shrink()
              /*SizedBoxH08(),
              Text(
                "Silver Hub",
                style: TextStyle(
                    fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBoxH04(),
              Text(
                "Five Star Builders",
                style: TextStyle(
                    fontSize: Sizes.s14.sp, fontWeight: FontWeight.w400),
              ),
              SizedBoxH04(),
              Text(
                "+ 3 More",
                style: TextStyle(
                    fontSize: Sizes.s12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
