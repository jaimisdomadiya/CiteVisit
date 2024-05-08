import 'dart:async';
import 'dart:developer';

import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/modals/project_detail/employee_modal.dart';
import 'package:cityvisit/modals/project_detail/site_modal.dart';
import 'package:cityvisit/modals/request/project_detail/get_employee.dart';
import 'package:cityvisit/modals/request/project_detail/get_sites_request.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetailController extends GetxController {
  final List<DateTime?> dialogCalendarPickerValue = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  ];
  RxBool isSitesLoading = false.obs;
  RxBool isEmployeeLoading = false.obs;
  TextEditingController search = TextEditingController();
  String projectId = '';
  RxString name = ''.obs;
  int sitePage = 1;
  int employeePage = 1;
  Timer? debounce;
  RxList<SiteData> siteList = <SiteData>[].obs;
  Rx<int> totalSites = 0.obs;
  RxList<EmployeeData> employeeList = <EmployeeData>[].obs;
  Rx<int> totalEmployee = 0.obs;
  RxBool isFilterSelected = false.obs;
  RxBool isSiePaginationEnd = false.obs;
  RxBool isEmployeePaginationEnd = false.obs;
  late TabController tabController;
  Rx<int> tabIndex = Rx(0);
  final ProjectApi _projectApi = ProjectApi.instance;
  RxBool isSearchTextEmpty = true.obs;

  ScrollController siteScrollController = ScrollController();
  ScrollController employeeScrollController = ScrollController();
  RxBool isSitePagination = false.obs;
  RxBool isEmployeePagination = false.obs;

  DateTime? startDate;
  DateTime? endDate;

  RxBool isSiteSearchTextEmpty = true.obs;
  RxBool isEmployeeSearchTextEmpty = true.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      projectId = Get.arguments['id'];
      name.value = Get.arguments['name'];
    }
    super.onInit();
  }

  void handleTabSelection() {
    tabController.index = tabController.index;
    tabIndex.value = tabController.index;
  }

  Future<void> getTotalSiteList({bool isFromSearch = false}) async {
    sitePage = 1;
    isSiePaginationEnd.value = false;
    if (!isFromSearch) {
      isSitesLoading.value = true;
      search.text = "";
    }
    var result = await _projectApi.getSites(
      GetSitesModal(
          page: sitePage.toString(),
          endDate: endDate != null ? endDate.toString() : '',
          projectId: projectId,
          search: search.text.trim(),
          startDate: startDate != null ? startDate.toString() : ''),
    );
    result.when(
      (response) {
        sitePage = sitePage + 1;
        totalSites.value = response.totalSites ?? 0;
        siteList.value = List.from(response.siteData ?? []);
        if (!isFromSearch) {
          isSitesLoading.value = false;
        }
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        if (!isFromSearch) {
          isSitesLoading.value = false;
        }
      },
    );
  }

  Future<void> getEmployeeList({bool isFromSearch = false}) async {
    employeePage = 1;
    isEmployeePaginationEnd.value = false;
    if (!isFromSearch) {
      isEmployeeLoading.value = true;
    }
    var result = await _projectApi.getEmployee(
      GetEmployee(
        page: employeePage.toString(),
        projectId: projectId,
        search: search.text.trim(),
      ),
    );
    result.when(
      (response) {
        employeePage = employeePage + 1;
        totalEmployee.value = response.totalEmployees ?? 0;
        employeeList.value = List.from(response.employeeData ?? []);
        if (!isFromSearch) {
          isEmployeeLoading.value = false;
        }
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        if (!isFromSearch) {
          isEmployeeLoading.value = false;
        }
      },
    );
  }

  Future<void> deleteSite(int index) async {
    Loader.show(Get.context!);

    var result = await _projectApi.deleteSite(siteList[index].id ?? '');
    result.when(
      (response) {
        if (response.status) {
          siteList.removeAt(index);
          totalSites.value--;
        }
        Get.context!.showSnackBar(response.message);
        Loader.dismiss(Get.context!);
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        Loader.dismiss(Get.context!);
      },
    );
  }

  Future<void> deleteEmployee(int index) async {
    Loader.show(Get.context!);

    var result = await _projectApi.deleteEmployee(employeeList[index].id ?? '', projectId);
    result.when(
      (response) {
        if (response.status) {
          employeeList.removeAt(index);
          totalEmployee.value--;
        }
        Get.context!.showSnackBar(response.message);
        Loader.dismiss(Get.context!);
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        Loader.dismiss(Get.context!);
      },
    );
  }

  Future<void> onSearchHandler(String query) async {
    if(query.trim().isEmpty){
      return;
    }

    if (query.trim().isNotEmpty) {
      isSearchTextEmpty.value = false;
    } else {
      isSearchTextEmpty.value = true;
    }

    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isNotEmpty) {
        if (tabIndex.value == 0) {
          await getTotalSiteList(isFromSearch: true);
        } else {
          await getEmployeeList(isFromSearch: true);
        }
      } else {
        if (tabIndex.value == 0) {
          await getTotalSiteList();
        } else {
          await getEmployeeList();
        }
      }
    });
  }

  Future<void> getSitesPagination() async {
    var result = await _projectApi.getSites(
      GetSitesModal(
          page: sitePage.toString(),
          endDate: endDate != null ? endDate.toString() : '',
          projectId: projectId,
          search: search.text.trim(),
          startDate: startDate != null ? startDate.toString() : ''),
    );
    result.when(
      (response) {
        siteList.addAll(List.from(response.siteData ?? []));
        sitePage = sitePage + 1;
        isSitePagination.value = false;
        if (response.siteData?.isEmpty ?? true) {
          isSiePaginationEnd.value = true;
        }
      },
      (error) {
        log("response ==> $error");
        isSitePagination.value = false;

        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> getEmployeePagination() async {
    var result = await _projectApi.getEmployee(
      GetEmployee(
        page: employeePage.toString(),
        projectId: projectId,
        search: search.text.trim(),
      ),
    );
    result.when(
      (response) {
        employeePage = employeePage + 1;
        employeeList.addAll(List.from(response.employeeData ?? []));
        isEmployeePagination.value = false;
        if (response.employeeData?.isEmpty ?? true) {
          isEmployeePaginationEnd.value = true;
        }
      },
      (error) {
        log("response ==> $error");
        isEmployeePagination.value = false;

        Get.context!.showSnackBar(error);
      },
    );
  }

  Future<void> sitePaginationApi() async {
    if (!isSitePagination.value &&
        siteScrollController.position.pixels ==
            siteScrollController.position.maxScrollExtent &&
        siteScrollController.position.axisDirection == AxisDirection.down &&
        !isSiePaginationEnd.value) {
      isSitePagination.value = true;
      await getSitesPagination();
    }
  }

  Future<void> employeePaginationApi() async {
    if (!isEmployeePagination.value &&
        employeeScrollController.position.pixels ==
            employeeScrollController.position.maxScrollExtent &&
        employeeScrollController.position.axisDirection == AxisDirection.down &&
        !isEmployeePaginationEnd.value) {
      isEmployeePagination.value = true;
      await getEmployeePagination();
    }
  }
}
