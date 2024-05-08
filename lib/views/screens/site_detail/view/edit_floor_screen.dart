import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditFloorScreen extends StatefulWidget {
  const EditFloorScreen({Key? key}) : super(key: key);

  @override
  State<EditFloorScreen> createState() => _EditFloorScreenState();
}

class _EditFloorScreenState extends State<EditFloorScreen> {
  final SiteDetailController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: _controller.floorPlan[_controller.selectedAreaIndex.value]
                .floorData?[_controller.selectedFloorIndex.value].floorName ??
            '',
      ),
      body: FlexibleScrollView(
        hasScrollBody: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.symmetric(horizontal: Sizes.s24.w),
        children: [
          Text(
            AppString.selectBelowImageEditText,
            style: TextStyle(
                fontSize: Sizes.s12.sp, color: AppColors.greyFontColor),
          ),
          SizedBoxH25(),
          (_controller
                      .floorPlan[_controller.selectedAreaIndex.value]
                      .floorData?[_controller.selectedFloorIndex.value]
                      .imageData
                      ?.isNotEmpty ??
                  false)
              ? GridView.builder(
                  itemCount: _controller
                          .floorPlan[_controller.selectedAreaIndex.value]
                          .floorData?[_controller.selectedFloorIndex.value]
                          .imageData
                          ?.length ??
                      0,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.0),
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _controller.capturedImageUrl.value = _controller
                                .floorPlan[_controller.selectedAreaIndex.value]
                                .floorData?[
                                    _controller.selectedFloorIndex.value]
                                .imageData?[index]
                                .img ??
                            '';
                        _controller.selectedImageIndex.value = index;
                        _controller.addFloorSelectedValue.value = _controller
                                .floorPlan[_controller.selectedAreaIndex.value]
                                .floorData?[
                                    _controller.selectedFloorIndex.value]
                                .floorName ??
                            '';
                        Get.toNamed(Routes.editPhoto,
                            arguments: {"isFromEdit": true});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Sizes.s12.r),
                        ),
                        child: ImageView(
                          imageUrl: _controller
                                  .floorPlan[
                                      _controller.selectedAreaIndex.value]
                                  .floorData?[
                                      _controller.selectedFloorIndex.value]
                                  .imageData?[index]
                                  .img ??
                              '',
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                )
              : const Expanded(
                  child: Center(
                    child: ErrorText("No data found"),
                  ),
                )
        ],
      ),
    );
  }
}
