import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:sistema_distribuido/core/config/app_config.dart';
import 'auth_interceptor.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 15);

  static String get _authBaseUrl => AppConfig.authBaseUrl;

  static Dio createAuthDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _authBaseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Ignora certificado auto-assinado do ambiente de desenvolvimento
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('[ApiClient] $obj'),
    ));

    return dio;
  }

  static Dio createMainDio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Ignora certificado auto-assinado do ambiente de desenvolvimento
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('[ApiClient] $obj'),
    ));

    return dio;
  }
}
