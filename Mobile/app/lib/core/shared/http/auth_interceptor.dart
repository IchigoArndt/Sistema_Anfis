import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sistema_distribuido/core/shared/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor(this._tokenStorage, this.navigatorKey);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isValid = await _tokenStorage.isTokenValid();
    if (!isValid) {
      await _tokenStorage.clearToken();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (_) => false,
      );
      handler.reject(
        DioException(
          requestOptions: options,
          message: 'Token expirado',
        ),
      );
      return;
    }
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _tokenStorage.clearToken();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (_) => false,
      );
    }
    handler.next(err);
  }
}
