import 'dart:async';
import 'dart:developer';

import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/modals/home/project_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ProjectApi _projectApi = ProjectApi.instance;
  RxBool isLoading = false.obs;
  TextEditingController search = TextEditingController();
  RxList<ProjectModal> projectList = <ProjectModal>[].obs;
  Timer? debounce;
  int page = 1;
  ScrollController scrollController = ScrollController();
  RxBool isPagination = false.obs;
  RxBool isPaginationEnd = false.obs;
  RxBool isSearchTextEmpty = true.obs;

  Future<void> getProjectList({bool isFromSearch = false}) async {
    page = 1;
    isPaginationEnd.value = false;
    if (!isFromSearch) {
      isLoading.value = true;
    }
    var result = await _projectApi.homeApi(
        search: search.value.text.trim(), page: page.toString());
    result.when(
      (response) {
        projectList.value = List.from(response);
        page = page + 1;
        if (!isFromSearch) {
          isLoading.value = false;
        }
      },
      (error) {
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        if (!isFromSearch) {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> getProjectPagination() async {
    var result = await _projectApi.homeApi(
        search: search.value.text.trim(), page: page.toString());
    result.when(
      (response) {
        projectList.addAll(List.from(response));
        page = page + 1;
        isPagination.value = false;
        if (response.isEmpty) {
          isPaginationEnd.value = true;
        }
      },
      (error) {
        log("response ==> $error");
        isPagination.value = false;

        Get.context!.showSnackBar(error);
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
        await getProjectList(isFromSearch: true);
      } else {
        await getProjectList();
      }
    });
  }

  Future<void> paginationApi() async {
    if (!isPagination.value &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.axisDirection == AxisDirection.down &&
        !isPaginationEnd.value) {
      isPagination.value = true;
      await getProjectPagination();
    }
  }
}
