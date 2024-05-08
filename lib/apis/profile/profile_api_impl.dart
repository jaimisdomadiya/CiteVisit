part of 'profile_api.dart';

abstract class ProfileService extends ClientService implements ProfileApi {}

class _ProfileApiImpl extends ProfileService {
  @override
  Future<Result<ProfileModal, String>> getProfile() async {
    var result = await request(
        requestType: RequestType.get,
        path: ApiEndPoints.getProfile,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          ProfileModal profileModal = ProfileModal.fromJson(response.data);
          return Success(profileModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> updateProfile(
      UpdateProfileRequest updateProfileRequest) async {
    var result = await request(
        requestType: RequestType.put,
        path: ApiEndPoints.updatePersonalDetail,
        body: updateProfileRequest.toJson(),
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
  Future<Result<BaseResponse, String>> supportRequest(
      String inquiry, String userType) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.sendRequest,
        body: {"message": inquiry, "user_type": userType},
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
  Future<Result<String, String>> termsAndConditions() async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.termsAndConditions,
        body: {"type": "0"},
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          return Success(response.data['TermsAndCondition']);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> updatePassword(
      String email, String oldPassword, String newPassword) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.changePassword,
        body: {
          "email": email,
          "old_password": oldPassword,
          "new_password": newPassword
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
  Future<Result<List<NotificationModal>, String>> notification() async {
    var result = await request(
        requestType: RequestType.get,
        path: ApiEndPoints.notification,
        isAuthenticated: true);

    return result.when(
      (response) {
        if (response.status) {
          List<NotificationModal> commentList = [];
          commentList = List.from(
              response.data.map((e) => NotificationModal.fromJson(e)));

          return Success(commentList);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> logOut() async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.logOut,
        body: {"type": "0"},
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
