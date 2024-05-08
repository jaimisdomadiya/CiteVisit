part of 'authentication_api.dart';

abstract class AuthenticationService extends ClientService
    implements AuthenticationApi {}

class _AuthenticationApiImpl extends AuthenticationService {
  @override
  Future<Result<SignInModal, String>> signIn(
      {String? email, String? password}) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.signIn,
      body: {
        'email': email,
        'password': password,
        'device_token': PushNotificationService.firebaseToken
      },
    );

    return result.when(
      (response) {
        if (response.status) {
          SignInModal signInModal = SignInModal.fromJson(response.data);
          return Success(signInModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<SignUpModal, String>> signUp(
      SignUpRequest signUpRequest) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.signUp,
      body: signUpRequest.toJson(),
    );

    return result.when(
      (response) {
        if (response.status) {
          SignUpModal signUpModal = SignUpModal.fromJson(response.data);
          return Success(signUpModal);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> createNewPassword(
      {String? password, String? email}) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.updatePassword,
      body: {'new_password': password, 'email': email},
    );

    return result.when(
      (response) => Success(response.message),
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> otpVerify({String? otp, String? email}) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.verifyOtpEmail,
      body: {'email': email, 'otp': otp},
    );

    return result.when(
      (response) => Success(response.message),
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> resetPassword({String? email}) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.forgotPassword,
      body: {'email': email},
    );

    return result.when(
      (response) {
        if (response.status) {
          return Success(response.message);
        } else {
          return Failure(response.message);
        }
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<dynamic, String>> socialSignIn(
      {required String? email, required String? socialId}) async {
    var result = await request(
      requestType: RequestType.post,
      path: ApiEndPoints.socialSignIn,
      body: {'email': email, 'social_id': socialId},
    );

    return result.when(
      (response) {
        return Success(response);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<BaseResponse, String>> sendOtp(String email) async {
    var result = await request(
        requestType: RequestType.post,
        path: ApiEndPoints.sendOtp,
        body: {"email": email},
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
