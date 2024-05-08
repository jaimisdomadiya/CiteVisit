import 'dart:io';

import 'package:cityvisit/modals/home/project_modal.dart';
import 'package:cityvisit/modals/project_detail/employee_modal.dart';
import 'package:cityvisit/modals/project_detail/site_modal.dart';
import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';
import 'package:cityvisit/modals/projects/site_and_employee_role_modal.dart';
import 'package:cityvisit/modals/request/project_detail/get_employee.dart';
import 'package:cityvisit/modals/request/project_detail/get_sites_request.dart';
import 'package:cityvisit/modals/request/site_details/add_comment_request.dart';
import 'package:cityvisit/modals/request/site_details/add_member_request.dart';
import 'package:cityvisit/modals/request/site_details/add_member_site_request.dart';
import 'package:cityvisit/modals/request/site_details/add_site_request.dart';
import 'package:cityvisit/modals/request/site_details/add_sub_comment_request.dart';
import 'package:cityvisit/modals/request/site_details/individual_floor_image_request.dart';
import 'package:cityvisit/modals/request/site_details/update_individual_floor_image_request.dart';
import 'package:cityvisit/modals/site_detail/add_comment_modal.dart';
import 'package:cityvisit/modals/site_detail/add_sub_comment_modal.dart';
import 'package:cityvisit/modals/site_detail/comment_modal.dart';
import 'package:cityvisit/modals/site_detail/site_detail_modal.dart';
import 'package:cityvisit/service/client/api_endpoints.dart';
import 'package:cityvisit/service/client/client_service.dart';
import 'package:dio/dio.dart';

part 'project_api_impl.dart';

abstract class ProjectApi {
  static final ProjectApi _instance = _ProjectApiImpl();

  static ProjectApi get instance => _instance;

  Future<Result<List<ProjectModal>, String>> homeApi(
      {required String? search, required String? page});

  Future<Result<BaseResponse, String>> addProject(
      {required String? name, required String? imageUrl});

  Future<Result<String, String>> uploadImage(File file);

  Future<Result<BaseResponse, String>> addMember(
      AddMemberRequest addMemberRequest);

  Future<Result<BaseResponse, String>> addMemberWithSite(
      AddMemberWithSiteRequest addMemberRequest);

  Future<Result<AreaAndEmployeeData, String>> getAreaAndEmployeeData();

  Future<Result<SiteAndEmployeeRoleModal, String>> getProjectWiseSiteData(
      String projectId);

  Future<Result<BaseResponse, String>> addArea(String areaName);

  Future<Result<BaseResponse, String>> addSite(AddSiteRequest areaName);

  Future<Result<String, String>> uploadProfileImage(File file);

  Future<Result<SiteModal, String>> getSites(GetSitesModal getSitesModal);

  Future<Result<EmployeeModal, String>> getEmployee(GetEmployee getEmployee);

  Future<Result<BaseResponse, String>> deleteSite(String siteId);

  Future<Result<BaseResponse, String>> deleteEmployee(String employeeId, String projectId);

  Future<Result<SiteDetailModal, String>> siteDetail(String siteId);

  Future<Result<BaseResponse, String>> deleteArea(
      String siteId, String araName);

  Future<Result<BaseResponse, String>> addAreaForSpecificSite(
      String siteId, List<String> areaName);

  Future<Result<BaseResponse, String>> addFloorForSpecificSite(
      String siteId, String areaName, String floorName);

  Future<Result<BaseResponse, String>> deleteFloorForSpecificSite(
      String siteId, String areaName, String floorName);

  Future<Result<BaseResponse, String>> deleteFloorImageForSpecificSite(
      String siteId, String areaName, String floorName, String image);

  Future<Result<BaseResponse, String>> addIndividualFloorImage(
      IndividualFloorImageRequest individualFloorImageRequest);

  Future<Result<BaseResponse, String>> editIndividualFloorImage(
      UpdateIndividualFloorImageRequest individualFloorImageRequest);

  Future<Result<AddCommentModal, String>> addComment(
      AddCommentRequest addCommentRequest);

  Future<Result<AddSubCommentModal, String>> addSubComment(
      AddSubCommentRequest addSubCommentRequest);

  Future<Result<List<CommentModal>, String>> getComment(String image);
}
