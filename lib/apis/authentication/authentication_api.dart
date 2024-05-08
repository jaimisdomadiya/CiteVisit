import 'package:cityvisit/core/utils/notification_service/firebase_notification.dart';
import 'package:cityvisit/modals/request/sign_up/sign_up_request.dart';
import 'package:cityvisit/modals/sign_in/sign_in_modal.dart';
import 'package:cityvisit/modals/sign_up/sign_up_modal.dart';
import 'package:cityvisit/service/client/api_endpoints.dart';
import 'package:cityvisit/service/services.dart';

part 'authentication_api_impl.dart';

abstract class AuthenticationApi {
  static final AuthenticationApi _instance = _AuthenticationApiImpl();

  Future<Result<SignInModal, String>> signIn({
    required String? email,
    required String? password,
  });

  Future<Result<dynamic, String>> socialSignIn({
    required String? email,
    required String? socialId,
  });

  Future<Result<SignUpModal, String>> signUp(SignUpRequest signUpRequest);

  Future<Result<BaseResponse, String>> sendOtp(String email);

  Future<Result<String, String>> otpVerify({
    required String? otp,
    required String? email,
  });

  Future<Result<String, String>> resetPassword({
    required String? email,
  });

  Future<Result<String, String>> createNewPassword({
    required String? password,
    required String? email,
  });

  static AuthenticationApi get instance => _instance;
}
