
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
  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await _dio.get('products/$id');

      if (response.data is! Map) {
        throw Exception('Invalid product response');
      }

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(
        'Failed to load product: ${e.message}',
      );
    }
  }
  Future<List<dynamic>> getProducts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        'products',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

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
