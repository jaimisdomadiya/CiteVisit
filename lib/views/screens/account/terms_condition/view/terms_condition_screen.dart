import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/utils/strings.dart';
import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_controller.dart';
import 'package:cityvisit/views/widgets/appbar/back_button_app_bar.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  final PersonalDetailController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.termsAndConditions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        titleText: AppString.termsAndConditions,
        fontSize: Sizes.s20.sp,
      ),
      body: Obx(
        () => _controller.isTermsAndConditionsLoading.value
            ? Loader.circularProgressIndicator()
            : Html(
                data: _controller.termsAndConditionData,
              ),
      ),
    );
  }
}
