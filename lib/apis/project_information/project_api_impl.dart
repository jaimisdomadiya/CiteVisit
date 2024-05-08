part of 'project_api.dart';

abstract class ProjectService extends ClientService implements ProjectApi {}

class _ProjectApiImpl extends ProjectService {
  @override
  Future<Result<List<ProjectModal>, String>> homeApi(
      {required String? search, required String? page}) async {
    var result = await request(
        requestType: RequestType.get,
        path: '${ApiEndPoints.home}$search&page=$page&type=0',
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          List<ProjectModal> projectList = [];
          projectList =
              List.from(response.data.map((e) => ProjectModal.fromJson(e)));
          return Success(projectList);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addProject(
      {required String? name, required String? imageUrl}) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addProject,
        body: {"project_name": name, "project_image": imageUrl, "type": "0"},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> uploadImage(File file) async {
    FormData formData =
        FormData.fromMap({'image': await MultipartFile.fromFile(file.path)});
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.uploadImage,
        body: formData,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response.data['url']);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addMember(
      AddMemberRequest addMemberRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addMember,
        body: addMemberRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          BaseResponse baseResponse = BaseResponse(
            message: response.message,
            status: response.status,
            data: Employees.fromJson(response.data),
          );
          return Success(baseResponse);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<AreaAndEmployeeData, String>> getAreaAndEmployeeData() async {
    var result = await request(
        requestType: RequestType.get,
        path: ApiEndPoints.getArea,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          AreaAndEmployeeData areaAndEmployeeData =
              AreaAndEmployeeData.fromJson(response.data);
          return Success(areaAndEmployeeData);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addArea(String areaName) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addArea,
        body: {
          "area_name": areaName,
        },
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addSite(AddSiteRequest areaName) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addSite,
        body: areaName.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> uploadProfileImage(File file) async {
    FormData formData =
        FormData.fromMap({'image': await MultipartFile.fromFile(file.path)});
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.businessUserProfile,
        body: formData,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response.data['url']);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<SiteModal, String>> getSites(
      GetSitesModal getSitesModal) async {
    var result = await request(
        requestType: RequestType.post,
        body: getSitesModal.toJson(),
        path: ApiEndPoints.getSites,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          SiteModal siteModal = SiteModal.fromJson(response.data);
          return Success(siteModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<EmployeeModal, String>> getEmployee(
      GetEmployee getEmployee) async {
    var result = await request(
        requestType: RequestType.post,
        body: getEmployee.toJson(),
        path: ApiEndPoints.getEmployee,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          EmployeeModal employeeModal = EmployeeModal.fromJson(response.data);
          return Success(employeeModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> deleteSite(String siteId) async {
    var result = await request(
        requestType: RequestType.delete,
        path: ApiEndPoints.deleteSite,
        body: {"site_id": siteId},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> deleteEmployee(
      String employeeId, String projectId) async {
    var result = await request(
        requestType: RequestType.delete,
        path: ApiEndPoints.deleteEmployee,
        body: {"employee_id": employeeId, "project_id": projectId},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<SiteDetailModal, String>> siteDetail(String siteId) async {
    var result = await request(
        requestType: RequestType.post,
        body: {"site_id": siteId},
        path: ApiEndPoints.getSiteDetails,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          SiteDetailModal siteDetailModal =
              SiteDetailModal.fromJson(response.data);
          return Success(siteDetailModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> deleteArea(
      String siteId, String araName) async {
    var result = await request(
        requestType: RequestType.post,
        body: {"site_id": siteId, "area_name": araName},
        path: ApiEndPoints.deleteArea,
        isAuthenticated: true);

    return result.when(
      (response) {
        return Success(response);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addAreaForSpecificSite(
      String siteId, List<String> areaName) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addAreaForSite,
        body: {
          "site_id": siteId,
          "area_name": areaName,
        },
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addFloorForSpecificSite(
      String siteId, String areaName, String floorName) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addFloorForSite,
        body: {
          "site_id": siteId,
          "area_name": areaName,
          "floor_name": floorName,
        },
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> deleteFloorForSpecificSite(
      String siteId, String areaName, String floorName) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.deleteFloorForSite,
        body: {
          "site_id": siteId,
          "area_name": areaName,
          "floor_name": floorName,
        },
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> deleteFloorImageForSpecificSite(
      String siteId, String areaName, String floorName, String image) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.deleteFloorImage,
        body: {
          "site_id": siteId,
          "area_name": areaName,
          "floor_name": floorName,
          "img": image,
        },
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addIndividualFloorImage(
      IndividualFloorImageRequest individualFloorImageRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addIndividualFloorImage,
        body: individualFloorImageRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> editIndividualFloorImage(
      UpdateIndividualFloorImageRequest
          updateIndividualFloorImageRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.updateIndividualFloorImage,
        body: updateIndividualFloorImageRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<SiteAndEmployeeRoleModal, String>> getProjectWiseSiteData(
      String projectId) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.projectWiseSiteData,
        body: {"project_id": projectId},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          SiteAndEmployeeRoleModal siteAndEmployeeRoleModal =
              SiteAndEmployeeRoleModal.fromJson(response.data);
          return Success(siteAndEmployeeRoleModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<AddCommentModal, String>> addComment(
      AddCommentRequest addCommentRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addComment,
        body: addCommentRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          AddCommentModal addCommentModal =
              AddCommentModal.fromJson(response.data);
          return Success(addCommentModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<AddSubCommentModal, String>> addSubComment(
      AddSubCommentRequest addSubCommentRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addSubComment,
        body: addSubCommentRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          AddSubCommentModal addSubCommentModal =
              AddSubCommentModal.fromJson(response.data);
          return Success(addSubCommentModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<CommentModal>, String>> getComment(String image) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.getComment,
        body: {"floorimg": image},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          List<CommentModal> commentList = [];
          commentList =
              List.from(response.data.map((e) => CommentModal.fromJson(e)));
          return Success(commentList);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> addMemberWithSite(
      AddMemberWithSiteRequest addMemberRequest) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.addMemberWithSite,
        body: addMemberRequest.toJson(),
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }
}
