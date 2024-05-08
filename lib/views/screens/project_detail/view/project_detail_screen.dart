import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/project_detail/controller/project_detail_controller.dart';
import 'package:cityvisit/views/screens/project_detail/widget/total_employees_listing.dart';
import 'package:cityvisit/views/screens/project_detail/widget/total_sites_listing.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/calender/calender_date_picker.dart';
import 'package:cityvisit/views/widgets/primary_button.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with TickerProviderStateMixin {
  final ProjectDetailController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _controller.tabController.addListener(
      () {
        _controller.handleTabSelection();
      },
    );
    _controller.getTotalSiteList();
    _controller.getEmployeeList();

    _controller.siteScrollController.addListener(() {
      _controller.sitePaginationApi();
    });
    _controller.employeeScrollController.addListener(() {
      _controller.employeePaginationApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [_buildTabBarWidget(), _buildTabBarViewWidget()],
        ),
      ),
      // floatingActionButton: floatingActionButton(),
    );
  }

  Widget _buildTabBarWidget() {
    return Padding(
      padding: EdgeInsets.only(
          left: Sizes.s24.w,
          right: Sizes.s24.w,
          bottom: Sizes.s10.h,
          top: Sizes.s10.h),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _controller.tabController.index = 0;
                _controller.tabIndex.value = 0;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '${AppString.totalSites} (${_controller.totalSites})',
                      style: TextStyle(
                        fontSize: _controller.tabIndex.value == 0
                            ? Sizes.s18.sp
                            : Sizes.s16.sp,
                        color: _controller.tabIndex.value == 0
                            ? AppColors.primaryColor
                            : AppColors.greyTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBoxH04(),
                  Container(
                    width: Sizes.s36.w,
                    height: Sizes.s2.h,
                    color: _controller.tabIndex.value == 0
                        ? AppColors.primaryColor
                        : Colors.transparent,
                  )
                ],
              ),
            ),
            SizedBoxW15(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _controller.tabController.index = 1;
                  _controller.tabIndex.value = 1;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        '${AppString.totalEmployees} (${_controller.totalEmployee})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: _controller.tabIndex.value == 1
                              ? Sizes.s18.sp
                              : Sizes.s16.sp,
                          color: _controller.tabIndex.value == 1
                              ? AppColors.primaryColor
                              : AppColors.greyTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBoxH04(),
                    Container(
                      width: Sizes.s36.w,
                      height: Sizes.s2.h,
                      color: _controller.tabIndex.value == 1
                          ? AppColors.primaryColor
                          : Colors.transparent,
                    )
                  ],
                ),
              ),
            ),
            SizedBoxW20(),
            _controller.tabIndex.value == 0
                ? GestureDetector(
                    onTap: () {
                      _controller.tabIndex.value == 0 ? _filterOnTap() : null;
                    },
                    child: Obx(
                      () => SvgPicture.asset(
                        AppAssets.filter,
                        height: Sizes.s20.h,
                        width: Sizes.s20.w,
                        color: _controller.isFilterSelected.value
                            ? AppColors.primaryColor
                            : AppColors.greyTextColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarViewWidget() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller.tabController,
        children: const [
          TotalSitesListing(),
          TotalEmployeesListing(),
        ],
      ),
    );
  }

  Future<void> _filterOnTap() async {
    var results = await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          weekdayLabels: ["S", "M", "T", "W", "T", "F", "S"],
          selectedDayHighlightColor: AppColors.primaryColor,
          gapBetweenCalendarAndButtons: 0,
          controlsTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          dayTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          disabledDayTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          selectedDayTextStyle:
              TextStyle(fontSize: Sizes.s16.sp, color: AppColors.whiteColor),
          selectedYearTextStyle:
              TextStyle(fontSize: Sizes.s16.sp, color: AppColors.whiteColor),
          todayTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          yearTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          weekdayLabelTextStyle: TextStyle(fontSize: Sizes.s16.sp),
          okButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s15.w),
            child: PrimaryButton(
              label: AppString.done,
            ),
          ),
          resetButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s15.w),
            child: PrimaryButton.outlined(
              label: AppString.reset,
            ),
          ),
        ),
        initialValue:
            (_controller.startDate != null) && (_controller.endDate != null)
                ? [_controller.startDate, _controller.endDate]
                : _controller.dialogCalendarPickerValue,
        borderRadius: BorderRadius.circular(15),
        onResetTapped: () async {
          _controller.isFilterSelected.value = false;
          _controller.endDate = null;
          _controller.startDate = null;
          await _controller.getTotalSiteList();
        });
    if (results != null && results.isNotEmpty) {
      List<DateTime?> dateTimeList = (results);
      if (dateTimeList.length == 2) {
        _controller.startDate = dateTimeList[0];
        _controller.endDate = dateTimeList[1];
        _controller.isFilterSelected.value = true;
        await _controller.getTotalSiteList();
      }
    }
  }

  Widget floatingActionButton() {
    return GestureDetector(
      onTap: () async {
        if (_controller.tabIndex.value == 0) {
          Get.toNamed(Routes.createNewSite, arguments: {
            "projectHeading": _controller.name.value,
            "projectId": _controller.projectId
          });
        } else {
          var response = await Get.toNamed(
            Routes.addEmployee,
            arguments: {"project_id": _controller.projectId},
          );
          if (response != null && (response as bool)) {
            _controller.getEmployeeList();
          }
        }
      },
      // child: const Icon(Icons.add),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Obx(
          () => Text(
            _controller.tabIndex.value == 0 ? "+ Add Site" : "+ Add\nMember",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: Sizes.s14.sp, color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  _AppBar({Key? key}) : super(key: key);

  final ProjectDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      titleSpacing: Sizes.s24.w,
      toolbarHeight: Sizes.s150.h,
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Row(
            children: [
              const PrimaryBackButton(),
              SizedBoxW15(),
              Expanded(
                child: Text(
                  _controller.name.value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: Sizes.s18.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBoxW15(),
              GestureDetector(
                onTap: () async {
                  if (_controller.tabIndex.value == 0) {
                    var response = await Get.toNamed(Routes.createNewSite,
                        arguments: {
                          "projectHeading": _controller.name.value,
                          "projectId": _controller.projectId
                        });
                    if (response != null && (response as bool)) {
                      _controller.getTotalSiteList();
                      _controller.getEmployeeList();
                    }
                  } else {
                    var response = await Get.toNamed(
                      Routes.addEmployee,
                      arguments: {"project_id": _controller.projectId},
                    );
                    if (response != null && (response as bool)) {
                      _controller.getEmployeeList();
                    }
                  }
                },
                child: Obx(
                  () => Text(
                    _controller.tabIndex.value == 0
                        ? AppString.addSite
                        : AppString.addEmployeePlus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Sizes.s16.sp,
                        color: AppColors.primaryColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBoxH25(),
          Obx(
            () => SearchTextField(
              controller: _controller.search,
              onChanged: _controller.onSearchHandler,
              suffixIcon: _controller.isSearchTextEmpty.value
                  ? Icon(
                      Icons.search,
                      size: Sizes.s22.h,
                      color: AppColors.greyTextColor,
                    )
                  : GestureDetector(
                      onTap: () async {
                        _controller.search.clear();
                        _controller.isSearchTextEmpty.value = true;
                        if (_controller.tabIndex.value == 0) {
                          await _controller.getTotalSiteList();
                        } else {
                          await _controller.getEmployeeList();
                        }
                      },
                      child: Icon(
                        Icons.close,
                        size: Sizes.s22.h,
                        color: AppColors.greyTextColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Sizes.s150.h);
}
