import 'dart:developer';

import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/debug.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/service/client/base_response.dart';
import 'package:cityvisit/service/client/header_builder.dart';
import 'package:cityvisit/service/client/interceptor.dart';
import 'package:cityvisit/service/client/result.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;

export 'base_response.dart';
export 'result.dart';

enum RequestType { post, get, put, delete }

abstract class ClientService {
  final Dio _dio = Dio();

  final String _baseUrl = 'http://3.11.96.181:3001';

  Future<Result<BaseResponse<dynamic>, String>> request({
    required RequestType requestType,
    required String? path,
    dynamic body,
    bool isAuthenticated = false,
  }) async {
    String url = '$_baseUrl/$path';

    _dio.interceptors.add(CacheInterceptor());

    Map<String, String> defaultHeaders =
        HeaderBuilder().setBearerToken(preferences.token).build();

    Debug.d('$url - $body', tag: requestType.name.toUpperCase());
    Debug.d(defaultHeaders.toString(), tag: "Header");

    Options options = Options(
      headers: isAuthenticated ? defaultHeaders : null,
      responseType: ResponseType.json,
      contentType: 'application/json',
    );

    Response? response;

    try {
      switch (requestType) {
        // Send a POST request with the given parameter.
        case RequestType.post:
          response = await _dio.post(
            url,
            data: body,
            options: options,
          );
          break;

        // Send a GET request with the given parameter.
        case RequestType.get:
          response = await _dio.get(url, options: options);
          break;

        case RequestType.put:
          response = await _dio.put(url, data: body, options: options);
          break;

        case RequestType.delete:
          response = await _dio.delete(url, data: body, options: options);
          break;

        default:
          return throw RequestTypeNotFoundException(
              'The HTTP request mentioned is not found');
      }
      log(response.data.toString(), name: "response");
      Debug.log('$_baseUrl/$path ==> ${response.data}');
      var result = BaseResponse.fromResponse(response.data);
      return Success(result);
      //
    } on DioError catch (e, stackStrace) {
      log(e.toString(), name: "Error");
      log(stackStrace.toString(), name: "stackStrace");
      if (e.response?.statusCode == 401) {
        Get.Get.offAllNamed(Routes.signIn);
        return Failure(e.error);
      } else if (e.response?.statusCode == 404) {
        return Failure(e.error);
      } else {
        if (e.response != null && e.response?.data != null) {
          var result = BaseResponse.fromResponse(e.response?.data);

          return Failure(result.message);
        }
      }
      return Failure(e.message);
      //
    } catch (e, stackStrace) {
      log(e.toString(), name: "Catch");
      log(stackStrace.toString(), name: "stackStrace");
      return Failure(e.toString());
    }
  }

  Future<Result<dynamic, String>> postRequest({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    Options options = Options(
      responseType: ResponseType.json,
      headers: headers,
      contentType: 'application/json',
    );
    try {
      final Response response =
          await _dio.post(url, options: options, data: data);

      Debug.log('${response.statusCode} $url => ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(response.data);
      }
      return Failure(response.statusMessage ?? '');
    } on DioError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<dynamic, String>> getRequest(
      {required String url, Map<String, dynamic>? headers}) async {
    Options options = Options(
      responseType: ResponseType.json,
      headers: headers,
      contentType: 'application/json',
    );
    try {
      final Response response = await _dio.get(url, options: options);

      Debug.log('${response.statusCode} $url => ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(response.data);
      }
      return Failure(response.statusMessage ?? '');
    } on DioError catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

// Request type not found exception
class RequestTypeNotFoundException implements Exception {
  String cause;

  RequestTypeNotFoundException(this.cause);
}
