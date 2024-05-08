import 'package:cityvisit/modals/notification/notification_modal.dart';
import 'package:cityvisit/modals/profile/profile_modal.dart';
import 'package:cityvisit/modals/request/update_profile/update_profile_request.dart';
import 'package:cityvisit/service/client/api_endpoints.dart';
import 'package:cityvisit/service/client/client_service.dart';

part 'profile_api_impl.dart';

abstract class ProfileApi {
  static final ProfileApi _instance = _ProfileApiImpl();
  static ProfileApi get instance => _instance;

  Future<Result<ProfileModal, String>> getProfile();

  Future<Result<BaseResponse, String>> updateProfile(
      UpdateProfileRequest updateProfileRequest);

  Future<Result<BaseResponse, String>> supportRequest(
      String inquiry, String userType);

  Future<Result<BaseResponse, String>> updatePassword(
      String email, String newPassword, String oldPassword);

  Future<Result<String, String>> termsAndConditions();

  Future<Result<List<NotificationModal>, String>> notification();

  Future<Result<BaseResponse, String>> logOut();

}
