import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/modals/home/project_modal.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/home/controller/home_controller.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());

  @override
  initState() {
    super.initState();
    _controller.getProjectList();
    _controller.scrollController.addListener(() {
      _controller.paginationApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: FlexibleScrollView.withSafeArea(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        padding: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
        hasScrollBody: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Sizes.s25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.allProjects,
                  style: TextStyle(
                      fontSize: Sizes.s20.sp, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () async {
                    var response = await Get.toNamed(Routes.createProject);
                    if (response != null && response) {
                      _controller.getProjectList();
                    }
                  },
                  child: Text(
                    "+ ${AppString.createProject}",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => _controller.isLoading.value
                ? Expanded(
                    child: Loader.circularProgressIndicator(),
                  )
                : _controller.projectList.isNotEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: GridView.count(
                                controller: _controller.scrollController,
                                crossAxisCount: 2,
                                crossAxisSpacing: Sizes.s16.w,
                                mainAxisSpacing: Sizes.s25.w,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.3),
                                children: List.generate(
                                  _controller.projectList.length,
                                  (index) => _buildProjectWidget(
                                      _controller.projectList[index]),
                                ),
                              ),
                            ),
                            _controller.isPagination.value
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Sizes.s10.h),
                                    child: Loader.circularProgressIndicator(),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      )
                    : const Expanded(
                        child: ErrorText("No data found"),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectWidget(ProjectModal projectModal) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.projectDetail, arguments: {
          'id': projectModal.id,
          'name': projectModal.projectName
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ImageView(
              imageUrl: projectModal.projectImage,
              height: Sizes.s150.h,
              width: double.infinity,
              radius: (Sizes.s16).r,
            ),
          ),
          SizedBoxH12(),
          Text(
            projectModal.projectName ?? '',
            style:
                TextStyle(fontSize: Sizes.s16.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            "${projectModal.sites ?? '0'} Sites",
            style:
                TextStyle(fontSize: Sizes.s12.sp, fontWeight: FontWeight.w400),
          ),
          SizedBoxH12(),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController _controller = Get.find();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                valueListenable: UserData().userName,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text.rich(
                    TextSpan(
                      text: '${AppString.welcome}\n',
                      style: TextStyle(
                          fontSize: Sizes.s18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyFontColor),
                      children: [
                        TextSpan(
                          text: value,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: Sizes.s24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: UserData().profileImage,
                builder: (BuildContext context, String value, Widget? child) {
                  return CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: (Sizes.s40.w / 1.5).r,
                    child: CircleAvatar(
                      backgroundColor: AppColors.whiteColor,
                      radius: (Sizes.s38.w / 1.5).r,
                      child: ImageView(
                        imageUrl: UserData().profileImage.value,
                        height: Sizes.s48.w,
                        width: Sizes.s48.w,
                        radius: (Sizes.s48 / 1.5).r,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBoxH25(),
          Obx(
            () => SearchTextField(
                controller: _controller.search,
                hintText: AppString.searchProjects,
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
                          await _controller.getProjectList();
                        },
                        child: Icon(
                          Icons.close,
                          size: Sizes.s22.h,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                onChanged: _controller.onSearchHandler),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Sizes.s150.h);
}
