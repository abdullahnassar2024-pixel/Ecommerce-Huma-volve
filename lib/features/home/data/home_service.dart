
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HomeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  HomeService() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('products');

      if (response.data is! List) {
        throw Exception('Invalid products response');
      }

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to load products: ${e.message}',
      );
    }
  }

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('categories');

      if (response.data is! List) {
        throw Exception('Invalid categories response');
      }

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Failed to load categories: ${e.message}',
      );
    }
  }
}
