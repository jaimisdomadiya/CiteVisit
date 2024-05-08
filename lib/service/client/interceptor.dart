import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CacheInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      kNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.splash,
        (Route<dynamic> route) => false,
      );
    }
    super.onResponse(response, handler);
  }
}
