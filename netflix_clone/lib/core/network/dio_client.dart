import 'package:dio/dio.dart';

import '../config/api_config.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          queryParameters: {'api_key': ApiConfig.apiKey},
        ),
      );

  Dio get dio => _dio;
}
