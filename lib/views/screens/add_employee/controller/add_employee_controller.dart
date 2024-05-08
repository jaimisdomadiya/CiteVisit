import 'dart:developer';
import 'dart:io';

import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';
import 'package:cityvisit/modals/projects/site_and_employee_role_modal.dart';
import 'package:cityvisit/modals/request/site_details/add_member_request.dart';
import 'package:cityvisit/modals/request/site_details/add_member_site_request.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController with ValidationMixin {
  RxString accessValue = RxString("Only Comment");
  RxString memberRoleValue = RxString("Other");
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  final GlobalKey<FormState> addMemberFormKey = GlobalKey<FormState>();
  RxBool isDropDownOpen = false.obs;
  Rx<File> profileImage = Rx(File(''));
  final ProjectApi _projectApi = ProjectApi.instance;
  RxList<Employees> membersList = <Employees>[].obs;
  RxList<Areas> areasList = <Areas>[].obs;
  String projectId = '';
  RxList<String> employeesRoleList = <String>[].obs;
  RxList<SiteData> siteList = <SiteData>[].obs;
  TextEditingController employeeRole = TextEditingController();
  RxList<SiteData> selectedSite = <SiteData>[].obs;
  RxBool isMemberDropDownOpen = false.obs;
  RxList<Employees> selectedMemberList = <Employees>[].obs;
  RxBool isNewMemberAddFormShow = false.obs;
  RxBool isFromProjectDetails = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      projectId = Get.arguments["project_id"];
      isFromProjectDetails.value =
          Get.arguments["isFromProjectDetails"] ?? false;
      if (Get.arguments["isFromProjectDetails"] ?? false) {
        selectedSite.add(SiteData(siteId: Get.arguments["site_id"]));
      }
    }
    super.onInit();
  }

  void siteChanged(SiteData? site) {
    if (site != null && !selectedSite.contains(site)) {
      selectedSite.add(site);
    }
    isDropDownOpen.value = false;
  }

  void accessOnChanged(String? value) {
    if (value != null) {
      accessValue.value = value;
    }
  }

  void memberChanged(Employees? member) {
    if (member != null && !selectedMemberList.contains(member)) {
      selectedMemberList.add(member);
      isMemberDropDownOpen.value = false;
    }
  }

  final List<String> accessLevel = [
    'Add/Edit the site information',
    'Only Comment',
    'View Only',
  ];

  Future<void> addMember(BuildContext context) async {
    Loader.show(context);

    int accessLevelIndex =
        accessLevel.indexWhere((item) => item == accessValue.value);

    AddMemberRequest addMemberRequest = AddMemberRequest(
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      phoneNumber: phoneNo.text.trim(),
      employeeRole: memberRoleValue.value == "Other"
          ? employeeRole.text.trim()
          : memberRoleValue.value,
      type: "0",
      accessLevel: accessLevelIndex.toString(),
    );

    var result = await _projectApi.addMember(addMemberRequest);
    result.when(
      (response) {
        selectedMemberList.add(response.data);
        membersList.add(response.data);
        firstName.clear();
        lastName.clear();
        email.clear();
        phoneNo.clear();
        accessValue.value = "Only Comment";
        memberRoleValue.value = "Other";
        isNewMemberAddFormShow.value = false;
        Get.context!.showSnackBar(response.message);
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> addMemberWithSite(BuildContext context) async {
    Loader.show(context);

    List<String?> memberId =
        selectedMemberList.map((element) => element.id).toList();
    List<String> filterMemberId =
        memberId.where((element) => element != null).map((e) => e!).toList();

    List<String?> siteId =
        selectedSite.map((element) => element.siteId).toList();
    List<String> filterSiteId =
        siteId.where((element) => element != null).map((e) => e!).toList();

    AddMemberWithSiteRequest addMemberRequest = AddMemberWithSiteRequest(
        members: filterMemberId,
        projectId: projectId,
        siteId: filterSiteId,
        type: "0");

    var result = await _projectApi.addMemberWithSite(addMemberRequest);
    result.when(
      (response) {
        Get.context!.showSnackBar(response.message);
        Loader.dismiss(context);
        Get.back(result: true);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> getAreaAndEmployeeData(BuildContext context) async {
    Loader.show(context);

    var result = await _projectApi.getProjectWiseSiteData(projectId);
    result.when(
      (response) {
        siteList.value = List.from(response.siteName ?? []);
        employeesRoleList.value = List.from(response.employeeRole ?? []);
        membersList.value = List.from(response.employees ?? []);
        employeesRoleList.add("Other");
        Loader.dismiss(context);
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
      },
    );
  }
}
