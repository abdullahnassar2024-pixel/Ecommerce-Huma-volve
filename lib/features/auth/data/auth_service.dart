
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1/',
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: {
          'email': email.trim(),
          'password': password.trim(),
        },
      );

      final data = response.data;

      if (data is! Map || data['access_token'] is! String) {
        throw Exception('Invalid login response');
      }

      return data['access_token'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      }

      if (e.response?.statusCode == 400) {
        throw Exception('Please check your login details');
      }

      if (_isConnectionError(e)) {
        throw Exception('Please check your internet connection');
      }

      throw Exception('Login failed. Please try again');
    }
  }

  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'users/',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': 'https://picsum.photos/seed/user/150/150',
        },
      );

      if (response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception('Account creation failed');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 400 || statusCode == 409) {
        debugPrint('Sign Up Status: $statusCode');
        debugPrint('Sign Up Error: ${e.response?.data}');

        throw Exception(
          'Sign Up rejected: ${e.response?.data}',
        );
      }

      if (_isConnectionError(e)) {
        throw Exception('Please check your internet connection');
      }

      throw Exception('Sign up failed. Please try again');
    }
  }

  static bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError;
  }
}
